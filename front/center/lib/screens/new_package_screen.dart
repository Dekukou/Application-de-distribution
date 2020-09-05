import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:center/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPackageScreen extends StatefulWidget {
  @override
  _NewPackageScreenState createState() => _NewPackageScreenState();
}

final x = TextEditingController();
final y = TextEditingController();

// Fonction createPackage
void createPackage(context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  http.Response response = await http.post(
    Uri.encodeFull("http://92.222.76.5:8000/api/createPackage"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": 'Bearer ' + token
    },
    body: jsonEncode(<String, String>{'x': x.text, 'y': y.text}),
  );
  var res = json.decode(response.body);
  if (response.statusCode == 201) {
    _showAlert(context, "Success", res['message']);
  } else {
    _showAlert(context, "Error", res['message']);
  }
}

void _showAlert(BuildContext context, title, text) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
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

Widget _buildXZone() {
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
        width: 120.0,
        height: 60.0,
        child: TextField(
          controller: x,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.person, color: Colors.white),
              hintText: 'Entrez la coordonnée X',
              hintStyle: kHintTextStyle),
        ),
      ),
    ],
  );
}

Widget _buildYZone() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Y',
        style: kLabelStyle,
      ),
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: kBoxDecorationStyle,
        width: 120.0,
        height: 60.0,
        child: TextField(
          controller: y,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.person, color: Colors.white),
              hintText: 'Entrez la coordonnée Y',
              hintStyle: kHintTextStyle),
        ),
      ),
    ],
  );
}

// Widget Bouton de connexion
Widget _buildNewPackageButton(context) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () => createPackage(context),
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Color(0xFF00838F),
          child: Text(
            "CRÉER LE COLIS",
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

class _NewPackageScreenState extends State<NewPackageScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) async {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/home');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/deliverers');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/packages');
    } else if (index == 4) {
      Navigator.of(context).pushNamed('/profil');
    }
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
                      Text('Ajouter un colis',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 30.0),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildXZone(),
                              _buildYZone(),
                            ]),
                      ),
                      SizedBox(height: 20),
                      _buildNewPackageButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF545454),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Accueil'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            title: Text('Livreurs'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_post_office),
            title: Text('Colis'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            title: Text('+Colis'),
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
