import 'package:mobile/Screens/Authentication/signup.dart';
import 'package:mobile/Screens/home.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:mobile/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:mobile/Screens/Authentication/resetpass.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class Login extends StatefulWidget {
  const Login({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  String mail = "";
  String pass = "";
  String _message = "";
  int failLogin = 0;
  bool deactivated = false;
  bool already = false;
  dynamic data;

  FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  void setMessage(String msg) {
    setState(() {
      _message = msg;
    });
  }
  Future<void> showAlertDialog(String title, String message, rName) async {
    bool isiOS = Platform.isIOS;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isiOS) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Text(message),
              ),
              actions: [
                TextButton(
                    style: ShapeRules(
                        bg_color: AppColors.empty_button,
                        side_color: AppColors.empty_button_border)
                        .outlined_button_style(),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.popAndPushNamed(context, rName);
                    },
                    child: Text(
                      'PROCEED',
                      style: text,
                    )
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Text(message),
              ),
              actions: [
                TextButton(
                    style: ShapeRules(
                        bg_color: AppColors.empty_button,
                        side_color: AppColors.empty_button_border)
                        .outlined_button_style(),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.popAndPushNamed(context, rName);

                    },
                    child: Text(
                      'PROCEED',
                      style: text,
                    )
                ),
              ],
            );
          }
        });
  }



  Future googleSignin() async{
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    //FirebaseCrashlytics.instance.crash();

    // Once signed in, return the UserCredential
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = result.user;


    if (result.toString().isNotEmpty) {
      //_setLogEvent("Logged_In_Successfully", mail, pass);

      User? currentUser = await FirebaseAuth.instance.currentUser;
      final DocumentReference document = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
      await document.get().then<dynamic>((DocumentSnapshot snapshot) async{
        setState(() {
          data = snapshot.data();
        });
      }).then((value) => {
        if (data != null){
          already = true,
          print(already),
        },
        print(already)
      }).then((value) {
        if (!already){
          FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
            "email": user.email,
            "password": "googlesignin",
            "username": user.displayName,
            "uid": user.uid,
            "offeredProducts": {},
            "cart": {},
            "notifications": {},
            "orders": {},
            "deactivated": false,
            "bookmarks": {},
            "pictureURL": "https://t4.ftcdn.net/jpg/03/46/93/61/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg",
          });
        }
      }).then((value) {
        showAlertDialog("Logged in Succesfully!", "Welcome Back!", Home(analytics:analytics,observer:observer));
      });
    }
    return user;
  }

  Future facebookLogin() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider
        .credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(
        facebookAuthCredential);
    User? user = result.user;


    if (result
        .toString()
        .isNotEmpty) {
      //_setLogEvent("Logged_In_Successfully", mail, pass);

      User? currentUser = await FirebaseAuth.instance.currentUser;
      final DocumentReference document = FirebaseFirestore.instance
          .collection('users').doc(currentUser!.uid);
      await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
        setState(() {
          data = snapshot.data();
        });
      }).then((value) =>
      {
        if (data != null){
          already = true,
          print(already),
        },
        print(already)
      }).then((value) {
        if (!already) {
          FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
            "email": user.email,
            "password": "facebooksignin",
            "username": user.displayName,
            "uid": user.uid,
            "offeredProducts": {},
            "cart": {},
            "notifications": {},
            "orders": {},
            "deactivated": false,
            "bookmarks": {},
            "pictureURL": "https://t4.ftcdn.net/jpg/03/46/93/61/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg",
          });
        }

      }).then((value) {
        showAlertDialog("Logged in Succesfully!", "Welcome Back!", Home(analytics:analytics,observer:observer));

      });
    }
    return user;
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: mail, password: pass);
      if (userCredential.toString().isNotEmpty) {

        User? currentUser = await auth.currentUser;
        if (currentUser != null) {
          await currentUser.reload();
        }
        final DocumentReference document = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
        await document.get().then<dynamic>((DocumentSnapshot snapshot) async{
          setState(() {
            data = snapshot.data();
            deactivated = data['deactivated'];
          });
        }).then((value) => {
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
            'deactivated': false,
          }).then((value) {
            if (deactivated){
              showAlertDialog("Account Reactivated!", "Welcome back!", Home(analytics:analytics,observer:observer));
            }
            else {
              showAlertDialog("Logged in Successfully!", "Welcome back!", Home(analytics:analytics,observer:observer));
            }
          })
        });

      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        setMessage("No user exists with these credentials!");
        failLogin++;
        if (failLogin == 3) {
          setMessage("You have tried to login with non-existing credentials 3 times. Redirecting you to the register page.");
          await Future.delayed(const Duration(seconds: 5), (){});
          pushNewScreen(context, screen: Signup(analytics:analytics,observer:observer));
        }
      }
      else if (e.code == "wrong-password"){
        setMessage("Wrong Password!");
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Login",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: Dimen.regularPadding,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
                            //fillColor: AppColors.textFormColor,
                            //filled: true,
                          ),
                          validator: (value) {
                            if (value == null){
                              return 'E-mail field cannot be empty!';
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty){
                                return 'E-mail field cannot be empty!';
                              }
                              if(!EmailValidator.validate(trimmedValue)) {
                                return 'Please enter a valid email!';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null){
                              mail = value;
                            }
                          }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              //fillColor: AppColors.textFormColor,
                              //filled: true,
                            ),
                            validator: (value) {
                              if (value == null){
                                return 'Password field cannot be empty!';
                              } else {
                                String trimmedValue = value.trim();
                                if (trimmedValue.isEmpty){
                                  return 'Password field cannot be empty!';
                                }
                                if(trimmedValue.length < 8) {
                                  return 'Password must be at least 8 characters!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null){
                                pass = value;
                              }
                            }
                        )
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: ShapeRules(
                            bg_color: AppColors.empty_button,
                            side_color: AppColors.empty_button_border)
                            .outlined_button_style(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()){
                            _formKey.currentState!.save();
                            loginUser();
                            //Navigator.pushNamed(context, '/addbooks');
                          }
                        },
                        child: Padding(
                            padding: Dimen.regularPadding,
                            child: Text(
                              'Login',
                              style: text,
                            )
                        ),

                      ),
                    )
                  ],
                ),

                SizedBox(height: 16,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: ShapeRules(
                            bg_color: AppColors.empty_button,
                            side_color: AppColors.empty_button_border)
                            .outlined_button_style(),
                        onPressed: () {googleSignin();},
                        child: Padding(
                            padding: Dimen.regularPadding,
                            child: Text(
                              'Login with Google',
                              style: text,
                            )
                        ),

                      ),
                    )
                  ],
                ),

                SizedBox(height: 16,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        style: ShapeRules(
                            bg_color: AppColors.empty_button,
                            side_color: AppColors.empty_button_border)
                            .outlined_button_style(),
                        onPressed: () {facebookLogin();},
                        child: Padding(
                            padding: Dimen.regularPadding,
                            child: Text(
                              'Login with Facebook',
                              style: text,
                            )
                        ),

                      ),
                    )
                  ],
                ),

                Padding(
                  padding: Dimen.largePadding,
                  child: TextButton(
                    style: ShapeRules(
                        bg_color: AppColors.empty_button,
                        side_color: AppColors.empty_button_border)
                        .outlined_button_style(),
                    onPressed: () async{
                      pushNewScreen(context, screen: ResetPass(analytics: analytics,observer: observer));
                    },
                    child: Text (
                      "Forgot my password",
                      style: text,
                    ),
                  ),
                ),

                Padding(
                  padding: Dimen.largePadding,
                  child: Text(
                    _message,
                    style: TextStyle(
                      color: AppColors.negative_button_border,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}