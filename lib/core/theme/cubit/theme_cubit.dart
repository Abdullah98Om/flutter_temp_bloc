import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeService _service;

  ThemeCubit(this._service)
    : super(ThemeState(_service.isDark() ? ThemeMode.dark : ThemeMode.light));

  void toggle() {
    final isDark = state.mode == ThemeMode.light;
    _service.saveTheme(isDark);
    emit(ThemeState(isDark ? ThemeMode.dark : ThemeMode.light));
  }

  void setLight() {
    _service.saveTheme(false);
    emit(const ThemeState(ThemeMode.light));
  }

  void setDark() {
    _service.saveTheme(true);
    emit(const ThemeState(ThemeMode.dark));
  }
}
