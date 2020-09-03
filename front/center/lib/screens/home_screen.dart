import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';



// void main() => runApp(MyApp());

// /// This Widget is the main application widget.
// class MyApp extends StatelessWidget {
//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: MyStatefulWidget(),
//     );
//   }
// }

// class MyStatefulWidget extends StatefulWidget {
//   MyStatefulWidget({Key key}) : super(key: key);

//   @override
//   _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
// }

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text(
//       'Index 0: Home',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 1: Business',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 2: School',
//       style: optionStyle,
//     ),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('BottomNavigationBar Sample'),
//       ),
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             title: Text('Home'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             title: Text('Business'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.school),
//             title: Text('School'),
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

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

Widget _myText(value, size, pos) {
  return Align(
    alignment: pos,
    child: Container(
      child: Text(
        value,
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: size,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        )
      )
    )
  );
}

Widget _progressBar(context, planning) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 20),
    width: MediaQuery.of(context).size.width * 0.85,
    height: 20,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: LinearProgressIndicator(
        value: ((planning['datas']['actual_dist'] * 100) / planning['datas']['length']) / 100,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
        backgroundColor: Color(0xffD6D6D6),
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

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  var planning;

  void _onItemTapped(int index) async {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.of(context).pushNamed('/profil');
    }
  }

  @override
  void initState() {
    super.initState();
    _getPlanning();
  }

  void _getPlanning() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    http.Response response = await http.get(
      Uri.encodeFull("http://92.222.76.5:8000/api/planning"),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": 'Bearer ' + token
    });
    var res = json.decode(response.body);
    setState(() {
        planning = res;
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
              new Flexible(child: new MyContainer(planning: planning))
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

// ignore: must_be_immutable
class MyContainer extends StatelessWidget {
  var planning;
  MyContainer({this.planning});

  @override
  Widget build(BuildContext context) {
    return this.planning == null ? new Container(
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
            _buildLogoutButton(context),

      ]
      ),
    ) 
    : this.planning['datas'] == null ? new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            _myText("${planning['message']}", 50.0, Alignment.center),
            _buildLogoutButton(context),
          ]
        ),
      )
    : new Container(
      child: Column(
        children: <Widget> [
            SizedBox(height: 30),

          _buildLogo(context),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Column(
                children: <Widget> [
                  _myText("Livreur: ${planning['datas']['uid']}", 16.0, Alignment.centerLeft),
                ]
              ),
            ),
            SizedBox(height: 60),
            _myText("${planning['datas']['package']}", 22.0, Alignment.center),
            SizedBox(height: 60),
            _myText("X: ${planning['datas']['x']}; Y: ${planning['datas']['y']}", 18.0, Alignment.center),
            SizedBox(height: 40),
            _progressBar(context, planning),
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _myText("${planning['datas']['actual_dist']}", 18.0, Alignment.center),
                  _myText("${planning['datas']['length']}", 18.0, Alignment.center),
                ]
              ),
            ),
            SizedBox(height: 40),
            _myText("${planning['datas']['actual']} / ${planning['datas']['total']}", 22.0, Alignment.center),
            _buildLogoutButton(context),
          ],
      ),
    );
  }
}