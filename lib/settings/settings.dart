import './useragreementPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Settings extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children:<Widget> [
        Container(
            padding: EdgeInsets.fromLTRB(15.0,20.0,4.0,4.0),
            child: Text(
              "SDM, 1.1.0",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            )
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
            child: Text(
              "Application name and version",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey
              ),
            )
        ),
        Divider(),
        Container(
            padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
            child: Text(
              "Contact Information",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey
              ),
            )
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
            child: Text(
              "Equinox",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            )
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
            child: Text(
              "Developer",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey
              ),
            )
        ),
        Container(
            padding: EdgeInsets.fromLTRB(15.0,4.0,4.0,4.0),
            child: Text(
              "equinoxgroup258.com",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.indigo[400]
              ),
            )
        ),
        Divider(),
        Center(
          child: FlatButton(
            onPressed:(){
              Navigator.push(context, MaterialPageRoute (builder:(context)=>useragreementPage()),);
            },
            child: Text(
              "END-USER LICENCE AGREEMENT",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.indigo[400],
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
        ),
      ],
    );
  }
}