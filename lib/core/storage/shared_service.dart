import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  final SharedPreferences _storage;

  SharedService(this._storage);

  Future<void> writeString({required String key, required String value}) async {
    await _storage.setString(key, value);
  }

  Future<void> writeBool({required String key, required bool value}) async {
    await _storage.setBool(key, value);
  }

  String? readString(String key) => _storage.getString(key);

  bool? readBool(String key) => _storage.getBool(key);

  int? readInt(String key) => _storage.getInt(key);

  List<String>? readStringList(String key) => _storage.getStringList(key);

  Future<void> deleteKey(String key) async {
    await _storage.remove(key);
  }

  Future<void> clear() async {
    await _storage.clear();
  }
}
