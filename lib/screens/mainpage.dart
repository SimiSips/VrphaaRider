
import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/datamodels/directiondetails.dart';
import 'package:cab_rider/datamodels/nearbydriver.dart';
import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/helpers/firehelper.dart';
import 'package:cab_rider/helpers/helpermethods.dart';
import 'package:cab_rider/rideVaribles.dart';
import 'package:cab_rider/screens/aboutpage.dart';
import 'package:cab_rider/screens/personpage.dart';
import 'package:cab_rider/screens/profilepage.dart';
import 'package:cab_rider/screens/ratingpage.dart';
import 'package:cab_rider/screens/searchpage.dart';
import 'package:cab_rider/screens/support.dart';
import 'package:cab_rider/styles/styles.dart';
import 'package:cab_rider/widgets/BrandDivier.dart';
import 'package:cab_rider/widgets/CollectPaymentDialog.dart';
import 'package:cab_rider/widgets/NoDriverDialog.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'historypage.dart';


class MainPage extends StatefulWidget {

  static const String id = 'mainpage';

 /* final String driverId;


  MainPage({this.driverId});*/

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double searchSheetHeight = 275;
  double rideDetailsSheetHeight = 0; // (Platform.isAndroid) ? 235 : 260
  double requestingSheetHeight = 0; // (Platform.isAndroid) ? 195 : 220
  double tripSheetHeight = 0; // (Platform.isAndroid) ? 275 : 300

  //DatabaseReference driverTripRef = FirebaseDatabase.instance.reference().child('drivers/${driver.key}/newtrip');




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

  //DatabaseReference driverRatingRef;


  StreamSubscription<Event> rideSubscription;

  List<NearbyDriver> availableDrivers;

  bool nearbyDriversKeysLoaded = false;

  bool isRequestingLocationDetails = false;

  String uName="";

