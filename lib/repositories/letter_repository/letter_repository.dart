import '../../models/letter_template_model.dart';
import '../../models/letter_request_model.dart';
import '../../services/device_id_service.dart';
import 'letter_provider.dart';

class LetterRepository {
  final LetterProvider provider;
  final DeviceIdService deviceIdService;

  LetterRepository({
    required this.provider,
    required this.deviceIdService,
  });

  /// Get all available letter templates with optional filters
  Future<List<LetterTemplateModel>> getTemplates({
    String? category,
    String? search,
  }) async {
    try {
      return await provider.getTemplates(category: category, search: search);
    } catch (e) {
      rethrow;
    }
  }

  /// Get a specific template by ID
  Future<LetterTemplateModel> getTemplate(int templateId) async {
    try {
      return await provider.getTemplate(templateId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get available letter categories
  Future<Map<String, String>> getCategories() async {
    try {
      return await provider.getCategories();
    } catch (e) {
      rethrow;
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
  }) async {
    try {
      // Additional validation can be added here before calling the provider
      if (clientName.trim().isEmpty) {
        throw Exception('Client name is required');
      }

      // Get the device ID
      final deviceId = await deviceIdService.getDeviceId();

      return await provider.generateLetter(
        templateId: templateId,
        clientName: clientName,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        clientMatters: clientMatters,
        generateAsync: generateAsync,
        deviceId: deviceId,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Check the status of a letter request
  Future<LetterRequestModel> checkLetterStatus(String requestId) async {
    try {
      if (requestId.trim().isEmpty) {
        throw Exception('Request ID is required');
      }

      return await provider.checkLetterStatus(requestId);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the device's letter generation history
  Future<List<LetterRequestModel>> getLetterHistory({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final deviceId = await deviceIdService.getDeviceId();
      return await provider.getLetterHistory(
        page: page,
        perPage: perPage,
        deviceId: deviceId,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get download URL for a completed letter
  String getDownloadUrl(String requestId) {
    if (requestId.trim().isEmpty) {
      throw Exception('Request ID is required');
    }
    return provider.getDownloadUrl(requestId);
  }

  /// Validate template fields against client matters
  List<String> validateTemplateFields(
    LetterTemplateModel template,
    Map<String, dynamic> clientMatters,
  ) {
    return template.validateClientMatters(clientMatters);
  }

  /// Get templates by category
  Future<List<LetterTemplateModel>> getTemplatesByCategory(
    String category,
  ) async {
    try {
      return await provider.getTemplates(category: category);
    } catch (e) {
      rethrow;
    }
  }

  /// Search templates
  Future<List<LetterTemplateModel>> searchTemplates(String search) async {
    try {
      return await provider.getTemplates(search: search);
    } catch (e) {
      rethrow;
    }
  }

  /// Update letter content
  Future<LetterRequestModel> updateLetter({
    required String requestId,
    required String generatedLetter,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
  }) async {
    try {
      if (requestId.trim().isEmpty) {
        throw Exception('Request ID is required');
      }

      if (generatedLetter.trim().isEmpty) {
        throw Exception('Letter content is required');
      }

      // Get the device ID
      final deviceId = await deviceIdService.getDeviceId();

      return await provider.updateLetter(
        requestId: requestId,
        generatedLetter: generatedLetter,
        clientName: clientName,
        clientEmail: clientEmail,
        clientPhone: clientPhone,
        deviceId: deviceId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
