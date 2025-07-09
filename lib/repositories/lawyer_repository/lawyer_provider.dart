import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_urls.dart';
import '../../models/lawyer_model.dart';

class LawyerProvider {
  /// Get all lawyers with optional filters
  Future<List<LawyerModel>> getLawyers({
    String? specialization,
    String? city,
    String? province,
    bool? acceptingClients,
    String? language,
    String? search,
    String? sortBy,
    String? sortDirection,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final uri = Uri.parse(AppUrls.lawyers);
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (specialization != null)
        queryParams['specialization'] = specialization;
      if (city != null) queryParams['city'] = city;
      if (province != null) queryParams['province'] = province;
      if (acceptingClients != null)
        queryParams['accepting_clients'] = acceptingClients.toString();
      if (language != null) queryParams['language'] = language;
      if (search != null) queryParams['search'] = search;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortDirection != null) queryParams['sort_direction'] = sortDirection;

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
        final List<dynamic> lawyersData =
            data['data']; // Paginated data is nested
        return lawyersData.map((json) => LawyerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load lawyers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching lawyers: $e');
    }
  }

  /// Get a single lawyer by slug
  Future<LawyerModel> getLawyerBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.lawyerBySlug(slug)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final Map<String, dynamic> lawyerData = responseMap['data'];
        return LawyerModel.fromJson(lawyerData);
      } else {
        throw Exception('Failed to load lawyer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching lawyer: $e');
    }
  }

  /// Get featured lawyers
  Future<List<LawyerModel>> getFeaturedLawyers() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.featuredLawyers),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final List<dynamic> lawyersData = responseMap['data'];
        return lawyersData.map((json) => LawyerModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load featured lawyers: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching featured lawyers: $e');
    }
  }

  /// Get lawyers by specialization
  Future<List<LawyerModel>> getLawyersBySpecialization(
    String specialization,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.lawyersBySpecialization(specialization)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final List<dynamic> lawyersData = responseMap['data'];
        return lawyersData.map((json) => LawyerModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load lawyers by specialization: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching lawyers by specialization: $e');
    }
  }

  /// Get available specializations
  Future<List<String>> getSpecializations() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.lawyerSpecializations),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final List<dynamic> specializationsData = responseMap['data'];
        return specializationsData.map((item) => item.toString()).toList();
      } else {
        throw Exception(
          'Failed to load specializations: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching specializations: $e');
    }
  }

  /// Get available locations (cities and provinces)
  Future<Map<String, List<String>>> getLocations() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.lawyerLocations),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final Map<String, dynamic> locationsData = responseMap['data'];

        return {
          'cities': List<String>.from(locationsData['cities'] ?? []),
          'provinces': List<String>.from(locationsData['provinces'] ?? []),
        };
      } else {
        throw Exception('Failed to load locations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching locations: $e');
    }
  }

  /// Search for lawyers near a location
  Future<List<LawyerModel>> getNearbyLawyers({
    required double latitude,
    required double longitude,
    double radius = 50, // Default 50km radius
    String? specialization,
    int limit = 20,
  }) async {
    try {
      final body = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'limit': limit,
      };

      if (specialization != null) {
        body['specialization'] = specialization;
      }

      final response = await http.post(
        Uri.parse(AppUrls.nearbyLawyers),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        final List<dynamic> lawyersData = responseMap['data'];
        return lawyersData.map((json) => LawyerModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load nearby lawyers: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching nearby lawyers: $e');
    }
  }
}
