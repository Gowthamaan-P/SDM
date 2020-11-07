import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './sDmWidget.dart';
import "package:system_settings/system_settings.dart";

// ignore: camel_case_types
class sdmPage extends StatefulWidget {
  @override
  _sdmPageState createState() => _sdmPageState();
}

// ignore: camel_case_types
class _sdmPageState extends State<sdmPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }
  // ignore: non_constant_identifier_names
  Widget call_scan()
  {
    if(_bluetoothState.isEnabled)
      {
        return DiscoveryPage();

      }
    else
      {
        return new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child:AppBar(
            title: Text("Near by People"),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.indigo[400],
            ),
          ),
          body: Center(
            child:Text("Turn on bluetooth to detect Near By People",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
          ),
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    double height= (MediaQuery.of(context).size.height)-128;
    return  new Scaffold(
        body:  Column(
          children: <Widget>[
            Container(
              height: height/2.15,
              child: ListView(
                children: <Widget>[
                  ListTile(title: const Text(
                    'Bluetooth SDM - My Device',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  ),
                  SwitchListTile(
                    title: const Text('Enable Bluetooth For SDM'),
                    value: _bluetoothState.isEnabled,
                    onChanged: (bool value) {
                      future() async {
                        if (value) {
                          await FlutterBluetoothSerial.instance.requestEnable();
                          SystemSettings.system();
                        }
                        else {
                          await FlutterBluetoothSerial.instance.requestDisable();
                        }
                      }
                      future().then((_) {
                        setState(() {});
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Local adapter address'),
                    subtitle: Text(_address),
                  ),
                  ListTile(
                    title: const Text('Local adapter name'),
                    subtitle: Text(_name),
                    onLongPress: null,
                  ),
                ],
              ),
            ),
            Container(
              height:height/2,
              child: call_scan(),
            ),
          ],
        )
    );
  }
}

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;

  const DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  _DiscoveryPage();

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });
    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            results.add(r);
          });
        });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });

  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(40.0), // here the desired height
        child: AppBar(
          backgroundColor: Colors.indigo[400],
          automaticallyImplyLeading: false,
          title: Text("Near By People"),
          actions: <Widget>[
            isDiscovering
                ? FittedBox(
              child: Container(
                margin: new EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
                : IconButton(
              icon: Icon(Icons.replay),
              onPressed: _restartDiscovery,
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
          );
        },
      ),
    );
  }
}
