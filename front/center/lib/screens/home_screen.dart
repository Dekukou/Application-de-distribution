import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Planning> fetchPlanning() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  http.Response response = await http.get(
    Uri.encodeFull("http://92.222.76.5:8000/api/getPlanning"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": 'Bearer ' + token
    },
  );
  return Planning.fromJson(json.decode(response.body));
}

class Planning {
  final String message;
  final List<Result> plannings;
  final int count;

  Planning({this.message, this.plannings, this.count});

  factory Planning.fromJson(Map<String, dynamic> json) {
    List<Result> resultsList;
    var list = json['datas'] as List;

    if (json['count'] != 0) {
      resultsList = list.map((i) => Result.fromJson(i)).toList();
    } else {
      resultsList = null;
    }

    return Planning(
      message: json['message'],
      plannings: resultsList,
      count: json['count'],
    );
  }
}

class Result {
  final String uid;
  final int length;
  final tour;

  Result({this.uid, this.length, this.tour});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      uid: json['uid'],
      length: json['length'],
      tour: json['tour'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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

class _HomeScreenState extends State<HomeScreen> {
  Future<Planning> futurePlanning;
  int _selectedIndex = 0;
  var datas;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.of(context).pushNamed('/deliverers');
    } else if (index == 2) {
      Navigator.of(context).pushNamed('/packages');
    } else if (index == 3) {
      Navigator.of(context).pushNamed('/newPackage');
    } else if (index == 4) {
      Navigator.of(context).pushNamed('/profil');
    }
  }

  @override
  void initState() {
    super.initState();
    _connected();
    futurePlanning = fetchPlanning();
  }

  void _getPlanning() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    http.Response response = await http.get(
      Uri.encodeFull("http://92.222.76.5:8000/api/getPlanning"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": 'Bearer ' + token
      },
    );
    var res = json.decode(response.body);
    setState(() {
      datas = res;
    });
  }

  void _connected() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.of(context).pushNamed('/login');
    } else {
      _getPlanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FutureBuilder<Planning>(
            future: futurePlanning,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.count != 0) {
                  List<Planning> plannings = List<Planning>();
                  for (int i = 0; i < snapshot.data.count; i++) {
                    plannings.add(
                      Planning(
                        plannings: [
                          Result(
                            uid: snapshot.data.plannings[i].uid,
                            tour: snapshot.data.plannings[i].tour,
                            length: snapshot.data.plannings[i].length,
                          ),
                        ],
                      ),
                    );
                  }
                  return Stack(
                    children: <Widget>[
                      _buildBackground(),
                      ListView(
                        children: plannings
                            .map((planning) =>
                                planningTemplate(planning.plannings[0]))
                            .toList(),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: <Widget>[
                      _buildBackground(),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 40),
                            _myText(
                              "${snapshot.data.message}",
                              50.0,
                              Alignment.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }
              return Stack(
                children: <Widget>[
                  _buildBackground(),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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

Widget planningTemplate(planning) {
  return Card(
    color: Colors.white30,
    margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
    elevation: 4.0,
    child: Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Livreur: ${planning.uid}",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Colis: ${planning.tour}",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "${planning.length} km",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
