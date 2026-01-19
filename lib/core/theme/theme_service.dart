import '../storage/shared_service.dart';

class ThemeService {
  static const _key = 'app_theme';

  final SharedService _shared;

  ThemeService(this._shared);

  bool isDark() => _shared.readBool(_key) ?? false;

  Future<void> saveTheme(bool isDark) async {
    await _shared.writeBool(key: _key, value: isDark);
  }
}
