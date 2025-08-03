import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    auth: (context) => const AuthScreen(),
    home: (context) => const HomeScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen());
      case auth:
        return _buildRoute(const AuthScreen());
      case home:
        return _buildRoute(const HomeScreen());
      default:
        return _buildRoute(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
