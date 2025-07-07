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

  // Auth endpoints
  static const String login = '$baseUrl$apiPath/auth/login';
  static const String register = '$baseUrl$apiPath/auth/register';
  static const String logout = '$baseUrl$apiPath/auth/logout';
  static const String refresh = '$baseUrl$apiPath/auth/refresh';
}
