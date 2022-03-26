import 'dart:async';
import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/datamodels/prediction.dart';
import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/helpers/requesthelper.dart';
import 'package:cab_rider/widgets/BrandDivier.dart';
import 'package:cab_rider/widgets/PredictionTile.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:cab_rider/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/screens/registrationpage.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/datamodels/directiondetails.dart';
import 'package:cab_rider/datamodels/nearbydriver.dart';
import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/helpers/firehelper.dart';
import 'package:cab_rider/helpers/helpermethods.dart';
import 'package:cab_rider/rideVaribles.dart';
import 'package:cab_rider/screens/aboutpage.dart';
import 'package:cab_rider/screens/profilepage.dart';
import 'package:cab_rider/screens/searchpage.dart';
import 'package:cab_rider/styles/styles.dart';
import 'package:cab_rider/widgets/BrandDivier.dart';
import 'package:cab_rider/widgets/CollectPaymentDialog.dart';
import 'package:cab_rider/widgets/NoDriverDialog.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:provider/provider.dart';

///  this class uses this library : intro_views_flutter
///  the link to it : https://pub.dev/packages/intro_views_flutter#-installing-tab-

class IntroPage extends StatelessWidget {
  static const id = 'intropage';

  /// -----------------------------------------------
  /// making list of pages needed to pass in IntroViewsFlutter constructor.
  /// -----------------------------------------------
  final pages = [
    /// -----------------------------------------------
    /// PageViewModel dart class for storing data in it
    /// -----------------------------------------------
    PageViewModel(
        pageColor: Colors.yellow,
        // iconImageAssetPath: 'assets/air-hostess.png',
        /// -----------------------------------------------
        /// bubble Image for indicator.
        /// -----------------------------------------------
        bubble: Image.asset('images/logo.png'),

        /// -----------------------------------------------
        /// Text details.
        /// -----------------------------------------------
        body: Text(
          'E-hailing service. \nFor the youth. By the youth',
        ),

        /// -----------------------------------------------
        /// Text header .
        /// -----------------------------------------------
        title: Text(
          'Welcome to VRPHAA',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black87),
        bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black87),

        /// -----------------------------------------------
        /// Main image.
        /// -----------------------------------------------
        mainImage: Image.asset(
          'images/logo.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: Colors.blue,
      iconImageAssetPath: 'images/logo.png',
      body: Text(
        'Affordable rides. Made for the youth.',
      ),
      title: Text('Rides'),
      mainImage: Image.asset(
        'images/taxi.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black87),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black87),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      iconImageAssetPath: 'images/logo.png',
      body: Text(
        'Join us today. Guaranteed user friendly app.',
      ),
      title: Text('Sign Up Now'),
      mainImage: Image.asset(
        'images/taxi.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black87),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black87),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    /// -----------------------------------------------
    /// Build main content with MaterialApp widget.
    /// -----------------------------------------------
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vrphaa', //title of app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData
      home: Builder(
        /// -----------------------------------------------
        /// Build Into with IntroViewsFlutter widget.
        /// -----------------------------------------------
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          onTapDoneButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ), //MaterialPageRoute
            );
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
          ),
        ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }
}

/// Home Page after intro interface.
class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go to Login/Register'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Login/Register'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {

  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login() async {

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in',),
    );

    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex){

      //check error and display message
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);

    })).user;

    if(user != null){
      // verify login
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');
      userRef.once().then((DataSnapshot snapshot) {

        if(snapshot.value != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 70,),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),

                SizedBox(height: 40,),

                Text('Login to Vrphaa',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40,),

                      TaxiButton(
                        title: 'LOGIN',
                        color: Colors.amber,
                        onPressed: () async {

                          //check network availability

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showSnackBar('Please enter a valid email address');
                            return;
                          }

                          if(passwordController.text.length < 8){
                            showSnackBar('Please enter a valid password');
                            return;
                          }

                          login();

                        },
                      ),

                    ],
                  ),
                ),

                FlatButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationScreen()),
                      );
                    },
                    child: Text('Not part of the Vrphaa family? \n        Click here to Register')
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
//Register

