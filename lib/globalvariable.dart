
//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cab_rider/datamodels/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


String serverKey = 'key=AAAAnZ9xM6k:APA91bFKVvi14U6sHP8wYWIs0H4mdlzg-DRrANZnyWooXcUSPGbks_FfR5EwxjSoxqFFUUHyHXQQDqLPljnRvC752m8fln88EArmC7DgOn2oAKKwCVKpdIpKvUUeulMWPe9oscxh51cG';

//String mapKey = 'AIzaSyAXhk1498g3ORPHcP6Wytkouh0Mn28obVo';
String mapKey = 'AIzaSyBHd35VGQmI2reuBzO0vYx-tBTk6B0IL2c'; //Tebello API Key

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

FirebaseUser currentFirebaseUser;

//final assetsAudioPlayer = AssetsAudioPlayer();

double starCounter=0.0;
String title="";
String carRideType="";

User currentUserInfo;
