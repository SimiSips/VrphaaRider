import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {

  static const String id = 'support';
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 40.0),
            width: 350,
            height: 200,
            child: Container(
                child: Text(
                  'Support Page', style: TextStyle(fontFamily: 'Brand-Bold',), textAlign: TextAlign.center,
                ),
            ),
          ),
        ),

    );
  }
}
