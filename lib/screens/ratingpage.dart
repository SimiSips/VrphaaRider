import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/globalvariable.dart';
import 'package:cab_rider/widgets/BrandDivier.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingPage extends StatefulWidget {

  final String driverId;

  RatingPage({this.driverId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(4.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              SizedBox(height: 20,),

              Text(
                  "Rate this driver",
                style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold", color: Colors.black54),
              ),

              SizedBox(height: 20,),

              BrandDivider(),

              SizedBox(height: 16.0,),
              
              SmoothStarRating(
                rating: starCounter,
                color: Colors.yellow,
                allowHalfRating: false,
                starCount: 5,
                size: 45.0,
                onRated: (value) 
                {
                  starCounter = value;
                  
                  if(starCounter == 1)
                    {
                      setState(() {
                        title = "Very Bad";
                      });
                    }
                  if(starCounter == 2)
                  {
                    setState(() {
                      title = "Bad";
                    });
                  }
                  if(starCounter == 3)
                  {
                    setState(() {
                      title = "Good";
                    });
                  }
                  if(starCounter == 4)
                  {
                    setState(() {
                      title = "Very Good";
                    });
                  }
                  if(starCounter == 5)
                  {
                    setState(() {
                      title = "Excellent";
                    });
                  }
                },
              ),

              SizedBox(height: 14.0,),
              
              Text(title, style: TextStyle(fontSize: 45.0, fontFamily: "Brand-Bold", color: Colors.yellow),),
              
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () async
                  {
                    DatabaseReference driverRatingRef = FirebaseDatabase.instance.reference()
                        .child("drivers")
                        .child(widget.driverId)
                        .child("ratings");

                    driverRatingRef.once().then((DataSnapshot snap) {
                      if(snap.value != null)
                        {
                          double oldRating = double.parse(snap.value.toString());
                          double addRatings = oldRating + starCounter;
                          double averageRatings = addRatings/2;
                          driverRatingRef.set(averageRatings.toString());
                        }
                      else
                        {
                          driverRatingRef.set(starCounter.toString());
                        }
                    });

                    Navigator.pop(context, "close");
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Submit", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}
