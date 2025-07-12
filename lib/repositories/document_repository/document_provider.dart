import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../constants/app_urls.dart';
import '../../models/document_model.dart';

class DocumentProvider {
  Future<List<DocumentModel>> getDocuments({
    String? category,
    String? fileType,
    String? extension,
    String? search,
    bool? featured,
    String sortBy = 'name',
    String sortDirection = 'asc',
    int perPage = 15,
    int page = 1,
  }) async {
    try {
      final queryParams = <String, String>{
        'per_page': perPage.toString(),
        'page': page.toString(),
        'sort_by': sortBy,
        'sort_direction': sortDirection,
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      if (fileType != null && fileType.isNotEmpty) {
        queryParams['file_type'] = fileType;
      }

      if (extension != null && extension.isNotEmpty) {
        queryParams['extension'] = extension;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (featured != null) {
        queryParams['featured'] = featured.toString();
      }

      final uri = Uri.parse(
        AppUrls.documents,
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> items = jsonData['data'];
          return items.map((json) => DocumentModel.fromJson(json)).toList();
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load documents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching documents: $e');
    }
  }

  Future<DocumentModel> getDocumentBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.documentBySlug(slug)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return DocumentModel.fromJson(jsonData['data']);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load document: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching document: $e');
    }
  }

  Future<List<DocumentModel>> getFeaturedDocuments() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.featuredDocuments),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> items = jsonData['data'];
          return items.map((json) => DocumentModel.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception(
          'Failed to load featured documents: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching featured documents: $e');
    }
  }

  Future<List<DocumentModel>> getPopularDocuments() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.popularDocuments),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> items = jsonData['data'];
          return items.map((json) => DocumentModel.fromJson(json)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception(
          'Failed to load popular documents: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching popular documents: $e');
    }
  }

  Future<List<String>> getDocumentCategories() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.documentCategories),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> items = jsonData['data'];
          return items.map((item) => item.toString()).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception(
          'Failed to load document categories: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching document categories: $e');
    }
  }

  Future<String> downloadDocument(String slug) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.downloadDocument(slug)),
        headers: {'Accept': 'application/octet-stream'},
      );

      if (response.statusCode == 200) {
        // Get the downloads directory
        final directory = await getApplicationDocumentsDirectory();
        final downloadsPath = '${directory.path}/downloads';

        // Create downloads directory if it doesn't exist
        await Directory(downloadsPath).create(recursive: true);

        // Extract filename from response headers or use slug
        String filename = slug;
        if (response.headers.containsKey('content-disposition')) {
          final contentDisposition = response.headers['content-disposition'];
          if (contentDisposition != null) {
            final match = RegExp(
              r'filename="([^"]+)"',
            ).firstMatch(contentDisposition);
            if (match != null) {
              filename = match.group(1) ?? slug;
            }
          }
        }

        final filePath = '$downloadsPath/$filename';
        final file = File(filePath);

        // Write file
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      } else {
        throw Exception('Failed to download document: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading document: $e');
    }
  }
}
