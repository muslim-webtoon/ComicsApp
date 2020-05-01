import 'package:flutter/material.dart';
import 'package:pkcomics/app/root_scene.dart';
import 'package:pkcomics/app/splash_scene.dart';
import 'package:pkcomics/comic/reader/reader_comment.dart';
import 'package:pkcomics/comic/reader/reader_scene.dart';
import 'package:pkcomics/me/login_scene.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final int args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => RootScene());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScene());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScene());
      case '/reader':
        // Validation of correct data type
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => ReaderScene(
                  episodeId: args,
                ),
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
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