import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Package> fetchPackages() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  http.Response response = await http.get(
    Uri.encodeFull("http://92.222.76.5:8000/api/packages"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": 'Bearer ' + token
    },
  );
  return Package.fromJson(json.decode(response.body));
}

class Package {
  final String message;
  final List<Result> packages;
  final int count;

  Package({this.message, this.packages, this.count});

  factory Package.fromJson(Map<String, dynamic> json) {
    List<Result> resultsList;
    var list = json['datas'] as List;
    if (json['count'] != 0) {
      resultsList = list.map((i) => Result.fromJson(i)).toList();
    } else {
      resultsList = null;
    }

    return Package(
      message: json['message'],
      packages: resultsList,
      count: json['count'],
    );
  }
}

class Result {
  final String uid;
  final pos;
  bool todo;

  Result({this.uid, this.pos, this.todo});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      uid: json['uid'],
      pos: json['pos'],
      todo: json['todo'],
    );
  }
}

class PackagesScreen extends StatefulWidget {
  @override
  _PackagesScreenState createState() => _PackagesScreenState();
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

class _PackagesScreenState extends State<PackagesScreen> {
  Future<Package> futurePackages;
  int _selectedIndex = 2;
  var datas;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushNamed('/home');
    } else if (index == 1) {
      Navigator.of(context).pushNamed('/deliverers');
    } else if (index == 3) {
      Navigator.of(context).pushNamed('/newPackage');
    } else if (index == 4) {
      Navigator.of(context).pushNamed('/profil');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePackages = fetchPackages();
  }

  void _choosePackage(package) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // ignore: unused_local_variable
    http.Response response = await http.put(
      Uri.encodeFull("http://92.222.76.5:8000/api/choosePackage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": 'Bearer ' + token
      },
      body: jsonEncode(
        {'uid': package.uid, 'bool': !package.todo},
      ),
    );
    setState(() {
      futurePackages = fetchPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FutureBuilder<Package>(
            future: futurePackages,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.count != 0) {
                  List<Package> packages = List<Package>();
                  for (int i = 0; i < snapshot.data.count; i++) {
                    packages.add(
                      Package(
                        packages: [
                          Result(
                            uid: snapshot.data.packages[i].uid,
                            pos: snapshot.data.packages[i].pos,
                            todo: snapshot.data.packages[i].todo,
                          ),
                        ],
                      ),
                    );
                  }
                  return Stack(
                    children: <Widget>[
                      _buildBackground(),
                      ListView(
                        children: packages
                            .map((package) => Card(
                                  color: Colors.white30,
                                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Text(
                                          "Colis: ${package.packages[0].uid}",
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          "X: ${package.packages[0].pos[0]}; Y: ${package.packages[0].pos[1]}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Checkbox(
                                          value: package.packages[0].todo,
                                          onChanged: (value) {
                                            _choosePackage(
                                              package.packages[0],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
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
                            )
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
