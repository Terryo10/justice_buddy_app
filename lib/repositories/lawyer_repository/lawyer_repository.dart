import 'package:justice_buddy/repositories/lawyer_repository/lawyer_provider.dart';
import '../../models/lawyer_model.dart';

class LawyerRepository {
  final LawyerProvider provider;

  LawyerRepository({required this.provider});

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
  }) => provider.getLawyers(
    specialization: specialization,
    city: city,
    province: province,
    acceptingClients: acceptingClients,
    language: language,
    search: search,
    sortBy: sortBy,
    sortDirection: sortDirection,
    page: page,
    perPage: perPage,
  );

  /// Get a single lawyer by slug
  Future<LawyerModel> getLawyerBySlug(String slug) =>
      provider.getLawyerBySlug(slug);

  /// Get featured lawyers
  Future<List<LawyerModel>> getFeaturedLawyers() =>
      provider.getFeaturedLawyers();

  /// Get lawyers by specialization
  Future<List<LawyerModel>> getLawyersBySpecialization(String specialization) =>
      provider.getLawyersBySpecialization(specialization);

  /// Get available specializations
  Future<List<String>> getSpecializations() => provider.getSpecializations();

  /// Get available locations (cities and provinces)
  Future<Map<String, List<String>>> getLocations() => provider.getLocations();

  /// Search for lawyers near a location
  Future<List<LawyerModel>> getNearbyLawyers({
    required double latitude,
    required double longitude,
    double radius = 50,
    String? specialization,
    int limit = 20,
  }) => provider.getNearbyLawyers(
    latitude: latitude,
    longitude: longitude,
    radius: radius,
    specialization: specialization,
    limit: limit,
  );
}
