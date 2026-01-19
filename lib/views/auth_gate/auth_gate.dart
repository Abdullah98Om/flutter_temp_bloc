// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../viewmodels/user_cubit.dart';
// import '../views/login_view.dart';

// class AuthGate extends StatelessWidget {
//   final Widget child; // الشاشة المراد عرضها للمستخدم المسجل
//   const AuthGate({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UserCubit, UserState>(
//       builder: (context, state) {
//         if (state.user == null) {
//           // المستخدم غير مسجل دخول
//           return const LoginView(); // توجه شاشة تسجيل الدخول
//         } else {
//           // المستخدم مسجل دخول
//           return child; // عرض الشاشة المحمية
//         }
//       },
//     );
//   }
// }
