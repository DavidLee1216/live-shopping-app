import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveapp/screens/change_pass.dart';
import 'package:liveapp/screens/pass_changed.dart';
import 'package:liveapp/screens/signin.dart';
import 'package:liveapp/screens/forgot.dart';
import 'package:liveapp/screens/home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/signin':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/forgot':
        return MaterialPageRoute(builder: (_) => ForgotScreen());
      case '/changepass':
        return MaterialPageRoute(builder: (_) => ChangePassScreen());
      case '/passchanged':
        return MaterialPageRoute(builder: (_) => PassChangedScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
