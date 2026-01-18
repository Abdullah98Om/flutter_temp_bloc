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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final themeCubit = context.read<ThemeCubit>();
                themeCubit.toggleTheme();
              },
              child: Text(
                'Theme',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
