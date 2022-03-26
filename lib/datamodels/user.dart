

import 'package:firebase_database/firebase_database.dart';

class User{
  String fullName;
  String email;
  String phone;
  String id;
  String workAdd;
  String homeAdd;

  User({
    this.email,
    this.fullName,
    this.phone,
    this.id,
    this.workAdd,
    this.homeAdd,
  });

  User.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
    workAdd = snapshot.value['workadd'];
    homeAdd = snapshot.value['homeadd'];
  }

}