import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'homepage.dart';
import 'bluetooth/socialdistancemonitorPage.dart';
import 'settings/settings.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ElMessiri',
      ),
      home: new Splash(),
      routes: <String, WidgetBuilder>{
        '/Home': (BuildContext context) => new Home()
      },
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Home');
    //Navigator.push(context,MaterialPageRoute(builder: (context) => Splash()));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.indigo[400],
      body: new Center(
        child: new Image.asset(
          'images/playstore2.png',
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height/2,
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("Social Distance Monitor"),
            backgroundColor: Colors.indigo[400],
            automaticallyImplyLeading: false,
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.transparent,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.camera_alt,
                    color: Colors.black,
                  ),
                ), // Camera
                Tab(
                  icon: Icon(Icons.bluetooth_connected_outlined,
                    color: Colors.black,
                  ),
                ), //Bluetooth
                Tab(
                  icon: Icon(Icons.settings,
                    color: Colors.black,
                  ),
                ), //Settings
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomePage(cameras),
              sdmPage(),
              Settings(),
            ],
          ),
        )
    );
  }
}
