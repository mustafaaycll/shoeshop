import 'package:flutter/material.dart';
import 'package:mobile/Screens/home.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mobile/utils/styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';


class Signup extends StatefulWidget {
  const Signup({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _formKey = GlobalKey<FormState>();
  String mail = "";
  String username = "";
  String pass = "";
  String _message = "";

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
          if(isiOS) {
            return CupertinoAlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Text(message, textAlign: TextAlign.center),
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
              title: Text(title, textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Text(message, textAlign: TextAlign.center),
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


  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: mail, password: pass);
      if (userCredential.toString().isNotEmpty){
        User? user = auth.currentUser;
        assert(user != null);
        FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          "email": mail,
          "password": pass,
          "username": username,
          "uid": user.uid,
          "offeredProducts": {},
          "cart": {},
          "notifications": [],
          "orders": {},
          "deactivated": false,
          "bookmarks": {},
          "pictureURL": "https://t4.ftcdn.net/jpg/03/46/93/61/360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg",
        });
        showAlertDialog("Registered Successfully!", "Welcome $username", Home(analytics:analytics,observer:observer));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        setMessage("This email is already in use!");
      }

      else if (e.code == "weak-password") {
        setMessage("Weak Password!");
      }
    }
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
        title: Text("Register",
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
                const SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'Username',
                            //fillColor: AppColors.textFormColor,
                            //filled: true,
                          ),
                          validator: (value) {
                            if (value == null){
                              return 'Username field cannot be empty!';
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty){
                                return 'Username field cannot be empty!';
                              }
                              if(trimmedValue.length < 4) {
                                return 'Username must be at least 4 characters!';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null){
                              username = value;
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
                              pass = value;
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
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'Confirm Password',
                            //fillColor: AppColors.textFormColor,
                            //filled: true,
                          ),
                          validator: (value) {
                            if (value == null){
                              return 'Confirm Password field cannot be empty!';
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty){
                                return 'Confirm Password field cannot be empty!';
                              }
                              if(trimmedValue != pass) {
                                return 'Passwords do not match';
                              }
                            }
                            return null;
                          },
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 16,),
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
                            registerUser();
                          }
                        },
                        child: Padding(
                            padding: Dimen.regularPadding,
                            child: Text(
                              'Register',
                              style: text,
                            )
                        ),

                      ),
                    )
                  ],
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
