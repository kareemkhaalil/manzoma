import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static GoRouter router = GoRouter(
    routes: [
      // GoRoute(
      //   path: AppRouterPath.addStudent,
      //   builder: (context, state) => l(),
      // ),
      // GoRoute(
      //   path: '/',
      //   builder: (context, state) => Students(),
      // ),
    ],
  );
}

abstract class AppRouterPath {
  static const String signIn = '/';
  static const String signInFaluire = '/auth-failure';
  static const String addStudent = '/add-student';
}
