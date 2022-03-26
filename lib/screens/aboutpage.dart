
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mainpage.dart';

class AboutPage extends StatelessWidget {
  static const id = 'about';

  _launchURL() async {
    const url = 'https://brain-cap-developers.business.site/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:  Column(
          children: <Widget>[

            _buildInfo1(context),
            _buildInfo2(),
            _buildInfo3()
          ],
        ),
      ),
    );
  }

  Widget _buildInfo1(BuildContext context) {
    return Container(

        //padding: EdgeInsets.all(2),
        child: Card(

          child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(5),

              child: Column(
                children: <Widget>[

                  Row(

                    children: <Widget>[
                      GestureDetector(
                          onTap:(){
                            Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
                          },
                          child: Icon(Icons.arrow_back)
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('About Brain Cab'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text("Version"),
                    subtitle: Text("1.0"),
                  ),
                  /*Divider(),
                  ListTile(
                    leading: Icon(Icons.cached),
                    title: Text("Changelog"),
                  ),*/
                  Divider(),
                  ListTile(
                      leading: Icon(Icons.note),
                      title: GestureDetector(
                          child: Text(
                              "Terms & Conditions"
                          )
                      )
                  ),

                ],
              )
          ),
        )
    );
  }

  Widget _buildInfo2() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text('Developer', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400)),

                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Brain Cap Developers"),
                    subtitle: Text("Simphiwe Radebe"),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: _launchURL,
                    child: ListTile(
                      leading: Icon(Icons.web_asset),
                      title: Text("https://brain-cap-developers.business.site"),
                    ),
                  ),

                ],
              )
          ),
        )
    );
  }

  Widget _buildInfo3() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text('Company', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400)),

                  ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text("Brain Cab"),
                    subtitle: Text("E-hailing services"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Johannesburg, Gauteng, South Africa"),
                  ),

                ],
              )
          ),
        )
    );
  }
}
