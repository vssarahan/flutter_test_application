import 'package:flutter/material.dart';
import 'package:fluttertestapplication/geoposition_route.dart';
import 'package:fluttertestapplication/home_route.dart';
import 'package:fluttertestapplication/recordList_route.dart';
import 'package:fluttertestapplication/recorder_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Widget _getRoute(int index){
    if(index == 0)
      return HomeRoute();
    else if(index == 1)
      return GeopositionRoute();
    else if(index == 2)
      return RecorderRoute();
    else if(index == 3)
      return RecordListRoute();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getRoute(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text('Geoposition'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            title: Text('Recording'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Records'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