class RegistrationScreen extends StatefulWidget {

  static const String id = 'register';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Registering you...',),
    );

    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((ex){

      //check error and display message
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);

    })).user;

    Navigator.pop(context);
    // check if user registration is successful
    if(user != null){

      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');

      //Prepare data to be saved on users table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      newUserRef.set(userMap);

      //Take the user to the mainPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 70,),
                Image(
                  alignment: Alignment.center,
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),

                SizedBox(height: 40,),

                Text('Join the Vrphaa Family',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      // Fullname
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      // Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),


                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10,),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40,),

                      TaxiButton(
                        title: 'REGISTER',
                        color: Colors.amber,
                        onPressed: () async{

                          //check network availability

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if(fullNameController.text.length < 3){
                            showSnackBar('Please provide a valid fullname');
                            return;
                          }

                          if(phoneController.text.length < 10){
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showSnackBar('Please provide a valid email address');
                            return;
                          }

                          if(passwordController.text.length < 8){
                            showSnackBar('password must be at least 8 characters');
                            return;
                          }

                          registerUser();

                        },
                      ),

                    ],
                  ),
                ),

                FlatButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text('Already a Vrphaa member?\nClick here to Login')
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}



class MainScreen extends StatefulWidget {

  static const String id = 'mainpage';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double searchSheetHeight = 275;
  double rideDetailsSheetHeight = 0; // (Platform.isAndroid) ? 235 : 260
  double requestingSheetHeight = 0; // (Platform.isAndroid) ? 195 : 220
  double tripSheetHeight = 0; // (Platform.isAndroid) ? 275 : 300

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _Markers = {};
  Set<Circle> _Circles = {};

  BitmapDescriptor nearbyIcon;

  var geoLocator = Geolocator();
  Position currentPosition;
  DirectionDetails tripDirectionDetails;

  String appState = 'NORMAL';

  bool drawerCanOpen = true;

  DatabaseReference rideRef;

  StreamSubscription<Event> rideSubscription;

  List<NearbyDriver> availableDrivers;

  bool nearbyDriversKeysLoaded = false;

  bool isRequestingLocationDetails = false;

  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    // confirm location
    await HelperMethods.findCordinateAddress(position, context);

