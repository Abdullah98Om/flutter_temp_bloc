import 'package:flutter_temp_bloc/core/storage/secure_storage_services.dart';
import 'package:flutter_temp_bloc/core/storage/shared_service.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    //////////// SharedPreferences ////////////////////////////////
    final prefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => prefs);
    getIt.registerLazySingleton<SharedService>(
      () => SharedService(getIt<SharedPreferences>()),
    );

    /////////////////// Secure Storage ////////////////////////////////////////////////////
    ///
    final secureStorage = SecureStorageServices();
    getIt.registerLazySingleton<SecureStorageServices>(() => secureStorage);

    ///////////////// Cubits //////////////////////////////////////
  }
}
