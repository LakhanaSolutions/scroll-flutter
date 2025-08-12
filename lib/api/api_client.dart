import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  String? _sessionToken;
  String _language = 'en';
  late final String _deviceType;

  void initialize({String? baseUrl, String? language}) {
    _language = language ?? 'en';
    _deviceType = _getDeviceType();
    
    if (kDebugMode) {
      print('\n' + '=' * 60);
      print('🚀 API CLIENT INITIALIZATION');
      print('=' * 60);
      print('🌍 Base URL: ${baseUrl ?? ApiConstants.baseUrl}');
      print('🌍 Language: $_language');
      print('📱 Device Type: $_deviceType');
      print('⏱️  Timeouts: 30s (connect/receive/send)');
      print('=' * 60);
    }
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        ApiConstants.acceptHeader: ApiConstants.applicationJson,
        ApiConstants.userAgentHeader: 'Scroll Flutter App',
        ApiConstants.acceptLanguageHeader: _language,
        ApiConstants.deviceTypeHeader: _deviceType,
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    _loadSessionToken();
    _loadLanguage();
    
    if (kDebugMode) {
      print('✅ ApiClient initialized successfully\n');
    }
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final timestamp = DateTime.now();
    
    if (_sessionToken != null && _sessionToken!.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] = 
          '${ApiConstants.bearerPrefix}$_sessionToken';
    }

    // Ensure language and device headers are always present
    options.headers[ApiConstants.acceptLanguageHeader] = _language;
    options.headers[ApiConstants.deviceTypeHeader] = _deviceType;

    // Store timestamp for duration calculation
    options.extra['request_start_time'] = timestamp.millisecondsSinceEpoch;

    if (kDebugMode) {
      print('\n' + '=' * 80);
      print('📤 API REQUEST [${timestamp.toIso8601String()}]');
      print('=' * 80);
      print('🔗 ${options.method.toUpperCase()} ${options.uri}');
      
      if (options.queryParameters.isNotEmpty) {
        print('📋 Query Parameters:');
        options.queryParameters.forEach((key, value) {
          print('   $key: $value');
        });
      }
      
      print('📨 Headers:');
      options.headers.forEach((key, value) {
        // Hide sensitive headers in logs
        if (key.toLowerCase().contains('authorization')) {
          final token = value.toString();
          final maskedToken = token.length > 20 
              ? '${token.substring(0, 10)}...${token.substring(token.length - 10)}'
              : '***masked***';
          print('   $key: $maskedToken');
        } else {
          print('   $key: $value');
        }
      });
      
      if (options.data != null) {
        print('📦 Request Body:');
        try {
          final prettyData = _formatJson(options.data);
          print(prettyData);
        } catch (e) {
          print('   ${options.data}');
        }
      }
      
      print('⏱️  Request initiated at: ${timestamp.toLocal()}');
      print('=' * 80);
    }

    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final timestamp = DateTime.now();
      final requestStartTime = response.requestOptions.extra['request_start_time'] as int?;
      final duration = requestStartTime != null 
          ? timestamp.millisecondsSinceEpoch - requestStartTime
          : null;
      
      print('\n' + '=' * 80);
      print('📥 API RESPONSE [${timestamp.toIso8601String()}]');
      print('=' * 80);
      print('🔗 ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');
      print('✅ Status: ${response.statusCode} ${response.statusMessage ?? ''}');
      
      if (duration != null) {
        print('⏱️  Duration: ${duration}ms');
      }
      
      if (response.headers.map.isNotEmpty) {
        print('📨 Response Headers:');
        response.headers.map.forEach((key, values) {
          print('   $key: ${values.join(', ')}');
        });
      }
      
      if (response.data != null) {
        print('📦 Response Body:');
        try {
          final prettyData = _formatJson(response.data);
          print(prettyData);
        } catch (e) {
          print('   ${response.data}');
        }
      }
      
      print('✅ Response received at: ${timestamp.toLocal()}');
      print('=' * 80);
    }
    
    handler.next(response);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final timestamp = DateTime.now();
      final requestStartTime = error.requestOptions.extra['request_start_time'] as int?;
      final duration = requestStartTime != null 
          ? timestamp.millisecondsSinceEpoch - requestStartTime
          : null;
      
      print('\n' + '=' * 80);
      print('❌ API ERROR [${timestamp.toIso8601String()}]');
      print('=' * 80);
      print('🔗 ${error.requestOptions.method.toUpperCase()} ${error.requestOptions.uri}');
      print('❌ Error Type: ${error.type}');
      print('💬 Error Message: ${error.message ?? 'Unknown error'}');
      
      if (duration != null) {
        print('⏱️  Duration: ${duration}ms');
      }
      
      if (error.response != null) {
        print('📊 Response Status: ${error.response!.statusCode} ${error.response!.statusMessage ?? ''}');
        
        if (error.response!.data != null) {
          print('📦 Error Response Body:');
          try {
            final prettyData = _formatJson(error.response!.data);
            print(prettyData);
          } catch (e) {
            print('   ${error.response!.data}');
          }
        }
      }
      
      if (error.stackTrace != null) {
        print('📚 Stack Trace:');
        print(error.stackTrace.toString().split('\n').take(10).join('\n'));
      }
      
      print('❌ Error occurred at: ${timestamp.toLocal()}');
      print('=' * 80);
    }
    
    final apiException = ApiExceptionHandler.handleDioException(error);
    
    if (apiException is AuthenticationException) {
      _clearSessionToken();
    }
    
    handler.reject(error);
  }

  Future<void> _loadSessionToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _sessionToken = prefs.getString('session_token');
    } catch (e) {
      print('Failed to load session token: $e');
    }
  }

  Future<void> setSessionToken(String token) async {
    _sessionToken = token;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_token', token);
      if (kDebugMode) {
        final maskedToken = token.length > 20 
            ? '${token.substring(0, 10)}...${token.substring(token.length - 10)}'
            : '***masked***';
        print('🔐 Session token saved: $maskedToken');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to save session token: $e');
      }
    }
  }

  Future<void> _clearSessionToken() async {
    _sessionToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('session_token');
      if (kDebugMode) {
        print('🧼 Session token cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to clear session token: $e');
      }
    }
  }

  String? get sessionToken => _sessionToken;
  bool get isAuthenticated => _sessionToken != null && _sessionToken!.isNotEmpty;
  String get language => _language;
  String get deviceType => _deviceType;

  /// Format JSON data for pretty printing in logs
  String _formatJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        const encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(data);
      }
      return data.toString();
    } catch (e) {
      return data.toString();
    }
  }

  /// Log function entry with parameters
  void _logFunctionStart(String functionName, String endpoint, 
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options}) {
    if (kDebugMode) {
      print('\n🚀 ApiClient.$functionName() called');
      print('📍 Endpoint: $endpoint');
      if (queryParameters != null && queryParameters.isNotEmpty) {
        print('🔍 Query Parameters: $queryParameters');
      }
      if (data != null) {
        print('📤 Request Data: ${_formatJson(data)}');
      }
      if (options != null) {
        print('⚙️  Options: ${options.toString()}');
      }
    }
  }

  /// Detect the current device type
  String _getDeviceType() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isMacOS) {
      return 'macos';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }

  /// Update the language preference for API requests
  Future<void> setLanguage(String language) async {
    _language = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', language);
      if (kDebugMode) {
        print('🌐 Language preference updated to: $language');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to save language preference: $e');
      }
    }
  }

  /// Load saved language preference
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('app_language');
      if (savedLanguage != null) {
        _language = savedLanguage;
      }
    } catch (e) {
      print('Failed to load language preference: $e');
    }
  }

  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logFunctionStart('get', endpoint, queryParameters: queryParameters, options: options);
    
    try {
      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ GET request successful - returning data');
        }
        return response.data as T;
      } else {
        if (kDebugMode) {
          print('⚠️  Unexpected status code in GET: ${response.statusCode}');
        }
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ GET request failed with DioException: ${e.type}');
      }
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ GET request failed with unexpected error: $e');
      }
      rethrow;
    }
  }

  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logFunctionStart('post', endpoint, queryParameters: queryParameters, data: data, options: options);
    
    try {
      final response = await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ POST request successful - returning data');
        }
        return response.data as T;
      } else {
        if (kDebugMode) {
          print('⚠️  Unexpected status code in POST: ${response.statusCode}');
        }
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ POST request failed with DioException: ${e.type}');
      }
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ POST request failed with unexpected error: $e');
      }
      rethrow;
    }
  }

  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logFunctionStart('put', endpoint, queryParameters: queryParameters, data: data, options: options);
    
    try {
      final response = await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ PUT request successful - returning data');
        }
        return response.data as T;
      } else {
        if (kDebugMode) {
          print('⚠️  Unexpected status code in PUT: ${response.statusCode}');
        }
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ PUT request failed with DioException: ${e.type}');
      }
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ PUT request failed with unexpected error: $e');
      }
      rethrow;
    }
  }

  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logFunctionStart('delete', endpoint, queryParameters: queryParameters, data: data, options: options);
    
    try {
      final response = await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (kDebugMode) {
          print('✅ DELETE request successful - returning data');
        }
        return response.data as T;
      } else {
        if (kDebugMode) {
          print('⚠️  Unexpected status code in DELETE: ${response.statusCode}');
        }
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ DELETE request failed with DioException: ${e.type}');
      }
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ DELETE request failed with unexpected error: $e');
      }
      rethrow;
    }
  }

  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logFunctionStart('patch', endpoint, queryParameters: queryParameters, data: data, options: options);
    
    try {
      final response = await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ PATCH request successful - returning data');
        }
        return response.data as T;
      } else {
        if (kDebugMode) {
          print('⚠️  Unexpected status code in PATCH: ${response.statusCode}');
        }
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ PATCH request failed with DioException: ${e.type}');
      }
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ PATCH request failed with unexpected error: $e');
      }
      rethrow;
    }
  }

  Future<Response> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    if (kDebugMode) {
      print('\n🚀 ApiClient.downloadFile() called');
      print('📍 Endpoint: $endpoint');
      print('💾 Save Path: $savePath');
      if (queryParameters != null && queryParameters!.isNotEmpty) {
        print('🔍 Query Parameters: $queryParameters');
      }
    }
    
    try {
      final response = await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress != null 
            ? (received, total) {
                if (kDebugMode && total > 0) {
                  final progress = (received / total * 100).toStringAsFixed(1);
                  print('📈 Download Progress: $progress% ($received/$total bytes)');
                }
                onReceiveProgress(received, total);
              }
            : null,
        cancelToken: cancelToken,
      );
      
      if (kDebugMode) {
        print('✅ Download completed successfully');
        print('📊 Final Status: ${response.statusCode}');
      }
      
      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Download failed with DioException: ${e.type}');
      }
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Download failed with unexpected error: $e');
      }
      rethrow;
    }
  }

  Future<T> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    if (kDebugMode) {
      print('\n🚀 ApiClient.uploadFile() called');
      print('📍 Endpoint: $endpoint');
      print('📁 File Path: $filePath');
      print('🏷️  Field Name: $fieldName');
      if (data != null && data!.isNotEmpty) {
        print('📦 Additional Data: ${_formatJson(data)}');
      }
    }
    
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw ApiException(message: 'File not found: $filePath');
      }
      
      final fileSize = file.lengthSync();
      if (kDebugMode) {
        print('📄 File Size: ${(fileSize / 1024).toStringAsFixed(2)} KB');
      }
      
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      final response = await _dio.post<T>(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress != null 
            ? (sent, total) {
                if (kDebugMode && total > 0) {
                  final progress = (sent / total * 100).toStringAsFixed(1);
                  print('📈 Upload Progress: $progress% ($sent/$total bytes)');
                }
                onSendProgress(sent, total);
              }
            : null,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Upload completed successfully');
        }
        return response.data as T;
      } else {
        if (kDebugMode) {
          print('⚠️  Unexpected status code in upload: ${response.statusCode}');
        }
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Upload failed with DioException: ${e.type}');
      }
      throw ApiExceptionHandler.handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Upload failed with unexpected error: $e');
      }
      rethrow;
    }
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  Future<void> signOut() async {
    if (kDebugMode) {
      print('💪 Signing out - clearing session token');
    }
    await _clearSessionToken();
    if (kDebugMode) {
      print('✅ Sign out completed');
    }
  }
}