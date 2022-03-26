//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

import 'loginpage.dart';

/// this class uses this library flutter_overboard
/// the link to it is https://pub.dev/packages/flutter_overboard#-installing-tab-

class IntroOverboardPage extends StatefulWidget {
  static const id = 'introoverboard';


  @override
  _IntroOverboardPageState createState() => _IntroOverboardPageState();
}

class _IntroOverboardPageState extends State<IntroOverboardPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// -----------------------------------------------
    /// Build main content with Scaffold widget.
    /// -----------------------------------------------
    return Scaffold(
      key: _globalKey,

      /// -----------------------------------------------
      /// Build Into with OverBoard widget.
      /// -----------------------------------------------
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          _globalKey.currentState.showSnackBar(SnackBar(
            content: Text("Skip clicked"),
          ));
        },
        finishCallback: () {
          /*_globalKey.currentState.showSnackBar(SnackBar(
            content: Text("Finish clicked"),
          ));*/

          Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
        },
      ),
    );
  }

  /// -----------------------------------------------
  /// making list of PageModel needed to pass in OverBoard constructor.
  /// -----------------------------------------------
  final pages = [
    PageModel(
        color: const Color(0xFF0097A7),
        imageAssetPath: 'images/logo.png',
        title: 'Vrphaa(Pty)Ltd',
        body: 'Welcome!',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFF536DFE),
        imageAssetPath: 'images/taxi.png',
        title: 'Affordable rides',
        body: 'Made for the youth, by the youth.',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFF9B90BC),
        imageAssetPath: 'images/easy.png',
        title: 'Easy to use',
        body: 'App made user friendly and easy to use',
        doAnimateImage: true),
    PageModel.withChild(
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Image.asset('images/logo.png', width: 300.0, height: 300.0),
        ),
        color: const Color(0xFF5886d6),
        doAnimateChild: false)
  ];
}