import 'package:cab_rider/auth.dart';
import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/provider/google_sign_in.dart';
import 'package:cab_rider/screens/login.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/screens/registrationpage.dart';
import 'package:cab_rider/widget/google_signup_button_widget.dart';
import 'package:cab_rider/widgets/ProgressDialog.dart';
import 'package:cab_rider/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {

  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

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
          Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
        }
      });


    }
  }

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }
  void click() {
    signInWithGoogle().then((user) => {
      this.user = user,
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => MainPage()))
    });

  }

  Widget googleLoginButton() {
    return OutlineButton(
        onPressed: this.click,
      /*onPressed: (){
        Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
      },*/
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45)
      ),
        splashColor: Colors.yellowAccent,
      borderSide: BorderSide(
        color: Colors.grey
    ),
    child: Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(FontAwesomeIcons.google, size: 30,),
      Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text('Sign In With Google', style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Brand-Bold'),),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext widget) {
    return Provider<GoogleSignInProvider>(
      create: (widget) => GoogleSignInProvider(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Image(
                      alignment: Alignment.center,
                      height: 180.0,
                      width: 180.0,
                      image: AssetImage('images/logo.png'),
                    ),

                    SizedBox(height: 20,),

                    Text('Login',
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
                            color: Colors.blue,
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

                    SizedBox(height: 10.0,),
                    //GoogleSignupButtonWidget(),
                    //googleLoginButton(),
                    FlatButton(
                        onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                        },
                        child: Text(' Not registered? \nClick here to Register', style: TextStyle(fontFamily: 'Brand-Bold'),)
                    ),

                    SizedBox(height: 10.0,),
                    Text('2021 \u00a9 Brain Cap Developers', style: TextStyle(color: Colors.black, fontSize: 12),)


                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

