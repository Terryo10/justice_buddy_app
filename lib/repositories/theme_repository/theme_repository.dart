import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeRepository {
  final FlutterSecureStorage _storage;
  static const String _themeKey = 'theme_mode';

  ThemeRepository({required FlutterSecureStorage storage}) : _storage = storage;

  Future<bool> getThemeMode() async {
    try {
      final themeValue = await _storage.read(key: _themeKey);
      return themeValue == 'dark';
    } catch (e) {
      // Default to light mode if there's an error
      return false;
    }
  }

  Future<void> setThemeMode(bool isDarkMode) async {
    try {
      await _storage.write(
        key: _themeKey,
        value: isDarkMode ? 'dark' : 'light',
      );
    } catch (e) {
      // Handle error silently or log it
      print('Error saving theme mode: $e');
    }
  }
}
