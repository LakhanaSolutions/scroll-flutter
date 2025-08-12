// Service to load data from datapool.json
import 'dart:convert';
import 'package:flutter/services.dart';
import 'mock_data.dart';

class DataPoolService {
  static Map<String, dynamic>? _cachedData;

  /// Load and parse datapool.json
  static Future<Map<String, dynamic>> _loadDataPool() async {
    if (_cachedData != null) return _cachedData!;
    
    try {
      final String jsonString = await rootBundle.loadString('lib/data/datapool.json');
      _cachedData = json.decode(jsonString);
      return _cachedData!;
    } catch (e) {
      // Fallback to mock data if datapool.json fails to load
      print('Failed to load datapool.json: $e');
      return {};
    }
  }

  /// Get categories from datapool.json
  static Future<List<CategoryData>> getCategories() async {
    try {
      final data = await _loadDataPool();
      final categoriesJson = data['categories'] as List<dynamic>? ?? [];
      
      return categoriesJson.map((categoryJson) => CategoryData(
        id: categoryJson['id'] as String,
        name: categoryJson['name'] as String,
        iconPath: categoryJson['iconPath'] as String?,
        imageUrl: categoryJson['imageUrl'] as String?,
        itemCount: categoryJson['itemCount'] as int,
        listeningHours: categoryJson['listeningHours'] as String,
        description: categoryJson['description'] as String,
      )).toList();
    } catch (e) {
      // Fallback to mock data if parsing fails
      print('Failed to parse categories from datapool.json: $e');
      return MockData.getIslamicCategories();
    }
  }
}