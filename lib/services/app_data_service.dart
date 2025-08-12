import 'dart:convert';
import 'package:flutter/services.dart';
import '../api/scroll_api.dart';
import '../data/mock_data.dart';

/// Centralized data service that manages app-wide data loading and caching.
/// 
/// Data hierarchy:
/// 1. API data (if available and valid)
/// 2. Local cache (in-memory storage)
/// 3. Fallback to datapool.json
/// 4. Final fallback to MockData
///
/// This service should be initialized on app launch if hasValidSession is true.
class AppDataService {
  static final AppDataService _instance = AppDataService._internal();
  factory AppDataService() => _instance;
  AppDataService._internal();

  final ScrollApi _api = ScrollApi();
  
  // In-memory cache for data
  List<CategoryData>? _cachedCategories;
  Map<String, dynamic>? _datapoolData;
  
  // Loading states
  bool _isLoadingCategories = false;
  
  /// Initialize the service on app launch when user has valid session
  Future<void> initialize({required bool hasValidSession}) async {
    if (hasValidSession) {
      // Pre-load essential data from API
      await _loadInitialData();
    } else {
      // Load from datapool.json for offline/unauthenticated users
      await _loadDatapoolData();
    }
  }

  /// Load essential data from API on app launch
  Future<void> _loadInitialData() async {
    try {
      // Load categories from API in the background
      // Don't await to avoid blocking app launch
      _loadCategoriesFromApi();
    } catch (e) {
      print('Failed to load initial data from API: $e');
      // Fallback will be handled in individual getter methods
    }
  }

  /// Load datapool.json for offline usage
  Future<void> _loadDatapoolData() async {
    try {
      final String jsonString = await rootBundle.loadString('lib/data/datapool.json');
      _datapoolData = json.decode(jsonString);
    } catch (e) {
      print('Failed to load datapool.json: $e');
      _datapoolData = null;
    }
  }

  /// Get categories following the data hierarchy
  Future<List<CategoryData>> getCategories() async {
    // 1. Return cached data if available
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }

    // 2. Try to load from API if not already loading
    if (!_isLoadingCategories) {
      final apiCategories = await _loadCategoriesFromApi();
      if (apiCategories.isNotEmpty) {
        return apiCategories;
      }
    }

    // 3. Fallback to datapool.json
    final datapoolCategories = await _getCategoriesFromDatapool();
    if (datapoolCategories.isNotEmpty) {
      return datapoolCategories;
    }

    // 4. Final fallback to MockData
    return MockData.getIslamicCategories();
  }

  /// Load categories from API and cache them
  Future<List<CategoryData>> _loadCategoriesFromApi() async {
    if (_isLoadingCategories) return [];
    
    _isLoadingCategories = true;
    
    try {
      final response = await _api.getCategories();
      final categoriesData = response['categories'] as List<dynamic>? ?? 
                            response['data'] as List<dynamic>? ?? 
                            [];
      
      final categories = categoriesData.map((categoryJson) => CategoryData(
        id: categoryJson['id']?.toString() ?? '',
        name: categoryJson['name']?.toString() ?? '',
        iconPath: categoryJson['iconPath']?.toString(),
        imageUrl: categoryJson['imageUrl']?.toString(),
        itemCount: (categoryJson['itemCount'] as num?)?.toInt() ?? 0,
        listeningHours: categoryJson['listeningHours']?.toString() ?? '0h',
        description: categoryJson['description']?.toString() ?? '',
      )).where((category) => category.id.isNotEmpty).toList();

      // Cache the data
      _cachedCategories = categories;
      print('✅ Loaded ${categories.length} categories from API');
      
      return categories;
    } catch (e) {
      print('❌ Failed to load categories from API: $e');
      return [];
    } finally {
      _isLoadingCategories = false;
    }
  }

  /// Get categories from datapool.json
  Future<List<CategoryData>> _getCategoriesFromDatapool() async {
    try {
      // Load datapool if not already loaded
      if (_datapoolData == null) {
        await _loadDatapoolData();
      }

      if (_datapoolData == null) return [];

      final categoriesJson = _datapoolData!['categories'] as List<dynamic>? ?? [];
      
      final categories = categoriesJson.map((categoryJson) => CategoryData(
        id: categoryJson['id']?.toString() ?? '',
        name: categoryJson['name']?.toString() ?? '',
        iconPath: categoryJson['iconPath']?.toString(),
        imageUrl: categoryJson['imageUrl']?.toString(),
        itemCount: (categoryJson['itemCount'] as num?)?.toInt() ?? 0,
        listeningHours: categoryJson['listeningHours']?.toString() ?? '0h',
        description: categoryJson['description']?.toString() ?? '',
      )).where((category) => category.id.isNotEmpty).toList();

      print('✅ Loaded ${categories.length} categories from datapool.json');
      return categories;
    } catch (e) {
      print('❌ Failed to parse categories from datapool.json: $e');
      return [];
    }
  }

  /// Force refresh categories from API
  Future<List<CategoryData>> refreshCategories() async {
    _cachedCategories = null; // Clear cache
    return await _loadCategoriesFromApi();
  }

  /// Clear all cached data
  void clearCache() {
    _cachedCategories = null;
    _datapoolData = null;
  }

  /// Check if categories are loaded from API (vs fallback)
  bool get isCategoriesFromApi => _cachedCategories != null;

  /// Get data source information for debugging
  String getCategoriesDataSource() {
    if (_cachedCategories != null) return 'API (cached)';
    if (_datapoolData != null) return 'datapool.json';
    return 'MockData (fallback)';
  }
}