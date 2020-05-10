import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertestapplication/widgets/timerTextWidget.dart';

class Recorder extends StatefulWidget{
  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder>{
  ///Stopwatch _watch = Stopwatch()..stop();

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(height: 200.0,
            child: new Center(
              child: Text(""),///new TimerText(stopwatch: _watch),
            )),
        new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ///buildFloatingButton(stopwatch.isRunning ? "lap" : "reset", leftButtonPressed),
            ///  buildFloatingButton(stopwatch.isRunning ? "stop" : "start", rightButtonPressed),
            ]),
      ],
    );
  }
}