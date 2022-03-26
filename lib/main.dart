import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/page/home_page.dart';
import 'package:cab_rider/screens/aboutpage.dart';
import 'package:cab_rider/screens/historypage.dart';
import 'package:cab_rider/screens/home.dart';
import 'package:cab_rider/screens/intropage.dart';
import 'package:cab_rider/screens/login.dart';
import 'package:cab_rider/screens/loginpage.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/screens/otp.dart';
import 'package:cab_rider/screens/personpage.dart';
import 'package:cab_rider/screens/phonepage.dart';
import 'package:cab_rider/screens/profilepage.dart';
import 'package:cab_rider/screens/registrationpage.dart';
import 'package:cab_rider/screens/splashintro.dart';
import 'package:cab_rider/screens/support.dart';
import 'package:cab_rider/widget/sign_up_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:169450788828:ios:94b60468db3510b6f9a119',
      gcmSenderID: '169450788828',
      databaseURL: 'https://geetaxi-9c60a.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:676984861609:android:d66fb773dd254e8a030ab8',
      apiKey: 'AIzaSyAXhk1498g3ORPHcP6Wytkouh0Mn28obVo',
      databaseURL: 'https://vrphaaa-rider-default-rtdb.firebaseio.com',
    ),
  );

  currentFirebaseUser = await FirebaseAuth.instance.currentUser();


  runApp(MyApp());

}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        //initialRoute: (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
        initialRoute: (currentFirebaseUser == null) ? IntroOverboardPage.id : MainPage.id,
        //initialRoute: LoginPhone.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
          ProfilePage.id: (context) => ProfilePage(),
          AboutPage.id: (context) => AboutPage(),
          PersonPage.id: (context) => PersonPage(),
          IntroPage.id: (context) => IntroPage(),
          IntroOverboardPage.id: (context) => IntroOverboardPage(),
          SupportPage.id: (context) => SupportPage(),
          HomePage.id: (context) => HomePage(),
          SignUpWidget.id: (context) => SignUpWidget(),
          PhoneScreen.id: (context) => PhoneScreen(),
          LoginPhone.id: (context) => LoginPhone(),
          //OTPScreen.id: (context) => OTPScreen();
          HistoryPage.id: (context) => HistoryPage(),
        },
      ),
    );
  }
}

