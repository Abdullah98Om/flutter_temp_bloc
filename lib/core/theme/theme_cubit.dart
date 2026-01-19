import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_temp_bloc/core/storage/shared_service.dart';

class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

/// الـ Cubit المسؤول عن إدارة الثيم
class ThemeCubit extends Cubit<ThemeState> {
  final SharedService _sharedService;
  ThemeCubit(this._sharedService)
    : super(
        ThemeState(
          _sharedService.readBool(_themeKey) == true
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );
  static const _themeKey = 'app_theme';

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    final isDark = newMode == ThemeMode.dark;
    _sharedService.writeBool(key: _themeKey, value: isDark);

    emit(ThemeState(newMode));
  }

  void setLight() {
    _sharedService.writeBool(key: _themeKey, value: false);
    emit(const ThemeState(ThemeMode.light));
  }

  void setDark() {
    _sharedService.writeBool(key: _themeKey, value: true);
    emit(const ThemeState(ThemeMode.dark));
  }
}
