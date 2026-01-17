import 'package:flutter/material.dart';

// import 'routers_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      // RoutesName.splash: (_) => const SplashScreen(),
      // RoutesName.onboarding: (_) => const OnboardingScreen(),
      // RoutesName.login: (_) => const LoginScreen(),
      // RoutesName.index: (_) => const Index(),
      // RoutesName.storyView: (_) => const StoryViewScreen(),
      // RoutesName.article: (_) => const ArticleScreen(),
      // RoutesName.profile: (_) => const ProfileScreen(),
    };

    final pageBuilder = routes[settings.name];
    if (pageBuilder == null) {
      return _errorRoute();
    }

    return MaterialPageRoute(builder: pageBuilder, settings: settings);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'Not Found Screen ..',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
