import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'loginpage.dart';
import 'mainpage.dart';



class PersonPage extends StatelessWidget {
  static const id = 'person';

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'simphiwe.radebe0706@gmail.com',
      queryParameters: {
        'subject': 'Support Needed!'
      }
  );

  @override
  Widget build(BuildContext context) {
    double widthC = MediaQuery
        .of(context)
        .size
        .width * 100;
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[



              //==========================================================================================
              // build Top Section of Profile (include : Image & main info & card of info[photos ... ] )
              //==========================================================================================
              _buildHeader(context, widthC),

              SizedBox(height: 10.0),

              //==========================================================================================
              //  build Bottom Section of Profile (include : email - phone number - about - location )
              //==========================================================================================
              _buildInfo(context, widthC),


            ],
          ),
        ));
  }

  Widget _buildHeader(BuildContext context, double width) {
    return Stack(
      children: <Widget>[
        /*Ink(
          height: 100,
          color: Colors.yellowAccent,
        ),*/
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /*TaxiButton(
                    onPressed:(){
                      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
                    },
                    color: Colors.black87,
                    title: "Go Back",
                    //child: Icon(Icons.arrow_back, color: Colors.black87,)
                    //child: Text("GO BACK")
                ),*/
              SizedBox(
                height: 5.0,
                width: 20.0,
              ),
                  Padding(
                    padding: const EdgeInsets.only(left:150.0, right: 150.0),
                    child: RaisedButton(
                       onPressed: (){
                         Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
                         },
                         shape: new RoundedRectangleBorder(
                             borderRadius: new BorderRadius.circular(30)
                         ),
                        color: Colors.black87,
                        textColor: Colors.white,
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back, color: Colors.white,
                          ),
                    ),
                ),
              ),
                  )
            ],
          ),
        ),
      ],
    );
  }

  /*Widget _buildInfoCard(context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Card(
            elevation: 5.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 16.0, right: 10.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'Photos',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          '15',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(0Xffde6262),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        'Followers',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          '3.5k',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(0Xffde6262),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        'Following',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          '150',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(0Xffde6262),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }*/

  /*Widget _buildMainInfo(BuildContext context, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text('Profile', style: TextStyle(
              fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Flutter', style: TextStyle(
              color: Colors.grey.shade50, fontStyle: FontStyle.italic))
        ],
      ),
    );
  }*/

  Widget _buildInfo(BuildContext context, double width) {
    return Container(
        padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        child: Card(
          color: Colors.white,
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                    ),
                    GestureDetector(
                      onTap: () {
                        launch(_emailLaunchUri.toString());
                      },
                      child: ListTile(
                        leading: Icon(
                            Icons.email, color: Colors.black),
                        title: Text("Press here to email us!",
                            style: TextStyle(fontSize: 18, color: Colors.black)),
                        subtitle: Text('braincapdevelopers1@gmail.com', style: TextStyle(
                            fontSize: 15, color: Colors.black54)),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                    ),

                      GestureDetector(
                        onTap: (){
                          launch(('tel://+27681303736'));
                        },
                        child: ListTile(
                          leading: Icon(
                              Icons.phone, color: Colors.black),
                          title: Text("Press to call support",
                              style: TextStyle(fontSize: 18, color: Colors.black)),
                          subtitle: Text('+27 68 130 3736', style: TextStyle(
                              fontSize: 15, color: Colors.black54)),
                        ),
                      ),

                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.person, color: Colors.black),
                      title: Text("Company",
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                      subtitle: Text(
                          'Brain Cab Support',
                          style: TextStyle(
                              fontSize: 15, color: Colors.black54)),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                    ),
                    ListTile(
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: Icon(
                          Icons.my_location, color: Colors.black),
                      title: Text("Location",
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                      subtitle: /*Text("09 Berkley St, CE2, Vanderbijlpark, 1911", style: TextStyle(
                          fontSize: 15, color: Colors.black54))*/
                      Container(
                          child: Text(
                            '62 Pauline Smith Road, Elandspark, Johannesburg, 2197',
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontSize: 14.0),)),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));

  }
}