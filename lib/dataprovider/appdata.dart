//import 'dart:html';

import 'package:cab_rider/datamodels/address.dart';
import 'package:cab_rider/datamodels/user.dart';
import 'package:cab_rider/datamodels/history.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{

  Address pickupAddress;

  Address destinationAddress;

  User workAddress;

  User homeAddress;

  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];

  void updateWorkAddress(User work){
    workAddress = work;
    notifyListeners();
  }

  void updateHomeAddress(User homeAdd){
    homeAddress = homeAdd;
    notifyListeners();
  }

  void updatePickupAddress(Address pickup){
    pickupAddress = pickup;
    notifyListeners();
  }

  void updateDestinationAddress (Address destination){
    destinationAddress = destination;
    notifyListeners();
  }

  void updateEarnings(String newEarnings){
    earnings = newEarnings;
    notifyListeners();
  }

  void updateTripCount(int newTripCount){
    countTrips = newTripCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys){
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistory(History historyItem){
    tripHistoryDataList.add(historyItem);
    notifyListeners();
  }

}