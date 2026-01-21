import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_temp_bloc/core/routers/routers_name.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/language_keys.dart' show LanguageKeys;
import '../core/theme/app_text_style.dart';
import '../core/theme/cubit/theme_cubit.dart';
import '../core/theme/cubit/theme_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // يمنع الرجوع
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: Text('Flutter Template Bloc', style: AppTextStyles.headline1),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Animate(
                effects: [FadeEffect(), ScaleEffect()],
                child: Text(
                  "appTitle".tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // لتغيير اللغة إلى العربية
                      context.setLocale(Locale(LanguageKeys.arabic));
                    },
                    child: Text(
                      'اللغة العربية',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // لتغيير اللغة إلى العربية
                      context.setLocale(Locale(LanguageKeys.english));
                    },
                    child: Text(
                      'English',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final themeCubit = context.read<ThemeCubit>();
                  themeCubit.toggle();
                },
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Icon(
                      state.mode == ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      size: 40,
                    );
                  },
                ),
              ).animate().fade(duration: 500.ms).scale(duration: 500.ms),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(RoutesName.faceDetection);
                },
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Text("Face Detecation");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