    startGeofireListener();

  }

  void showDetailSheet () async {
    await getDirection();

    setState(() {
      searchSheetHeight = 0;
      mapBottomPadding = 240;
      rideDetailsSheetHeight = 235;
      drawerCanOpen = false;
    });
  }

  void showRequestingSheet(){
    setState(() {

      rideDetailsSheetHeight = 0;
      requestingSheetHeight = 195;
      mapBottomPadding = 200;
      drawerCanOpen = true;

    });

    createRideRequest();
  }

  showTripSheet(){

    setState(() {
      requestingSheetHeight = 0;
      tripSheetHeight = 275;
      mapBottomPadding = 280;
    });
  }

  void createMarker(){
    if(nearbyIcon == null){

      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2,2));
      BitmapDescriptor.fromAssetImage(
          imageConfiguration,
          'images/car_android.png'
      ).then((icon){
        nearbyIcon = icon;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {

    createMarker();

    return Scaffold(
        key: scaffoldKey,
        drawer: Container(
          width: 250,
          color: Colors.white,
          child: Drawer(

            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[

                Container(
                  color: Colors.white,
                  height: 160,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //Image.asset('images/user_icon.png', height: 60, width: 60,),
                        //SizedBox(width: 15,),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                currentUserInfo.fullName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Brand-Bold',
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(context, ProfilePage.id, (route) => false);
                                },
                                child: Text(
                                    'View Profile'
                                ))
                            ,
                          ],
                        )

                      ],
                    ),
                  ),
                ),
                BrandDivider(),

                SizedBox(height: 10,),



                ListTile(
                  leading: Icon(OMIcons.contactSupport),
                  title: Text('Support', style: kDrawerItemStyle,),
                ),

                ListTile(
                  leading: Icon(OMIcons.info),
                  title: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, AboutPage.id, (route) => false);
                      },
                      child: Text(
                        'About', style: kDrawerItemStyle,
                      )
                  ),
                ),

              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapBottomPadding),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: googlePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: _polylines,
              markers: _Markers,
              circles: _Circles,
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
                mapController = controller;

                setState(() {
                  mapBottomPadding = 280;
                });

                setupPositionLocator();
              },
            ),

            ///MenuButton
            Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: (){
                  if(drawerCanOpen){
                    scaffoldKey.currentState.openDrawer();
                  }
                  else{
                    resetApp();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            )
                        )
                      ]
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon((drawerCanOpen) ? Icons.menu : Icons.arrow_back, color: Colors.black87,),
                  ),
                ),
              ),
            ),

            /// SearchSheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  height: searchSheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            )
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 5,),
                        Text('Your Vrphaa awaits!', style: TextStyle(fontSize: 17),),
                        Text('Where can we take you?', style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),),

                        SizedBox(height: 20,),

                        GestureDetector(
                          onTap: () async {

                            var response = await  Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> SearchPage()
                            ));

                            if(response == 'getDirection'){
                              showDetailSheet();
                            }

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(
                                        0.7,
                                        0.7,
                                      )
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.search, color: Colors.amber,),
                                  SizedBox(width: 10,),
                                  Text('Search Destination'),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 22,),

                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(OMIcons.home, color: BrandColors.colorDimText,),
                              SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Text('Add Home'),
                                  SizedBox(height: 3,),
                                  /*Text(
                                  Provider.of<AppData>(context).pickupAddress != null
                                      ? Provider.of<AppData>(context).pickupAddress.placeName
                                      : "Your current location",
                                    style: TextStyle(fontSize: 10.0),
                                    overflow: TextOverflow.ellipsis,
                                ),*/

                                  Text(
                                    Provider.of<AppData>(context).pickupAddress != null
                                        ? Provider.of<AppData>(context).pickupAddress.placeName
                                        : "Your current location",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10.0),),


                                ],
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 10,),

                        /*BrandDivider(),

                      SizedBox(height: 16,),*/

                        /*Row(
                        children: <Widget>[
                          Icon(OMIcons.workOutline, color: BrandColors.colorDimText,),
                          SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Add Work'),
                              SizedBox(height: 3,),
                              Text('Your office address',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11, color: BrandColors.colorDimText,),
                              )
                            ],
                          )
                        ],
                      ),
*/
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// RideDetails Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          0.7, // Move to right 10  horizontally
                          0.7, // Move to bottom 10 Vertically
                        ),
                      )
                    ],

                  ),
                  height: rideDetailsSheetHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: <Widget>[

                        Container(
                          width: double.infinity,
                          color: Colors.yellowAccent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Image.asset('images/taxi.png', height: 70, width: 70,),
                                SizedBox(width: 16,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Taxi', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                    Text((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '', style: TextStyle(fontSize: 16, color: BrandColors.colorTextLight),)

                                  ],
                                ),
                                Expanded(child: Container()),
                                Text((tripDirectionDetails != null) ? '\R${HelperMethods.estimateFares(tripDirectionDetails)}' : '', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 22,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: <Widget>[

                              Icon(FontAwesomeIcons.moneyBillAlt, size: 18, color: BrandColors.colorTextLight,),
                              SizedBox(width: 16,),
                              Text('Cash'),
                              SizedBox(width: 5,),
                              //Icon(Icons.keyboard_arrow_down, color: BrandColors.colorTextLight, size: 16,),
                            ],
                          ),
                        ),

                        SizedBox(height: 22,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TaxiButton(
                            title: 'REQUEST CAB',
                            color: Colors.yellow,
                            onPressed: (){

                              setState(() {
                                appState = 'REQUESTING';
                              });
                              showRequestingSheet();

                              availableDrivers = FireHelper.nearbyDriverList;

                              findDriver();

                            },
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Request Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          0.7, // Move to right 10  horizontally
                          0.7, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  height: requestingSheetHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(height: 10,),

                        SizedBox(
                          width: double.infinity,
                          child: TextLiquidFill(
                            text: 'Requesting a Ride...',
                            waveColor: BrandColors.colorTextSemiLight,
                            boxBackgroundColor: Colors.white,
                            textStyle: TextStyle(
                                color: BrandColors.colorText,
                                fontSize: 22.0,
                                fontFamily: 'Brand-Bold'
                            ),
                            boxHeight: 40.0,
                          ),
                        ),

                        SizedBox(height: 20,),

                        GestureDetector(
                          onTap: (){
                            cancelRequest();
                            resetApp();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(width: 1.0, color: BrandColors.colorLightGrayFair),

                            ),
                            child: Icon(Icons.close, size: 25,),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Container(
                          width: double.infinity,
                          child: Text(
                            'Cancel ride',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),


            /// Trip Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          0.7, // Move to right 10  horizontally
                          0.7, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  height: tripSheetHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SizedBox(height: 5,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tripStatusDisplay,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ],
                        ),

                        SizedBox(height: 20,),

                        BrandDivider(),

                        SizedBox(height: 20,),

                        Text(driverCarDetails, style: TextStyle(color: BrandColors.colorTextLight),),

                        Text(driverFullName, style: TextStyle(fontSize: 20),),

                        SizedBox(height: 20,),

                        BrandDivider(),

                        SizedBox(height: 20,),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular((25))),
                                    border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.call),
                                ),

                                SizedBox(height: 10,),

                                Text('Call'),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular((25))),
                                    border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(Icons.list),
                                ),

                                SizedBox(height: 10,),

                                Text('Details'),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular((25))),
                                    border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                                  ),
                                  child: Icon(OMIcons.clear),
                                ),

                                SizedBox(height: 10,),

                                Text('Cancel'),
                              ],
                            ),

                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ),
            )

          ],
        )
    );
  }

  Future<void> getDirection() async {

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =  Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(status: 'Please wait...',)
    );

    var thisDetails = await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetails = thisDetails;
    });

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results = polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polylineCoordinates.clear();
    if(results.isNotEmpty){
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polylines.clear();

    setState(() {

      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);

    });

    // make polyline to fit into the map

    LatLngBounds bounds;

    if(pickLatLng.latitude > destinationLatLng.latitude && pickLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    }
    else if(pickLatLng.longitude > destinationLatLng.longitude){
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude)
      );
    }
    else if(pickLatLng.latitude > destinationLatLng.latitude){
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
        northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else{
      bounds = LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );

    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );



    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });

  }

  void startGeofireListener() {

    Geofire.initialize('driversAvailable');
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 20).listen((map) {

      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:

            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];
            FireHelper.nearbyDriverList.add(nearbyDriver);

            if(nearbyDriversKeysLoaded){
              updateDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
          // Update your key's location

            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            FireHelper.updateNearbyLocation(nearbyDriver);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:

            nearbyDriversKeysLoaded = true;
            updateDriversOnMap();
            break;
        }
      }
    });
  }

  void updateDriversOnMap(){
    setState(() {
      _Markers.clear();
    });

    Set<Marker> tempMarkers = Set<Marker>();

    for (NearbyDriver driver in FireHelper.nearbyDriverList){

      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: nearbyIcon,
        rotation: HelperMethods.generateRandomNumber(360),
      );

      tempMarkers.add(thisMarker);
    }

    setState(() {
      _Markers = tempMarkers;
    });

  }

  void createRideRequest(){

    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination = Provider.of<AppData>(context, listen: false).destinationAddress;

    Map pickupMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };

    Map destinationMap = {
      'latitude': destination.latitude.toString(),
      'longitude': destination.longitude.toString(),
    };

    Map rideMap = {
      'created_at': DateTime.now().toString(),
      'rider_name': currentUserInfo.fullName,
      'rider_phone': currentUserInfo.phone,
      'pickup_address' : pickup.placeName,
      'destination_address': destination.placeName,
      'location': pickupMap,
      'destination': destinationMap,
      'payment_method': 'card',
      'driver_id': 'waiting',
    };

    rideRef.set(rideMap);

    rideSubscription = rideRef.onValue.listen((event) async {

      //check for null snapshot
      if(event.snapshot.value == null){
        return;
      }

      //get car details
      if(event.snapshot.value['car_details'] != null){
        setState(() {
          driverCarDetails = event.snapshot.value['car_details']['vehicle_number'].toString();
        });
      }

      // get driver name
      if(event.snapshot.value['driver_name'] != null){
        setState(() {
          driverFullName = event.snapshot.value['driver_name'].toString();
        });
      }

      // get driver phone number
      if(event.snapshot.value['driver_phone'] != null){
        setState(() {
          driverPhoneNumber = event.snapshot.value['driver_phone'].toString();
        });
      }


      //get and use driver location updates
      if(event.snapshot.value['driver_location'] != null){

        double driverLat = double.parse(event.snapshot.value['driver_location']['latitude'].toString());
        double driverLng = double.parse(event.snapshot.value['driver_location']['longitude'].toString());
        LatLng driverLocation = LatLng(driverLat, driverLng);

        if(status == 'accepted'){
          updateToPickup(driverLocation);
        }
        else if(status == 'ontrip'){
          updateToDestination(driverLocation);
        }
        else if(status == 'arrived'){
          setState(() {
            tripStatusDisplay = 'Driver has arrived';
          });
        }

      }


      if(event.snapshot.value['status'] != null){
        status = event.snapshot.value['status'].toString();
      }

      if(status == 'accepted'){
        showTripSheet();
        Geofire.stopListener();
        removeGeofireMarkers();
      }

      if(status == 'ended'){

        if(event.snapshot.value['fares'] != null) {

          int fares = int.parse(event.snapshot.value['fares'].toString());

          var response = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CollectPayment(paymentMethod: 'cash', fares: fares,),
          );

          if(response == 'close'){
            rideRef.onDisconnect();
            rideRef = null;
            rideSubscription.cancel();
            rideSubscription = null;
            resetApp();
          }

        }
      }

    });

  }

  void removeGeofireMarkers(){
    setState(() {
      _Markers.removeWhere((m) => m.markerId.value.contains('driver'));
    });
  }

  void updateToPickup(LatLng driverLocation) async {

    if(!isRequestingLocationDetails){

      isRequestingLocationDetails = true;

      var positionLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);

      var thisDetails = await HelperMethods.getDirectionDetails(driverLocation, positionLatLng);

      if(thisDetails == null){
        return;
      }

      setState(() {
        tripStatusDisplay = 'Driver is Arriving - ${thisDetails.durationText}';
      });

      isRequestingLocationDetails = false;

    }


  }

  void updateToDestination(LatLng driverLocation) async {

    if(!isRequestingLocationDetails){

      isRequestingLocationDetails = true;

      var destination = Provider.of<AppData>(context, listen: false).destinationAddress;

      var destinationLatLng = LatLng(destination.latitude, destination.longitude);

      var thisDetails = await HelperMethods.getDirectionDetails(driverLocation, destinationLatLng);

      if(thisDetails == null){
        return;
      }

      setState(() {
        tripStatusDisplay = 'Driving to Destination - ${thisDetails.durationText}';
      });

      isRequestingLocationDetails = false;

    }


  }

  void cancelRequest(){
    rideRef.remove();

    setState(() {
      appState = 'NORMAL';
    });
  }

  resetApp(){

    setState(() {

      polylineCoordinates.clear();
      _polylines.clear();
      _Markers.clear();
      _Circles.clear();
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = 0;
      tripSheetHeight = 0;
      searchSheetHeight = 275;
      mapBottomPadding = 280;
      drawerCanOpen = true;

      status = '';
      driverFullName = '';
      driverPhoneNumber = '';
      driverCarDetails = '';
      tripStatusDisplay = 'Driver is Arriving';

    });

    setupPositionLocator();

  }

  void noDriverFound(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverDialog()
    );
  }

  void findDriver (){

    if(availableDrivers.length == 0){
      cancelRequest();
      resetApp();
      noDriverFound();
      return;
    }

    var driver = availableDrivers[0];

    notifyDriver(driver);

    availableDrivers.removeAt(0);

    print(driver.key);

  }

  void notifyDriver(NearbyDriver driver){

    DatabaseReference driverTripRef = FirebaseDatabase.instance.reference().child('drivers/${driver.key}/newtrip');
    driverTripRef.set(rideRef.key);

    // Get and notify driver using token
    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${driver.key}/token');

    tokenRef.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){

        String token = snapshot.value.toString();

        // send notification to selected driver
        HelperMethods.sendNotification(token, context, rideRef.key);
      }
      else{

        return;
      }

      const oneSecTick = Duration(seconds: 1);

      var timer = Timer.periodic(oneSecTick, (timer) {

        // stop timer when ride request is cancelled;
        if(appState != 'REQUESTING'){
          driverTripRef.set('cancelled');
          driverTripRef.onDisconnect();
          timer.cancel();
          driverRequestTimeout = 30;
        }


        driverRequestTimeout --;

        // a value event listener for driver accepting trip request
        driverTripRef.onValue.listen((event) {

          // confirms that driver has clicked accepted for the new trip request
          if(event.snapshot.value.toString() == 'accepted'){
            driverTripRef.onDisconnect();
            timer.cancel();
            driverRequestTimeout = 30;
          }
        });


        if(driverRequestTimeout == 0){

          //informs driver that ride has timed out
          driverTripRef.set('timeout');
          driverTripRef.onDisconnect();
          driverRequestTimeout = 30;
          timer.cancel();

          //select the next closest driver
          findDriver();
        }


      });


    });

  }

}

