import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertestapplication/widgets/timerTextWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class Recorder extends StatefulWidget{
  @override
  _RecorderState createState() => _RecorderState();
}

class _RecorderState extends State<Recorder>{
  Stopwatch _watch = Stopwatch();
  Recording _recording;
  bool _isRecording = false;
  File defaultAudioFile;
  String _filename;

  Widget _buildFloatingButton(IconData icon, VoidCallback callback) {
    return new FloatingActionButton(
        child: Icon(icon, size: 40),
        onPressed: callback,
        backgroundColor: Colors.white,
    );
  }

  stopRecording() async {
    var recording = await AudioRecorder.stop();
    _watch.stop();
    bool isRecording = await AudioRecorder.isRecording;

    Directory appDir = await getApplicationDocumentsDirectory();
    Directory docDir = Directory(p.join(appDir.path, "records"));
    docDir.list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      print(entity.path);
    });

    setState(() {
      //Tells flutter to rerun the build method
      _isRecording = isRecording;
      defaultAudioFile = File(p.join(docDir.path, _filename+'.m4a'));
    });
  }


  Future<void> startRecording() async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      Directory(p.join(appDir.path, "records")).create(recursive: true);
      Directory docDir = Directory(p.join(appDir.path, "records"));
      _filename = DateTime.now().microsecondsSinceEpoch.toString();
      String newFilePath = p.join(docDir.path, _filename);
      File tempAudioFile = File(newFilePath+'.m4a');
      if (await tempAudioFile.exists()){
        await tempAudioFile.delete();
      }
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.speech,
        Permission.storage
      ].request();
      if (await Permission.microphone.isGranted) {
        await AudioRecorder.start(
            path: newFilePath, audioOutputFormat: AudioOutputFormat.AAC);
        _watch..reset()..start();
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Error! Audio recorder lacks permissions.")));
      }
      bool isRecording = await AudioRecorder.isRecording;
      setState(() {
        //Tells flutter to rerun the build method
        _recording = new Recording(duration: new Duration(), path: newFilePath);
        _isRecording = isRecording;
        defaultAudioFile = tempAudioFile;
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
            height: 200.0,
            child: new Center(
              child: new TimerText(stopwatch: _watch),
            )),
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFloatingButton(Icons.stop, stopRecording),
              _buildFloatingButton(_watch.isRunning ? Icons.save : Icons.play_arrow, startRecording),
            ]),
      ],
    );
  }
}