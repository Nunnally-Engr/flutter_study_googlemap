import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

import 'package:flutter_study_googlemap/my_location.dart';
import 'package:android_intent/android_intent.dart';

void main() {
  GoogleMapController.init();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Map Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.lightBlue,
      ),
      home: new MyHomePage(title: 'Flutter Google Map Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  @override
  initState() {
    super.initState();
  }

  int _counter = 0;
  var _currentLocation = <String, double>{};
  var location = new Location();    

  void _incrementCounter() {
    // 状態管理
    setState(() {
      _counter++;
    });
  }

  // 自分の位置情報取得
  void _getMyLocation() async {
    try {
      _currentLocation = await location.getLocation();
      print('_currentLocation');
      print(_currentLocation);
      _showDialog();
    } on PlatformException {
      _currentLocation = null;
    }
  }

  void _launchNavigationInGoogleMaps() async {

    try {
      _currentLocation = await location.getLocation();

      var query = _currentLocation["latitude"] + ',' + _currentLocation["longitude"];
      if (Theme.of(context).platform == TargetPlatform.android) {
        final AndroidIntent intent = new AndroidIntent(
            action: 'action_view',
            data:
                "https://www.google.com/maps/search/?api=1&query=" + query.toString(),
            package: 'com.google.android.apps.maps');
        intent.launch();
      }
    } on PlatformException {
      _currentLocation = null;
    }

  }

  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text(_currentLocation.toString()),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // レイアウト部分
    return new Scaffold(
      appBar: new AppBar(
        // アプリケーションバー
        title: new Text(widget.title),
      ),
      body: new Center(
        // 本体レイアウト
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              color: Colors.lightBlueAccent.shade100,
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.lightBlueAccent.shade100,
              elevation: 5.0,
              child: MaterialButton(
                minWidth: 100.0,
                height: 42.0,
                onPressed: _getMyLocation,
                child: Text('現在地取得', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              color: Colors.lightBlueAccent.shade100,
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.lightBlueAccent.shade100,
              elevation: 5.0,
              child: MaterialButton(
                minWidth: 100.0,
                height: 30.0,
                onPressed: _launchNavigationInGoogleMaps,
                child: Text('GoogleMapを開く', style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
        
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => Mylocation()));
        },
        child: new Icon(Icons.my_location),
      ),
    );
  }
}
