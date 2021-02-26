import 'package:flutter/material.dart';

// ignore: camel_case_types
class useragreementPage extends StatelessWidget {
  static const String routeName = '/Page';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[400],
          title: Text("End-User License Agreement"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Container(
                padding: EdgeInsets.fromLTRB(15.0,20.0,4.0,4.0),
                child: Text(
                  "SDM, 1.1.0",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
                child:Row(
                  children:<Widget> [
                    Text("Copyright "),
                    Icon(Icons.copyright, size: 16),
                    Text(" 2020 Equinox Group")
                  ],
                ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15.0,4.0,12.0,4.0),
                child: Text(
                  "SDM - Social Distance Monitor is developed by Gowthamaan for Social Distance Monitoring using Bluetooth and Camera.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                )
            )
          ],
        )
    );
  }
}
