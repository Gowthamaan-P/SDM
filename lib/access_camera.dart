import 'dart:math' as math;

import 'homepage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:tflite/tflite.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class SocialDistancingApp extends StatefulWidget {
  static String socialDistancingId = "socialdistancing_id";
  final List<CameraDescription> cams;
  final Callback setRecognitions;
  SocialDistancingApp(this.cams, this.setRecognitions);
  @override
  _SocialDistancingAppState createState() => _SocialDistancingAppState();
}

class _SocialDistancingAppState extends State<SocialDistancingApp> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.cams[0], ResolutionPreset.ultraHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.startImageStream((CameraImage img) {
        if (!isDetecting) {
          isDetecting = true;
          int startTime = DateTime.now().millisecondsSinceEpoch;
          Tflite.detectObjectOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            model: "SSDMobileNet",
            imageHeight: img.height,
            imageWidth: img.width,
            threshold: 0.4,
            numResultsPerClass: 6,
          ).then((recognitions) {
            print(recognitions);
            List<dynamic> distilledRecognitions = [];
            int endTime = new DateTime.now().millisecondsSinceEpoch;
            print("Detection took ${endTime - startTime}");
            for (var recognition in recognitions) {
              if (recognition != null &&
                  recognition['detectedClass'] == "person" &&
                  recognition['confidenceInClass'] > 0.62) {
                distilledRecognitions.add(recognition);
              }
            }
            widget.setRecognitions(
                distilledRecognitions, img.height, img.width);
            isDetecting = false;
          });
        }
      });
    }).catchError((error) {
      print(error);
      Navigator.pushNamed(context, HomePage.homepageId);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;
    return Scaffold(
      body: NativeDeviceOrientationReader(
        builder: (context) {
          NativeDeviceOrientation orientation =
              NativeDeviceOrientationReader.orientation(context);

          int turns;
          switch (orientation) {
            case NativeDeviceOrientation.landscapeLeft:
              turns = -1;
              break;
            case NativeDeviceOrientation.landscapeRight:
              turns = 1;
              break;
            case NativeDeviceOrientation.portraitDown:
              turns = 2;
              break;
            default:
              turns = 0;
              break;
          }

          return RotatedBox(
            quarterTurns: turns,
            child: OverflowBox(
              maxHeight: screenRatio > previewRatio
                  ? screenH
                  : screenW / previewW * previewH,
              maxWidth: screenRatio > previewRatio
                  ? screenH / previewH * previewW
                  : screenW,
              child: CameraPreview(controller),
            ),
          );
        },
      ),
    );
  }
}
