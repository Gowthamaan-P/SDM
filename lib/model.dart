import 'dart:math' as math;

import 'package:flutter/material.dart';

class Model extends StatelessWidget {
  final List<dynamic> results;
  final int _imgHeight;
  final int _imgWidth;
  final double screenH;
  final double screenW;
  Model(this.results, this._imgHeight, this._imgWidth, this.screenH,
      this.screenW);
  double distanceCalculation(double dx, double dy, double dz) {
    return math.sqrt(math.pow(dx, 2) + math.pow(dy, 2) + math.pow(dz, 2));
  }

  @override
  Widget build(BuildContext context) {
    int numOfTotalDetected = results.length;
    int numOfPersonsSafe = 0;
    int numOfPersonsUnsafe = 0;
    int focalLength = 615;
    List<dynamic> checkResults = [];
    for (var res1 in results) {
      res1["isSafe"] = true;
      for (var res2 in results) {
        print(res2["isSafe"]);
        if (res1 == res2) {
          continue;
        } else {
          var xCord1 = res1["rect"]["x"];
          var wCord1 = res1["rect"]["w"];
          var yCord1 = res1["rect"]["y"];
          var hCord1 = res1["rect"]["h"];
          var scaleW1, scaleH1, x1, y1, w1, h1;

          if (screenH / screenW > _imgHeight / _imgWidth) {
            scaleW1 = screenH / _imgHeight * _imgWidth;
            scaleH1 = screenH;
            var difW = (scaleW1 - screenW) / scaleW1;
            x1 = (xCord1 - difW / 2) * scaleW1;
            w1 = wCord1 * scaleW1;
            if (xCord1 < difW / 2) w1 -= (difW / 2 - xCord1) * scaleW1;
            y1 = yCord1 * scaleH1;
            h1 = hCord1 * scaleH1;
          } else {
            scaleH1 = screenW / _imgHeight * _imgWidth;
            scaleW1 = screenW;
            var difH = (scaleH1 - screenH) / scaleH1;
            x1 = xCord1 * scaleW1;
            w1 = wCord1 * scaleW1;
            y1 = (yCord1 - difH / 2) * scaleH1;
            h1 = hCord1 * scaleH1;
            if (yCord1 < difH / 2) h1 -= (difH / 2 - yCord1) * scaleH1;
          }
          var xCord2 = res2["rect"]["x"];
          var wCord2 = res2["rect"]["w"];
          var yCord2 = res2["rect"]["y"];
          var hCord2 = res2["rect"]["h"];
          var scaleW2, scaleH2, x2, y2, w2, h2;

          if (screenH / screenW > _imgHeight / _imgWidth) {
            scaleW2 = screenH / _imgHeight * _imgWidth;
            scaleH2 = screenH;
            var difW = (scaleW2 - screenW) / scaleW2;
            x2 = (xCord2 - difW / 2) * scaleW2;
            w2 = wCord2 * scaleW2;
            if (xCord2 < difW / 2) w2 -= (difW / 2 - xCord2) * scaleW2;
            y2 = yCord2 * scaleH2;
            h2 = hCord2 * scaleH2;
          } else {
            scaleH2 = screenW / _imgHeight * _imgWidth;
            scaleW2 = screenW;
            var difH = (scaleH2 - screenH) / scaleH2;
            x2 = xCord2 * scaleW2;
            w2 = wCord2 * scaleW2;
            y2 = (yCord2 - difH / 2) * scaleH2;
            h2 = hCord2 * scaleH2;
            if (yCord2 < difH / 2) h2 -= (difH / 2 - yCord2) * scaleH2;
          }
          var midx1 = x1 + (w1 / 2);
          var midy1 = y1 + (h1 / 2);
          var midx2 = x2 + (w2 / 2);
          var midy2 = y2 + (h2 / 2);
          var distanceCameraFromPerson1 = (165 * focalLength) / (h1);
          var distanceCameraFromPerson2 = (165 * focalLength) / (h2);
          var xNormal1 = (midx1 * distanceCameraFromPerson1) / focalLength;
          var yNormal1 = (midy1 * distanceCameraFromPerson1) / focalLength;
          var xNormal2 = (midx2 * distanceCameraFromPerson2) / focalLength;
          var yNormal2 = (midy2 * distanceCameraFromPerson2) / focalLength;
          var dist = distanceCalculation(
              xNormal1 - xNormal2,
              yNormal1 - yNormal2,
              distanceCameraFromPerson1 - distanceCameraFromPerson2);
          // print('dist=$dist');
          if (dist < 150.0) {
            numOfPersonsUnsafe++;
            res1['isSafe'] = false;
            break;
          }
        }
      }
      // print('res1=$res1');
      checkResults.add(res1);
    }
    numOfPersonsSafe = numOfTotalDetected - numOfPersonsUnsafe;

    List<Widget> _renderBoxes() {
      return checkResults.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > _imgHeight / _imgWidth) {
          scaleW = screenH / _imgHeight * _imgWidth;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = screenW / _imgHeight * _imgWidth;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: re['isSafe'] == true ? Colors.green : Colors.red,
                width: 2.0,
              ),
            ),
            child: Text(
              re['isSafe'] == true ? "SAFE" : "UNSAFE",
              style: TextStyle(
                color: re['isSafe'] == true ? Colors.green : Colors.red,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      }).toList();
    }

    List<dynamic> widgets = _renderBoxes();
    return Stack(children: [
      Stack(
        children: widgets,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "# People Detected: $numOfTotalDetected",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "ElMessiri",
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Colors.teal,
              decoration: TextDecoration.none,
            ),
          ),
          Text("# People in Safe Distance: $numOfPersonsSafe",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: "ElMessiri",
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.green,
                decoration: TextDecoration.none,
              )),
          Text(
            "# People very Close: $numOfPersonsUnsafe",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "ElMessiri",
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Colors.red,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    ]);
  }
}
