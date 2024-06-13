// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:share_life_mobile_json/screens/create_compte_screen.dart';
import 'package:share_life_mobile_json/screens/home_sreen.dart'; 
import 'package:share_life_mobile_json/screens/login_screen.dart';

class Routes {
  static const String login = '/';
  static const String home = '/home';
  static const String createCompte = '/createCompte';
  static const String updateDescription = '/updateDescription';
  static const String updateprofil = '/updateProfil';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case createCompte:
        return MaterialPageRoute(builder: (_) => CreateScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page introuvable'),
            ),
          ),
        );
    }
  }
}
