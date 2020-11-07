import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './notifier.dart';
import 'dart:math';

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    @required BluetoothDevice device,
    int rssi,
    bool enabled = true,
  }) : super(
    enabled: enabled,
    leading:
    Icon(Icons.devices), // @TODO . !BluetoothClass! class aware icon
    title: Text(device.name ?? "Unknown device"),
    subtitle: Text(device.address.toString()),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        rssi != null
            ? Container(
          margin: new EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: _computeTextStyle(rssi),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(rssi.toString()),
                Text('dBm'),
              ],
            ),
          ),
        )
            : Container(width: 0, height: 0),
        Notification_local(rssi: rssi,device: device),
      ],
    ),
  );

  static TextStyle _computeTextStyle(int rssi) {
     if (calculateDist(rssi)<2) {
      return TextStyle(color: Colors.red);
    }
    else
      return TextStyle(color: Colors.green);
  }
}

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