//Search Screen

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  var focusDestination = FocusNode();

  bool focused = false;

  void setFocus(){
    if(!focused){
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<Prediction> destinationPredictionList = [];

  void searchPlace(String placeName) async {

    if(placeName.length > 1){

      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=123254251&components=country:za';
      var response = await RequestHelper.getRequest(url);

      if(response == 'failed'){
        return;
      }

      if(response['status'] == 'OK'){
        var predictionJson = response['predictions'];
        var thisList = (predictionJson as List).map((e) => Prediction.fromJson(e)).toList();

        setState(() {
          destinationPredictionList = thisList;
        });

      }

    }

  }

  @override
  Widget build(BuildContext context) {

    setFocus();

    String address = Provider.of<AppData>(context).pickupAddress.placeName ?? '';
    pickupController.text = address;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 210,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: <Widget>[

                  SizedBox(height: 5,),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)
                      ),
                      Center(
                        child: Text('Set Destination',
                          style: TextStyle(fontSize: 20,fontFamily: 'Brand-Bold' ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18,),

                  Row(
                    children: <Widget>[
                      Image.asset('images/pickicon.png', height: 16, width: 16,),

                      SizedBox(width: 18,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickupController,
                              decoration: InputDecoration(
                                  hintText: 'Pickup location',
                                  fillColor: BrandColors.colorLightGrayFair,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    children: <Widget>[
                      Image.asset('images/desticon.png', height: 16, width: 16,),

                      SizedBox(width: 18,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (value){
                                searchPlace(value);
                              },
                              focusNode: focusDestination,
                              controller: destinationController,
                              decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  fillColor: BrandColors.colorLightGrayFair,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),

          (destinationPredictionList.length > 0) ?
          SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListView.separated(
                padding: EdgeInsets.all(0),
                itemBuilder: (context, index){
                  return PredictionTile(
                    prediction: destinationPredictionList[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) => BrandDivider(),
                itemCount: destinationPredictionList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ),
          )
              : Container(),

        ],
      ),
    );
  }
}
