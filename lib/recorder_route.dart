import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertestapplication/widgets/timerTextWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class RecorderRoute extends StatefulWidget{
  @override
  _RecorderRouteState createState() => _RecorderRouteState();
}

class _RecorderRouteState extends State<RecorderRoute>{
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

  Future<Directory> _buildSaveInDirectory() async {
    Directory appDir = await getExternalStorageDirectory();
    Directory(p.join(appDir.path, "flutter_test_app", "records")).create(recursive: true);
    return Directory(p.join(appDir.path, "flutter_test_app", "records"));
  }

  _saveRecording() async {
    var recording = await AudioRecorder.stop();
    _watch.stop();
    bool isRecording = await AudioRecorder.isRecording;

    Directory docDir = await _buildSaveInDirectory();
    docDir.list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      print(entity.path);
    });

    setState(() {
      _isRecording = isRecording;
      defaultAudioFile = File(p.join(docDir.path, _filename+'.m4a'));
      _watch.reset();
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Запись прошла успешно!")));
    });
  }


  Future<void> _startRecording() async {
    try {
      Directory docDir = await _buildSaveInDirectory();
      _filename = DateTime.now().microsecondsSinceEpoch.toString();
      String newFilePath = p.join(docDir.path, _filename);
      File tempAudioFile = File(newFilePath+'.m4a');
      if (await Permission.microphone.isGranted && await Permission.storage.isGranted) {
        await AudioRecorder.start(
            path: newFilePath, audioOutputFormat: AudioOutputFormat.AAC);
        _watch..reset()..start();
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: newFilePath);
          _isRecording = isRecording;
          defaultAudioFile = tempAudioFile;
        });
      } else {
        await [
          Permission.microphone,
          Permission.speech,
          Permission.storage
        ].request();
      }
    } catch (e) {
      print(e);
    }
  }

  _deleteRecording() async {
    if (defaultAudioFile != null){
      setState(() {
        _isRecording = false;
        defaultAudioFile.delete();
        _watch..stop()..reset();
      });
    }else{
      print ("Error! defaultAudioFile is $defaultAudioFile");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          new Container(
              height: 450.0,
              child: new Center(
                child: new TimerText(stopwatch: _watch),
              )),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildFloatingButton(Icons.stop, _deleteRecording),
                _buildFloatingButton(_watch.isRunning ? Icons.save : Icons.play_arrow,
                    _watch.isRunning ? _saveRecording : _startRecording),
              ]),
        ],
      )
    );
  }
}