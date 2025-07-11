import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_urls.dart';
import '../../models/letter_template_model.dart';
import '../../models/letter_request_model.dart';

class LetterProvider {
  /// Get all available letter templates with optional filters
  Future<List<LetterTemplateModel>> getTemplates({
    String? category,
    String? search,
  }) async {
    try {
      final uri = Uri.parse(AppUrls.letterTemplates);
      final queryParams = <String, String>{};

      if (category != null) {
        queryParams['category'] = category;
      }
      if (search != null) {
        queryParams['search'] = search;
      }

      final finalUri = uri.replace(queryParameters: queryParams);

      final response = await http.get(
        finalUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final List<dynamic> templatesData = responseMap['data'];
        return templatesData
            .map((json) => LetterTemplateModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load templates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching templates: $e');
    }
  }

  /// Get a specific template by ID
  Future<LetterTemplateModel> getTemplate(int templateId) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.letterTemplateById(templateId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final Map<String, dynamic> templateData = responseMap['data'];
        return LetterTemplateModel.fromJson(templateData);
      } else {
        throw Exception('Failed to load template: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching template: $e');
    }
  }

  /// Get available letter categories
  Future<Map<String, String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.letterCategories),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final Map<String, dynamic> categoriesData = responseMap['data'];
        return Map<String, String>.from(categoriesData);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Generate a letter based on template and client details
  Future<LetterRequestModel> generateLetter({
    required int templateId,
    required String clientName,
    String? clientEmail,
    String? clientPhone,
    required Map<String, dynamic> clientMatters,
    bool generateAsync = true,
    required String deviceId,
  }) async {
    try {
      final body = {
        'template_id': templateId,
        'client_name': clientName,
        'client_email': clientEmail,
        'client_phone': clientPhone,
        'client_matters': clientMatters,
        'generate_async': generateAsync,
        'device_id': deviceId,
      };

      final response = await http.post(
        Uri.parse(AppUrls.generateLetter),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final Map<String, dynamic> letterRequestData = responseMap['data'];
        return LetterRequestModel.fromJson(letterRequestData);
      } else if (response.statusCode == 422) {
        // Validation errors
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final errors = responseMap['errors'] ?? responseMap['message'];
        throw Exception('Validation failed: $errors');
      } else {
        throw Exception('Failed to generate letter: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating letter: $e');
    }
  }

  /// Check the status of a letter request
  Future<LetterRequestModel> checkLetterStatus(String requestId) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.letterRequestStatus(requestId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final Map<String, dynamic> letterRequestData = responseMap['data'];
        return LetterRequestModel.fromJson(letterRequestData);
      } else {
        throw Exception('Failed to check status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error checking letter status: $e');
    }
  }

  /// Get the device's letter generation history
  Future<List<LetterRequestModel>> getLetterHistory({
    int page = 1,
    int perPage = 15,
    required String deviceId,
  }) async {
    try {
      final uri = Uri.parse(AppUrls.letterHistoryByDevice);
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
        'device_id': deviceId,
      };

      final finalUri = uri.replace(queryParameters: queryParams);

      final response = await http.get(
        finalUri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final Map<String, dynamic> data = responseMap['data'];
        final List<dynamic> historyData =
            data['data']; // Paginated data is nested
        return historyData
            .map((json) => LetterRequestModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching letter history: $e');
    }
  }

  /// Get download URL for a completed letter
  String getDownloadUrl(String requestId) {
    return AppUrls.downloadLetter(requestId);
  }
}
