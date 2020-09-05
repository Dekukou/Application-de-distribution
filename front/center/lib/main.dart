import 'package:flutter/material.dart';
import 'package:center/screens/home_screen.dart';
import 'package:center/screens/login_screen.dart';
import 'package:center/screens/profil_screen.dart';
import 'package:center/screens/register_screen.dart';
import 'package:center/screens/packages_screen.dart';
import 'package:center/screens/deliverers_screen.dart';
import 'package:center/screens/new_package_screen.dart';

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
        '/home': (BuildContext context) => HomeScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/profil': (BuildContext context) => ProfilScreen(),
        '/register': (BuildContext context) => RegisterScreen(),
        '/packages': (BuildContext context) => PackagesScreen(),
        '/newPackage': (BuildContext context) => NewPackageScreen(),
        '/deliverers': (BuildContext context) => DeliverersScreen(),
      },
    );
  }
}
