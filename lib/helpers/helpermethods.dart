import 'dart:convert';
import 'dart:math';

import 'package:cab_rider/datamodels/address.dart';
import 'package:cab_rider/datamodels/directiondetails.dart';
import 'package:cab_rider/datamodels/history.dart';
import 'package:cab_rider/datamodels/user.dart';
import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/helpers/requesthelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cab_rider/main.dart';

class HelperMethods{

  static void getCurrentUserInfo() async{

    currentFirebaseUser = await FirebaseAuth.instance.currentUser();
    String userid = currentFirebaseUser.uid;

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child('users/$userid');
    userRef.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        currentUserInfo = User.fromSnapshot(snapshot);
        print('my name is ${currentUserInfo.fullName}');
      }

    });
  }

 static Future<String> findCordinateAddress(Position position, context) async {

   String placeAddress = '';

   var connectivityResult = await Connectivity().checkConnectivity();
   if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
     return placeAddress;
   }

   String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

   var response = await RequestHelper.getRequest(url);

   if(response != 'failed'){
     placeAddress = response['results'][0]['formatted_address'];

     Address pickupAddress = new Address();

     pickupAddress.longitude = position.longitude;
     pickupAddress.latitude = position.latitude;
     pickupAddress.placeName = placeAddress;

     Provider.of<AppData>(context, listen: false).updatePickupAddress(pickupAddress);

   }

   return placeAddress;

  }

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

   String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

   var response = await RequestHelper.getRequest(url);

   if(response == 'failed'){
     return null;
   }

   DirectionDetails directionDetails = DirectionDetails();

   directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
   directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

   directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
   directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

   directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];

   return directionDetails;
  }

  static int estimateFares (DirectionDetails details){
   // per km = $0.3,
    // per minute = $0.2,
    // base fare = $3,

    /*double baseFare = 6.50;
    double distanceFare = (details.distanceValue/1000) * 6.50;
    double timeFare = (details.durationValue / 60) * 3;

    double totalFare = baseFare + distanceFare + timeFare;*/

    //Working
    double baseFare = 11.80;
    double distanceFare = (details.distanceValue/1000) * 11.80; //meters
    //double distanceFare = (details.distanceValue/1000); //KM


    double totalFare = baseFare + distanceFare ;
    double vat = totalFare * (15/100);
    double vatIncluded = vat + totalFare;

    //Y ~ Final Price(R) //Total Fare
    //X ~ Distance in KM //Distance Fare
    //10 ~ Base Price(R) //Base Fare
    //7 ~ Price per km(R) //Price /KM

        /*if(distanceFare < 1000)
        {
          double baseFare = 13.05;
          return baseFare.truncate();
        }
        *//*else if(distanceFare > 1)
        {
        return totalFare.truncate();
        }*/
    //Y = 10 + 7 (X)
    /*int baseFare = 10;
    double distanceFare = (details.distanceValue/110);
    int pricePerKM = 7;

    double totalFare = baseFare + pricePerKM * (distanceFare);*/
    /*int bFarePfare =  baseFare + pricePerKM;
    int totalFare = bFarePfare * distanceFare;*/



    /*//In terms of USD
    double timeTraveledFare = (details.durationValue / 60) * 0.35;
    double distanceTraveledFare = (details.distanceValue / 1000) * 0.35;
    double totalFare = timeTraveledFare + distanceTraveledFare;

    //Local Currency(Rands)
    double totalLocalAmount = totalFare * 15.23;*/

    return vatIncluded.truncate();
  }

  static double generateRandomNumber(int max){

    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static sendNotification(String token, context, String ride_id) async {

    var destination = Provider.of<AppData>(context, listen: false).destinationAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination.placeName}'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id' : ride_id,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token
    };

    var response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: headerMap,
      body: jsonEncode(bodyMap)
    );

    print(response.body);

  }

  static String formatMyDate(String datestring){

    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate = '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }

  static void getHistoryInfo (context){

    //DatabaseReference historyRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/history');
    //historyRef.once().then((DataSnapshot snapshot) {
    DatabaseReference newRequestRef = FirebaseDatabase.instance.reference().child("rideRequest");
    newRequestRef.orderByChild("rider_name").once().then((DataSnapshot snapshot) {
      if(snapshot.value != null){

        Map<dynamic, dynamic> values = snapshot.value;
        int tripCount = values.length;

        // update trip count to data provider
        Provider.of<AppData>(context, listen: false).updateTripCount(tripCount);

        List<String> tripHistoryKeys = [];
        values.forEach((key, value) {tripHistoryKeys.add(key);});

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);

        getHistoryData(context);

      }
    });


  }

  static void getHistoryData(context) {
    var keys = Provider
        .of<AppData>(context, listen: false)
        .tripHistoryKeys;

    for (String key in keys) {
      {
        DatabaseReference newRequestRef = FirebaseDatabase.instance.reference()
            .child("rideRequest");
        newRequestRef.child(key).once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            DatabaseReference newRequestRef = FirebaseDatabase.instance
                .reference().child("rideRequest");
            newRequestRef.child("rider_name").once().then((DataSnapshot dSnap) {
              String name = dSnap.value.toString();
              if (name == currentUserInfo.fullName) {
                var history = History.fromSnapshot(snapshot);
                Provider.of<AppData>(context, listen: false).updateTripHistory(
                    history);

                print(history.destination);
              }
            });
          }
        });
      }
    }
  }
}