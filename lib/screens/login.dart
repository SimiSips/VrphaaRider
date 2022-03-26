//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:cab_rider/screens/otp.dart';

import '../globalvariable.dart';

class LoginPhone extends StatefulWidget {
  static String id = "loginphone";

  @override
  _LoginPhoneState createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Phone Auth'),
      ),*/
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Verify Your Phone Number',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+27'),
                  ),
                ),
                maxLength: 9,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OTPScreen(_controller.text)));
                /*assetsAudioPlayer.open(
                  Audio('sounds/welcome.mp3'),
                );
                assetsAudioPlayer.play();*/
                print('Welcome clicked');
              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          /*Container(
            child: RaisedButton(
              onPressed: () {
                assetsAudioPlayer.stop();
              },
              color: Colors.yellowAccent,
            ),
          )*/
        ],
      ),
    );
  }
}