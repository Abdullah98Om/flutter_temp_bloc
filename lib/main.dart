import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routers/routers.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/cubit/theme_state.dart';
import 'viewmodels/auth_cubit/auth_cubit.dart';
import 'views/error_page.dart' show ErrorPage;
import 'core/di/dependency_injection.dart';
import 'core/localization/language_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await DependencyInjection.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(LanguageKeys.english),
        Locale(LanguageKeys.arabic),
      ],

      saveLocale: true, // هذا يحفظ اللغة تلقائيًا
      path: 'assets/langs',
      fallbackLocale: const Locale(LanguageKeys.english),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
          BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()..getUser()),
        ],

        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: state.mode, // هنا يتم اختيار الثيم

          routerConfig: myRouter,
          builder: (context, widget) {
            // Handle UI errors
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return ErrorPage();
            };
            return widget!;
          },
        );
      },
    );
  }
}
