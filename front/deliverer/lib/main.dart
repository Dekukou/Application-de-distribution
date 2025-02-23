import 'package:flutter/material.dart';
import 'package:deliverer/screens/login_screen.dart';
import 'package:deliverer/screens/register_screen.dart';
import 'package:deliverer/screens/home_screen.dart';
import 'package:deliverer/screens/profil_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/register': (BuildContext context) => RegisterScreen(),
        '/home': (BuildContext context) => HomeScreen(),
        '/profil': (BuildContext context) => ProfilScreen(),
      },
    );
  }
}