  //DatabaseReference driverRatingRef = FirebaseDatabase.instance.reference().child("drivers").child('driver_id').child("ratings");


  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }


  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    // confirm location
    await HelperMethods.findCordinateAddress(position, context);

    startGeofireListener();

    uName = currentUserInfo.fullName;

    HelperMethods.getHistoryInfo(context);

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
      requestingSheetHeight = 340.0;
      mapBottomPadding = 360;
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
    /*razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess)*/

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
                height: 220,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/user_icon.png', height: 60, width: 60,),
                      SizedBox(width: 15,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          SizedBox(height: 20,),
                          Text("Welcome " + "\n"+ uName,
                            style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Brand-Bold',
                          ),),
                          SizedBox(height: 10.0,),

                          //SizedBox(height: 10,),
                        ],
                      ),

                    ],

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10)
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, ProfilePage.id, (route) => false);
                  },
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text(
                        "View Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Brand-Bold',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              BrandDivider(),

              SizedBox(height: 10,),



              ListTile(
                leading: Icon(OMIcons.contactSupport),
                title: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, PersonPage.id, (route) => false);
                  },
                    child: Text('Support', style: kDrawerItemStyle,)),
              ),

              ListTile(
                leading: Icon(OMIcons.history),
                title: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, HistoryPage.id, (route) => false);
                  },
                    child: Text(
                      'History', style: kDrawerItemStyle,
                    ),
                ),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 5,),
                        //Text('Your Vrphaa awaits!', style: TextStyle(fontSize: 17),),
                        //Text('Where would you like to go today?', style: TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),),

                        //SizedBox(height: 20,),

                        GestureDetector(
                          onTap: () async {

                           var response = await  Navigator.push(context, MaterialPageRoute(
                              builder: (context)=> SearchPage()
                            ));

                           if(response == 'getDirection'){
                             showDetailSheet();
                           } else {
                             print("No location");
                           }

                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  spreadRadius: 0.9,
                                  offset: Offset(
                                    0.9,
                                    0.9,
                                  )
                                )
                              ]
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  //Icon(Icons.search, color: Colors.blue,),
                                  Image(
                                    image: AssetImage("images/where.png")
                                  ),
                                  SizedBox(width: 9,),
                                  Text('Where to?', style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 15),),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 22,),

                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(OMIcons.myLocation, color: Colors.blue,),
                              SizedBox(width: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Current Location'),
                                  SizedBox(height: 3,),
                                  Text(
                                    Provider.of<AppData>(context).pickupAddress != null
                                        ? Provider.of<AppData>(context).pickupAddress.placeName
                                        : "Your current location",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 10.0),
                                  ),

                                  SizedBox(
                                    width: 260.0,
                                    child: Container(
                                      /*child: Text('Current Location'
                                        Provider.of<AppData>(context).pickupAddress != null
                                            ? Provider.of<AppData>(context).pickupAddress.placeName
                                            : "Your current location",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10.0),*/
                                      ),
                                    ),
                                  //.),


                                ],
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        BrandDivider(),

                        SizedBox(height: 16,),

                        Row(
                          children: <Widget>[
                            Icon(OMIcons.workOutline, color: Colors.blue,),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Work Address'),
                                SizedBox(height: 3,),
                                /*Text('Your office address',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11, color: BrandColors.colorDimText,),
                                )*/
                                /*Text(
                                  Provider.of<AppData>(context).workAddress != null
                                      ? Provider.of<AppData>(context).workAddress.workAdd
                                      : "Your work address",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10.0),),*/
                                Text(
                                  "Work Address",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10.0),)
                              ],
                            )
                          ],
                        ),

                        BrandDivider(),

                        SizedBox(height: 16,),

                        Row(
                          children: <Widget>[
                            Icon(OMIcons.home, color: Colors.blue,),
                            SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Home Address'),
                                SizedBox(height: 3,),
                                /*Text('Your office address',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11, color: BrandColors.colorDimText,),
                                )*/
                                /*Text(
                                  Provider.of<AppData>(context).workAddress != null
                                      ? Provider.of<AppData>(context).workAddress.workAdd
                                      : "Your work address",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10.0),),*/
                                Text(
                                  "Home Address",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10.0),)
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
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
                  //color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20.0, // soften the shadow
                      spreadRadius: 0.7, //extend the shadow
                      offset: Offset(
                        0.7, // Move to right 10  horizontally
                        0.7, // Move to bottom 10 Vertically
                      ),
                    )
                  ],

                ),
                height: rideDetailsSheetHeight,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: <Widget>[

                        //Vrphaa Standard
                            GestureDetector(
                              onTap: ()
                              {
                                showSnackBar('Searching Standard Brain Cab...');
                                setState(() {
                                  appState = 'REQUESTING';
                                  carRideType = "vrphaa-standard";
                                });
                                showRequestingSheet();

                                availableDrivers = FireHelper.nearbyDriverList;

                                findDriver();
                              },
                              child: SizedBox(
                                width: 320,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                  width: double.infinity,
                                 // color: Colors.yellowAccent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset('images/VrphaaStandard.png', height: 70, width: 70,),
                                        SizedBox(width: 16,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Standard', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.person, size: 20,),
                                                      Text('4', style: TextStyle(fontSize: 15, fontFamily: 'Brand-Regular'),),
                                                    ],
                                                  ),
                                                ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Text((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '', style: TextStyle(fontSize: 16, color: Colors.white),),
                                            )

                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        Text(
                                          (tripDirectionDetails != null) ? '\R${(HelperMethods.estimateFares(tripDirectionDetails))/2}' : '', //Dividing fare by 2 for first category
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Brand-Bold'
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                        SizedBox(height: 10.0,),
                        Divider(height: 2.0, thickness: 2.0,),
                        SizedBox(height: 10.0,),

                        //VrphaaStyle
                        GestureDetector(
                          onTap: ()
                          {
                            showSnackBar('Searching Vrphaa Style...');
                            setState(() {
                              appState = 'REQUESTING';
                              carRideType = "vrphaa-syle";
                            });
                            showRequestingSheet();

                            availableDrivers = FireHelper.nearbyDriverList;

                            findDriver();
                          },
                          child: SizedBox(
                            width: 320,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(Radius.circular(25)),
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
                              width: double.infinity,
                              // color: Colors.yellowAccent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset('images/VrphaaStyle.png', height: 70, width: 70,),
                                    SizedBox(width: 16,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Premium', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.person, size: 20,),
                                                Text('4', style: TextStyle(fontSize: 15, fontFamily: 'Brand-Regular'),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '', style: TextStyle(fontSize: 16, color: BrandColors.colorTextLight),)

                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      (tripDirectionDetails != null) ? '\R${(HelperMethods.estimateFares(tripDirectionDetails))/2 + 11.5}' : '', //Dividing fare by 2 for first category
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Brand-Bold'
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0,),
                        Divider(height: 2.0, thickness: 2.0,),
                        SizedBox(height: 10.0,),

                        //VrphaaBusiness
                        GestureDetector(
                          onTap: ()
                          {
                            showSnackBar('Searching VrphaaBusiness...');

                            setState(() {
                              appState = 'REQUESTING';
                              carRideType = "vrphaa-business";
                            });
                            showRequestingSheet();

                            availableDrivers = FireHelper.nearbyDriverList;

                            findDriver();
                          },
                          child: SizedBox(
                            width: 320,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(Radius.circular(25)),
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
                              width: double.infinity,
                             // color: Colors.yellowAccent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset('images/VrphaaBusiness.png', height: 70, width: 70,),
                                    SizedBox(width: 16,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Business', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.person, size: 20,),
                                                Text('4', style: TextStyle(fontSize: 15, fontFamily: 'Brand-Regular'),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '', style: TextStyle(fontSize: 16, color: BrandColors.colorTextLight),)

                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Text((tripDirectionDetails != null) ? '\R${(HelperMethods.estimateFares(tripDirectionDetails))}' : '', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),), //Normal fare

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0,),
                        Divider(height: 2.0, thickness: 2.0,),
                        SizedBox(height: 10.0,),

                        //VrphaaFamily
                        GestureDetector(
                          onTap: ()
                          {
                            showSnackBar('Searching VrphaaFamily...');

                            setState(() {
                              appState = 'REQUESTING';
                              carRideType = "vrphaa-family";
                            });
                            showRequestingSheet();

                            availableDrivers = FireHelper.nearbyDriverList;

                            findDriver();
                          },
                          child: SizedBox(
                            width: 320,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(Radius.circular(25)),
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
                              width: double.infinity,
                            //  color: Colors.yellowAccent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset('images/VrphaaFamily.png', height: 70, width: 70,),
                                    SizedBox(width: 16,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Van', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 2.0),
                                            child: Row(
                                              children: [
                                                Icon(Icons.person, size: 20,),
                                                Text('7', style: TextStyle(fontSize: 15, fontFamily: 'Brand-Regular'),),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                                          child: Text((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '', style: TextStyle(fontSize: 16, color: Colors.white),),
                                        )

                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Text((tripDirectionDetails != null) ? '\R${(HelperMethods.estimateFares(tripDirectionDetails))*2}' : '', style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),), //Multiplied by 2 for party bus

                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0,),
                        Divider(height: 2.0, thickness: 2.0,),
                        SizedBox(height: 10.0,),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 130),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(Radius.circular(25)),
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
                              /*child: Row(
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Icon(FontAwesomeIcons.moneyBillAlt, size: 18, color: BrandColors.colorTextLight,),
                                  ),
                                  SizedBox(width: 16,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text('Cash'),
                                  ),
                                  SizedBox(width: 5,),
                                  SizedBox(height: 30.0,),
                                  //Icon(Icons.keyboard_arrow_down, color: BrandColors.colorTextLight, size: 16,),
                                ],
                              ),*/ ///Payment method icon

                          ),

                        ),
                      ],
                    ),
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

                      Container(
                          child: Column(
                            children: [
                              Text(driverFullName, style: TextStyle(fontSize: 20),),
                              //Text(driverRatingRef.toString()),  //Ratings for driver
                        ],
                      )),

                      SizedBox(height: 20,),

                      BrandDivider(),

                      SizedBox(height: 20,),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          /*Column(
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
                          ),*/ //(CAll - DETAILS - CANCEL)

                          //Call Button
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: RaisedButton(
                              onPressed: () async
                              {
                                launch(('tel://${driverPhoneNumber}'));
                              },
                              color: Colors.blue,
                              child: Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Call driver", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
                                    Icon(Icons.call, color: Colors.black, size: 26.0,),
                                  ],
                                ),
                              ),
                            ),
                          )

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
      'ride_type': carRideType,
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
          driverCarDetails = event.snapshot.value['car_details'].toString();
        });
      }

      //get car number plate
      if(event.snapshot.value['car_number'] != null){
        setState(() {
          driverCarNumber = event.snapshot.value['car_number'].toString();
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

          String driverId="";
          if(response == 'close')
          {
            if(event.snapshot.value["driver_id"] != null)
              {
                driverId = event.snapshot.value["driver_id"].toString();
              }
            
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RatingPage(driverId: driverId)));
            
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
      searchSheetHeight = 270;
      mapBottomPadding = 280;
      drawerCanOpen = true;

      status = '';
      driverFullName = '';
      driverPhoneNumber = '';
      driverCarDetails = '';
      driverCarNumber = '';
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

  /*void findDriver (){

    if(availableDrivers.length == 0){
      cancelRequest();
      resetApp();
      noDriverFound();
      return;
    }

    var driver = availableDrivers[0];

    DatabaseReference driversRef = FirebaseDatabase.instance.reference().child('drivers/${driver.key}');

    driversRef.child(driver.key).child("vehicle_details").child("type").once().then((DataSnapshot snap) async {
      if (await snap.value != null) {
        String carType = driversRef.child(driver.key)
            .child("vehicle_details")
            .child("type")
            .child('') as String;
        if (carType == carRideType) {
          notifyDriver(driver);
          availableDrivers.removeAt(0);
        }
        else {
          showSnackBar("Specific ride not available. Try again");
          notifyDriver(driver);
          availableDrivers.removeAt(0);
        }
      }

      *//*String carType = driversRef.child(driver.key).child("vehicle_details").child("type").child('') as String;
    if(carType == carRideType)
    {
      notifyDriver(driver);
      availableDrivers.removeAt(0);
    }
    else
    {
      showSnackBar("Specific ride not available. Try again");
      *//* *//*notifyDriver(driver);
      availableDrivers.removeAt(0);*//* *//*
    };
      *//* *//*else
        {
          {
            showSnackBar("No car found. Try again");
          }
        }*//*
      notifyDriver(driver);
      availableDrivers.removeAt(0);

      print(driver.key);
    }



      void notifyDriver(NearbyDriver driver) {
        DatabaseReference driverTripRef = FirebaseDatabase.instance.reference()
            .child('drivers/${driver.key}/newtrip');
        driverTripRef.set(rideRef.key);

        // Get and notify driver using token
        DatabaseReference tokenRef = FirebaseDatabase.instance.reference()
            .child('drivers/${driver.key}/token');

        tokenRef.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            String token = snapshot.value.toString();

            // send notification to selected driver
            HelperMethods.sendNotification(token, context, rideRef.key);
          }
          else {
            return;
          }

          const oneSecTick = Duration(seconds: 1);

          var timer = Timer.periodic(oneSecTick, (timer) {
            // stop timer when ride request is cancelled;
            if (appState != 'REQUESTING') {
              driverTripRef.set('cancelled');
              driverTripRef.onDisconnect();
              timer.cancel();
              driverRequestTimeout = 30;
            }


            driverRequestTimeout --;

            // a value event listener for driver accepting trip request
            driverTripRef.onValue.listen((event) {
              // confirms that driver has clicked accepted for the new trip request
              if (event.snapshot.value.toString() == 'accepted') {
                driverTripRef.onDisconnect();
                timer.cancel();
                driverRequestTimeout = 30;
              }
            });


            if (driverRequestTimeout == 0) {
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
        }*/


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