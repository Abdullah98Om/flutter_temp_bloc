import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// الحالة البسيطة للثيم
class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

/// الـ Cubit المسؤول عن إدارة الثيم
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.light));

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(ThemeState(newMode));
  }

  void setLight() => emit(const ThemeState(ThemeMode.light));
  void setDark() => emit(const ThemeState(ThemeMode.dark));
}
