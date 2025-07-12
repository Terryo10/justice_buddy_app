class AppUrls {
  // Base URL - Use your computer's IP address for mobile development
  // Replace '192.168.1.100' with your actual computer's IP address
  // You can find your IP by running 'ipconfig' on Windows or 'ifconfig' on Mac/Linux
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiPath = '/api';

  // Image URL function
  static String imageUrl(String image) => '$baseUrl/storage/$image';

  // Categories endpoints
  static const String categories = '$baseUrl$apiPath/categories';
  static String categoryById(int id) => '$categories/$id';

  // Law Info Items endpoints
  static const String lawInfoItems = '$baseUrl$apiPath/law-info-items';
  static String lawInfoItemById(int id) => '$lawInfoItems/$id';

  // Users endpoints
  static const String users = '$baseUrl$apiPath/users';
  static String userById(int id) => '$users/$id';

  // Lawyers endpoints
  static const String lawyers = '$baseUrl$apiPath/lawyers';
  static String lawyerBySlug(String slug) => '$lawyers/$slug';
  static const String featuredLawyers = '$lawyers/featured';
  static const String lawyerSpecializations = '$lawyers/specializations';
  static const String lawyerLocations = '$lawyers/locations';
  static String lawyersBySpecialization(String specialization) =>
      '$lawyers/specialization/$specialization';
  static const String nearbyLawyers = '$lawyers/near';

  // Letter Generation endpoints
  static const String letterTemplates =
      '$baseUrl$apiPath/letter-generation/templates';
  static String letterTemplateById(int id) => '$letterTemplates/$id';
  static const String generateLetter =
      '$baseUrl$apiPath/letter-generation/generate';
  static const String letterCategories =
      '$baseUrl$apiPath/letter-generation/categories';
  static const String letterRequests = '$baseUrl$apiPath/letter-requests';
  static String letterRequestStatus(String requestId) =>
      '$letterRequests/status/$requestId';
  static String downloadLetter(String requestId) =>
      '$letterRequests/download/$requestId';
  static String updateLetter(String requestId) =>
      '$letterRequests/update/$requestId';
  static const String letterHistory = '$letterRequests/history';
  static const String letterHistoryByDevice = '$letterRequests/history/device';

  // Chat endpoints
  static const String chatRules = '$baseUrl$apiPath/chat/rules';
  static const String chatMessage = '$baseUrl$apiPath/chat/message';

  // Auth endpoints
  static const String login = '$baseUrl$apiPath/auth/login';
  static const String register = '$baseUrl$apiPath/auth/register';
  static const String logout = '$baseUrl$apiPath/auth/logout';
  static const String refresh = '$baseUrl$apiPath/auth/refresh';
}
