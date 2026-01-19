import 'package:flutter/material.dart';
import 'package:flutter_temp_bloc/core/di/dependency_injection.dart';
import 'package:flutter_temp_bloc/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:flutter_temp_bloc/views/error_page.dart';
import 'package:flutter_temp_bloc/views/home_page.dart';
import 'package:flutter_temp_bloc/views/login/login_page.dart';
import 'package:flutter_temp_bloc/views/products/products_page.dart';
import 'package:go_router/go_router.dart';

import 'page_transitions.dart';
import 'routers_name.dart';

// import 'routers_name.dart';

// class Routes {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final routes = <String, WidgetBuilder>{
//       // RoutesName.splash: (_) => const SplashScreen(),
//       // RoutesName.onboarding: (_) => const OnboardingScreen(),
//       // RoutesName.login: (_) => const LoginScreen(),
//       // RoutesName.index: (_) => const Index(),
//       // RoutesName.storyView: (_) => const StoryViewScreen(),
//       // RoutesName.article: (_) => const AuthGate(child: ArticleScreen()), // محمية ب AuthGate ==> (لابد ان يكون مسجل دخول)
//       RoutesName.home: (_) => const HomePage(),
//     };

//     final pageBuilder = routes[settings.name];
//     if (pageBuilder == null) {
//       return _errorRoute();
//     }

//     // return MaterialPageRoute(builder: pageBuilder, settings: settings);
//     switch (settings.name) {
//       case RoutesName.home:
//         return PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) =>
//               pageBuilder(context),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             return FadeTransition(opacity: animation, child: child);
//           },
//         );
//       default:
//         return PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) =>
//               pageBuilder(context),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             final offsetAnimation = Tween<Offset>(
//               begin: const Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(animation);
//             return SlideTransition(position: offsetAnimation, child: child);
//           },
//         );
//     }
//   }

//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(
//       builder: (_) => const Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Text(
//             'Not Found Screen ..',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 24,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

final _protectedRoutes = <String>{
  RoutesName.products,
  //  RoutesName.products,
  //  RoutesName.products,
  //   RoutesName.products
  // أضف أي صفحة تريد حمايتها
};

final myRouter = GoRouter(
  errorBuilder: (context, state) => ErrorPage(),

  initialLocation: '/',
  redirect: (context, state) {
    final authState = getIt<AuthCubit>().state;
    final loggedIn = authState is AuthLoggedState;

    final loggingIn = state.uri.path == RoutesName.login;
    final goingToProtected = _protectedRoutes.contains(state.uri.path);

    if (!loggedIn && goingToProtected) {
      return RoutesName.login;
    }
    if (loggedIn && loggingIn) {
      return '/'; // إذا كان مسجل دخول ويريد العودة لتسجيل الدخول
    }
    return null;
  },
  routes: [
    GoRoute(
      name: RoutesName.home,
      path: '/',
      pageBuilder: (context, state) =>
          PageTransitions.slideFromBottom(HomePage()),
    ),
    GoRoute(
      name: RoutesName.login,
      path: RoutesName.login,
      pageBuilder: (context, state) =>
          PageTransitions.slideFromRight(LoginPage()),
    ),
    GoRoute(
      name: RoutesName.products,
      path: RoutesName.products,
      pageBuilder: (context, state) => PageTransitions.fade(ProductsPage()),
      redirect: (context, state) {},
    ),
  ],
);
