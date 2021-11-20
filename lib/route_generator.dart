import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case '/':
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null)
          return MaterialPageRoute(builder: (_) => HomeScreen());
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text(
            '404 Error!',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      );
    });
  }
}
