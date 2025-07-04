import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeBloc extends Cubit<ThemeState> {
  ThemeBloc() : super(const ThemeState(isDarkMode: false));

  void toggleTheme() {
    emit(ThemeState(isDarkMode: !state.isDarkMode));
  }

  void setTheme(bool isDarkMode) {
    emit(ThemeState(isDarkMode: isDarkMode));
  }
}
