import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './notifier_helper.dart';
import 'dart:math';

// ignore: must_be_immutable, camel_case_types
class Notification_local extends StatefulWidget {
  Notification_local({Key key, this.rssi,this.device}) : super(key: key);
  final int rssi;
  var device;
  @override
  _NotificationState createState() => _NotificationState(rssi: rssi,device: device);
}

class _NotificationState extends State<Notification_local> {

  _NotificationState({this.rssi, this.device});

  final int rssi;
  var device;

  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async =>
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('SDM Alert'),
            content: Text("MAINTAIN SOCIAL DISTANCING: ${device.name} is near you"),
            actions: <Widget>[
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

  double calculateDist(int rssi) {
    var txPower = -59;
    if (rssi == 0) {
      return -1.0;
    }
    var ratio = rssi * 1.0 / txPower;
    if (ratio < 1.0) {
      return pow(ratio, 10);
    }
    else {
      var distance = (0.89976) * pow(ratio, 7.7095) + 0.111;
      return distance;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(calculateDist(rssi)<2) {
       showOngoingNotification(notifications, title: "APP NAME", body: "SDM: Violation alert");
    }
    return Container();
  }
}
