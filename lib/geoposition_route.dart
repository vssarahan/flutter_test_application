import 'package:flutter/material.dart';
import 'package:location/location.dart';

class GeopositionRoute extends StatefulWidget {
  @override
  _GeopositionRouteState createState() => _GeopositionRouteState();
}

class _GeopositionRouteState extends State<GeopositionRoute> {

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future<void> _initGeoposition() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initGeoposition();
  }

  @override
  Widget build(BuildContext context) => Center(
        child:
          _locationData == null
              ? CircularProgressIndicator()
              : Text("Location:" + _locationData.latitude.toString() + " " + _locationData.longitude.toString()),
      );
}