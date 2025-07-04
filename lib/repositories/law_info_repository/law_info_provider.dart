import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_urls.dart';
import '../../models/law_info_item_model.dart';

class LawInfoItemProvider {
  Future<List<LawInfoItemModel>> getLawInfoItems({
    int? categoryId,
    String? categorySlug,
    String? search,
    int perPage = 15,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, String>{
        'per_page': perPage.toString(),
        'page': page.toString(),
      };

      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }

      if (categorySlug != null) {
        queryParams['category_slug'] = categorySlug;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse(AppUrls.lawInfoItems).replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Check if the response has the expected structure
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          
          // Handle pagination response
          if (data is Map && data.containsKey('data')) {
            final List<dynamic> items = data['data'];
            return items.map((json) => LawInfoItemModel.fromJson(json)).toList();
          } else if (data is List) {
            // Handle direct array response
            return data.map((json) => LawInfoItemModel.fromJson(json)).toList();
          }
        }
        
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load law info items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching law info items: $e');
    }
  }

  Future<LawInfoItemModel> getLawInfoItemById(int id) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.lawInfoItemById(id)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          return LawInfoItemModel.fromJson(jsonData['data']);
        }
        
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load law info item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching law info item: $e');
    }
  }

  Future<LawInfoItemModel> getLawInfoItemBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrls.lawInfoItems}/$slug'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          return LawInfoItemModel.fromJson(jsonData['data']);
        }
        
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load law info item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching law info item: $e');
    }
  }

  Future<List<LawInfoItemModel>> getRelatedLawInfoItems(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrls.lawInfoItems}/$slug/related'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> items = jsonData['data'];
          return items.map((json) => LawInfoItemModel.fromJson(json)).toList();
        }
        
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load related law info items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching related law info items: $e');
    }
  }
}