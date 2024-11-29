import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:location/location.dart';

class MapView extends StatelessWidget {
  Location location = new Location();
  InAppWebViewController webView;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;


  Future<LocationData> getLatLong() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return _locationData = null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return _locationData = null;
      }
    }
    return _locationData = await location.getLocation();
  }


  String MY_URL = 'http://118.67.130.251:2400';
  //String MY_URL = 'http://192.168.219.105:3000';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLatLong(),
        builder: (BuildContext context, AsyncSnapshot<LocationData> snap) {
          if (!snap.hasData || snap.data.longitude == null)
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          String _url = MY_URL + "/?latitude=${snap.data.latitude.toString()}&longitude=${snap.data.longitude.toString()}";
          return InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(_url))
          );
        }
        );
  }

}
