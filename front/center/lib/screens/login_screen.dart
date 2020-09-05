import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:center/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final email = TextEditingController();
final password = TextEditingController();

void login(context) async {
  http.Response response = await http.post(
    Uri.encodeFull("http://92.222.76.5:8000/api/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email.text,
      'password': password.text,
      'role': '1'
    }),
  );

  if (response.statusCode == 201) {
    var res = json.decode(response.body);
    print(res['token']);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', res['token']);
    Navigator.of(context).pushNamed('/home');
  } else {
    _showAlert(context);
  }
}

void _showAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Erreur"),
      content: Text("Identifiants invalides"),
    ),
  );
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
Widget _buildEmailZone() {
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
            hintStyle: kHintTextStyle,
          ),
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
        alignment: Alignment.centerLeft,
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
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
    ],
  );
}

// Widget Bouton de connexion
Widget _buildLoginButton(context) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => login(context),
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Color(0xFF00838F),
          child: Text(
            'SE CONNECTER',
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

// Widget allant à la page d'inscription
Widget _buildGoToRegister(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/register'),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Créer un compte',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.9,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _LoginScreenState extends State<LoginScreen> {
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
                      Text(
                        'Connexion',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailZone(),
                      SizedBox(height: 30.0),
                      _buildPasswordZone(),
                      SizedBox(height: 20),
                      _buildLoginButton(context),
                      SizedBox(height: 10.0),
                      _buildGoToRegister(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
