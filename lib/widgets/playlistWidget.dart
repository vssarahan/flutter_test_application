import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class Playlist extends StatefulWidget{
  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist>{

  List<File> records = List<File>();

  Future<Directory> _buildSaveInDirectory() async {
    Directory appDir = await getExternalStorageDirectory();
    Directory(p.join(appDir.path, "flutter_test_app", "records")).create(recursive: true);
    return Directory(p.join(appDir.path, "flutter_test_app", "records"));
  }

  loadRecords () async {
    if (await Permission.storage.isGranted) {
      Directory appDir = await _buildSaveInDirectory();
      setState(() {
        records = List<File>();
        appDir.list(recursive: true, followLinks: false)
            .listen((FileSystemEntity entity) {
          if(entity is File)
            records.add(entity);
        });
      });
    }
    else
      await _requestStorageAccess();
  }

  _requestStorageAccess() async {
    await Permission.storage.request();
    await loadRecords();
  }

  @override
  void initState() {
    super.initState();
    _requestStorageAccess();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) =>
            Text(
              p.basename(records[index].path),
              style: TextStyle(color: Colors.white, fontSize: 28),),
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: records.length);
  }
}