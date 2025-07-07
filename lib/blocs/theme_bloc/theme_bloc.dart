import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justice_buddy/repositories/theme_repository/theme_repository.dart';

part 'theme_state.dart';

class ThemeBloc extends Cubit<ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeBloc({required ThemeRepository themeRepository})
    : _themeRepository = themeRepository,
      super(const ThemeState(isDarkMode: false)) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final isDarkMode = await _themeRepository.getThemeMode();
      emit(ThemeState(isDarkMode: isDarkMode));
    } catch (e) {
      // Keep default state if there's an error
      print('Error loading theme mode: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newThemeMode = !state.isDarkMode;
    emit(ThemeState(isDarkMode: newThemeMode));
    await _themeRepository.setThemeMode(newThemeMode);
  }

  Future<void> setTheme(bool isDarkMode) async {
    emit(ThemeState(isDarkMode: isDarkMode));
    await _themeRepository.setThemeMode(isDarkMode);
  }
}
