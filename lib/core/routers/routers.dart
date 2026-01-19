import 'package:flutter_temp_bloc/core/di/dependency_injection.dart';
import 'package:flutter_temp_bloc/viewmodels/auth_cubit/auth_cubit.dart';
import 'package:flutter_temp_bloc/views/error_page.dart';
import 'package:flutter_temp_bloc/views/home_page.dart';
import 'package:flutter_temp_bloc/views/login/login_page.dart';
import 'package:flutter_temp_bloc/views/products/products_page.dart';
import 'package:go_router/go_router.dart';

import 'page_transitions.dart';
import 'routers_name.dart';

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
    ),
  ],
);
