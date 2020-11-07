import 'dart:math' as math;

import 'access_camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

import 'constants.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  static String homepageId = "HomePage";
  final List<CameraDescription> cameras;
  HomePage(this.cameras);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  setRecognitions(recognitions, imageHeight, imageWidth) async {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return _model == ""
        ? WillPopScope(
            onWillPop: () {
              SystemNavigator.pop();
              return Future.value(false);
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 25.0
                                : 50.0,
                            backgroundColor: Colors.teal[50],
                            child: Image(
                              image: AssetImage('images/playstore2.png'),
                            ),
                          ),
                          Text(
                            "Break the chain !",
                            textAlign: TextAlign.center,
                            style: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? kHomePageTextStyle.copyWith(fontSize: 25.0)
                                : kHomePageTextStyle,
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0)
                                : EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            child: RaisedButton(
                              color: Colors.indigo[400],
                              focusColor: Colors.teal,
                              padding: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? EdgeInsets.all(15.0)
                                  : EdgeInsets.all(8.0),
                              child: Text(
                                "Start Monitoring",
                                style: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? kHomePageButtonStyle.copyWith(
                                        fontSize: 15.0)
                                    : kHomePageButtonStyle,
                              ),
                              onPressed: () async {
                                setState(() {
                                  _model = "assets/ssd_mobilenet.tflite";
                                });
                                try {
                                  await Tflite.loadModel(
                                    model: "assets/ssd_mobilenet.tflite",
                                    labels: "assets/ssd_mobilenet.txt",
                                  );
                                } on PlatformException {
                                  print(
                                      "Failed to load the object detection model");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () {
              Navigator.of(context).pushNamed(HomePage.homepageId);
              return Future.value(false);
            },
            child: Stack(
              children: [
                SocialDistancingApp(widget.cameras, setRecognitions),
                Model(
                  _recognitions == null ? [] : _recognitions,
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  screen.height,
                  screen.width,
                ),
              ],
            ),
          );
  }
}
