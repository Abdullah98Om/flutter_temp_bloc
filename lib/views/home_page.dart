import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/localization/language_keys.dart' show LanguageKeys;
import '../core/theme/theme_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text('Flutter Template Bloc'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              "appTitle".tr(),
              style: Theme.of(context).textTheme.headlineMedium,
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
                themeCubit.toggleTheme();
              },
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return Icon(
                    state.themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    size: 40,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
