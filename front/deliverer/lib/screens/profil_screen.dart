import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

final email = TextEditingController();
final password = TextEditingController();

// Function logout
void logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', null);
    Navigator.of(context).pushNamed('/login');
}

// Set App Background
Widget _buildBackground() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xFF00939F),
            Color(0xFF545454),
            Color(0xFF424242),
            Color(0xFF303030),
        ],
        stops: [0.1, 0.3, 0.6, 0.9],
      ),
    ),
  );
}

// Widget Logo Image
Widget _buildLogo(context) {
  return Image.asset(
    'assets/logos/logo.png',
    height: MediaQuery.of(context).size.height * 0.25,
  );
}

Widget _buildLogoutButton(context) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => logout(context),
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Color(0xFF00838F),
          child: Text(
            'SE DÉCONNECTER',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    ],
  );
}

class _ProfilScreenState extends State<ProfilScreen> {
  int _selectedIndex = 1;
  var _user;

  void _onItemTapped(int index) async {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    http.Response response = await http.get(
      Uri.encodeFull("http://92.222.76.5:8000/api/user"),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": 'Bearer ' + token
    });
    var res = json.decode(response.body);
    print(res);
    setState(() {
      _user = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle> (
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
            _buildBackground(),
            new Flexible(
              child: new Column(
                children: <Widget> [
                  SizedBox(height: 30.0),
                  _buildLogo(context), 
                  _buildLogoutButton(context)
                  ]
                ,)
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar (
        backgroundColor: Color(0xFF545454),
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem (
            icon: Icon(Icons.home),
            title: Text('Accueil'),
          ),
          BottomNavigationBarItem (
            icon: Icon(Icons.perm_identity),
            title: Text('Profil'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan[600],
        onTap: _onItemTapped,
      ),
    );
  }
}