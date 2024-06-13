import 'package:flutter/material.dart';
import 'package:share_life_mobile_json/utils/route.dart';
import 'package:share_life_mobile_json/utils/session_management.dart'; 
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SessionManager(),
      child: MaterialApp(
        title: 'Share Life',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // Désactiver le logo de débogage
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.generateRoute,
        initialRoute: Routes.login,
      ),
    );
  }
}
