import 'package:flutter_temp_bloc/core/storage/secure_storage_services.dart';
import 'package:flutter_temp_bloc/core/storage/shared_service.dart';
import 'package:flutter_temp_bloc/core/theme/cubit/theme_cubit.dart';
import 'package:flutter_temp_bloc/core/theme/theme_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    await _registerStorage();
    _registerThemeModule();
    _registerServices();
    _registerCubits();
  }

  ///////////////// Storage //////////////////////////////////////
  static Future<void> _registerStorage() async {
    //// SharedPreferences //////
    final prefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => prefs);
    getIt.registerLazySingleton<SharedService>(
      () => SharedService(getIt<SharedPreferences>()),
    );

    //// Secure Storage /////
    getIt.registerLazySingleton<SecureStorageServices>(
      () => SecureStorageServices(),
    );
  }

  ///////////////// Theme //////////////////////////////////////
  static void _registerThemeModule() {
    getIt.registerLazySingleton<ThemeService>(
      () => ThemeService(getIt<SharedService>()),
    );

    getIt.registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(getIt<ThemeService>()),
    );
  }

  ///////////////// Services //////////////////////////////////////
  static void _registerServices() {
    // Register other Services here
  }

  ///////////////// Cubits //////////////////////////////////////
  static void _registerCubits() {
    // Register other cubits here
  }
}
