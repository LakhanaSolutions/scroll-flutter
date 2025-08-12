import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;
  String? _sessionToken;

  void initialize({String? baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        ApiConstants.acceptHeader: ApiConstants.applicationJson,
        ApiConstants.userAgentHeader: 'Scroll Flutter App',
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
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_sessionToken != null && _sessionToken!.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] = 
          '${ApiConstants.bearerPrefix}$_sessionToken';
    }

    print('Request: ${options.method} ${options.uri}');
    if (options.data != null) {
      print('Request Data: ${options.data}');
    }

    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Response: ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    print('Error: ${error.type} ${error.requestOptions.uri}');
    
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
    } catch (e) {
      print('Failed to save session token: $e');
    }
  }

  Future<void> _clearSessionToken() async {
    _sessionToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('session_token');
    } catch (e) {
      print('Failed to clear session token: $e');
    }
  }

  String? get sessionToken => _sessionToken;
  bool get isAuthenticated => _sessionToken != null && _sessionToken!.isNotEmpty;

  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    }
  }

  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    }
  }

  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    }
  }

  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    }
  }

  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      if (response.statusCode == 200) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
    }
  }

  Future<Response> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
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
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?data,
      });

      final response = await _dio.post<T>(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as T;
      } else {
        throw ApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleDioException(e);
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
    await _clearSessionToken();
  }
}