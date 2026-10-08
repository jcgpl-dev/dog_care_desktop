import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final nextMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeState(themeMode: nextMode));
  }

  void setThemeMode(ThemeMode mode) {
    emit(ThemeState(themeMode: mode));
  }
}
