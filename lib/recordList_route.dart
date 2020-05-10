import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertestapplication/main.dart';
import 'package:fluttertestapplication/widgets/playlistWidget.dart';

class RecordListRoute extends StatefulWidget{
  _RecordListRouteState createState() => _RecordListRouteState();
}

class _RecordListRouteState extends State<RecordListRoute>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Список записей", style: TextStyle(fontSize: 25),)
      ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: Playlist()
      )
    );
  }
}