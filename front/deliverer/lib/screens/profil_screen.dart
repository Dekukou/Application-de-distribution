import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:deliverer/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

final emailController = TextEditingController();
final password = TextEditingController();
final x = TextEditingController();
final y = TextEditingController();

// Function logout
void logout(context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('token', null);
  Navigator.of(context).pushNamed('/login');
}

// Fonction register
void updateUser(context, email, x, y, password) async {
  print(password.text);
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (password.text == "") {
    http.Response response = await http.put(
      Uri.encodeFull("http://92.222.76.5:8000/api/user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": 'Bearer ' + token
      },
      body: jsonEncode({'email': email.text, 'x': x.text, 'y': y.text}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      _showAlert(context, res['message']);
    } else {
      var res = json.decode(response.body);
      _showAlert(context, res['message']);
    }
  } else {
    http.Response response = await http.put(
      Uri.encodeFull("http://92.222.76.5:8000/api/user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": 'Bearer ' + token
      },
      body: jsonEncode({
        'email': email.text,
        'x': x.text,
        'y': y.text,
        'password': password.text
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      _showAlert(context, res['message']);
    } else {
      var res = json.decode(response.body);
      _showAlert(context, res['message']);
    }
  }
}

void _showAlert(BuildContext context, text) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(text),
          ));
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

// Widget Email TextInput
Widget _buildEmailZone(email) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Email',
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 60.0,
        child: TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email, color: Colors.white),
              hintText: 'Entrez votre email',
              hintStyle: kHintTextStyle),
        ),
      ),
    ],
  );
}

Widget _buildXZone(x) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'X',
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        height: 60.0,
        width: 120.0,
        child: TextField(
          controller: x,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.location_on, color: Colors.white),
              hintText: 'X',
              hintStyle: kHintTextStyle),
        ),
      ),
    ],
  );
}

Widget _buildYZone(y) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Y',
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerRight,
        decoration: kBoxDecorationStyle,
        width: 120.0,
        height: 60.0,
        child: TextField(
          controller: y,
          keyboardType: TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.location_on, color: Colors.white),
              hintText: 'Entrez la coordonnée Y',
              hintStyle: kHintTextStyle),
        ),
      ),
    ],
  );
}

// Widget Password TextInput
Widget _buildPasswordZone() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Mot de passe',
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerRight,
        decoration: kBoxDecorationStyle,
        height: 60.0,
        child: TextField(
          controller: password,
          obscureText: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              hintText: 'Entrez votre mot de passe',
              hintStyle: kHintTextStyle),
        ),
      ),
    ],
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

Widget _buildUpdateButton(context, email, x, y, password) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => updateUser(context, email, x, y, password),
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Color(0xFF00838F),
          child: Text(
            'METTRE À JOUR',
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
  final emailController = new TextEditingController();
  final xController = new TextEditingController();
  final yController = new TextEditingController();
  int _selectedIndex = 1;
  var user;

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
    _getUser();
    print(emailController);
    return super.initState();
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
      user = res['datas'];
      emailController.text = user['email'];
      xController.text = user['home'][0].toString();
      yController.text = user['home'][1].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              _buildBackground(),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLogo(context),
                      _buildEmailZone(emailController),
                      SizedBox(height: 10),
                      _buildPasswordZone(),
                      SizedBox(height: 10),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildXZone(xController),
                              _buildYZone(yController),
                            ]),
                      ),
                      SizedBox(height: 10),
                      _buildUpdateButton(context, emailController, xController,
                          yController, password),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF545454),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Accueil'),
          ),
          BottomNavigationBarItem(
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
