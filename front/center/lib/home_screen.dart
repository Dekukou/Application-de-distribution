import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final email = TextEditingController();
final password = TextEditingController();

// Function logout
void logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', null);
    Navigator.of(context).pushNamed('/login');
}

Widget _buildBlur() {
  return Positioned(
    top:0,
    left: 0,
    height: 200,
    width: 350,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(40.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 1.75,
          sigmaY: 1.75
        ),
        child: Container(
          child: Center(
          child: Text("Je s'appelle Groot", style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,),
          ),
          color: Color(0x00)
        ),
      ),
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

// Widget Logout Button
Widget _buildLogoutButton(context) {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
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

//Image avec un filtre de couleur /!\ le BlendMode ne fonctionne pas encore sur Web
Widget _buildImage(color, image) {
  return Stack(
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child:
        Image.network(
          image,
          color: Color(color).withOpacity(0.55),
          colorBlendMode: BlendMode.modulate,              
          height: 200,
          width: 350,
          fit:BoxFit.fitHeight,
        ),
      ),
      _buildBlur(),
    ],
  );
}

class _HomeScreenState extends State<HomeScreen> {
  String _token = '';

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  // void _getData(token) async {
  //   http.Response response = await http.get(
  //     Uri.encodeFull("http://54.38.32.140/api/v1/twitter"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       "oauth_token": token
  //     },
  //   );
  //   var res = json.decode(response.body);
  //   print(res);
  // }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.of(context).pushNamed('/login');
      return null;
    }
    // _getData(token);
    setState(() => _token = token);
    return token;
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
                    horizontal: 10.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLogo(context),
                      SizedBox(height: 20.0),
                      _buildImage(0xFF6bd0ff, 'https://www.micromania.fr/on/demandware.static/-/Sites-Micromania-Library/default/dwd79d5229/fanzone/dossier/onepiece/onepiece-equipage.jpg'),
                      SizedBox(height: 20.0),
                      _buildImage(0xFF45dd45, 'https://www.actugaming.net/wp-content/uploads/2019/12/fairy-tail-artwork-rpg.jpg'),
                      SizedBox(height: 20.0),
                      _buildImage(0xFFeaedf6, 'https://www.actugaming.net/wp-content/uploads/2020/04/re-zero-starting-life-in-another-world-lost-memories--e1586179043161.jpg'),
                      SizedBox(height: 20.0),
                      _buildImage(0xFFe9d665, 'https://gaak.fr/wp-content/uploads/2019/08/Vignette-Haikyu-1170x550.jpg'),
                      SizedBox(height: 20.0),
                      _buildImage(0xFFcb7ccb, 'https://www.tvqc.com/wp-content/uploads/2018/12/DurararaAnime.jpg'),
                      SizedBox(height: 20.0),
                      _buildImage(0xFFff5858, 'https://www.reference-gaming.com/assets/media/product/11465/naruto-shippuden-volume-1-dvd-56d8254ce0a13.jpg?format=product-cover-large&k=1457005675'),
                      SizedBox(height: 20.0),
                      _buildLogoutButton(context),
                      Text(
                        _token,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        )
                      ),
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