import 'package:mobile/Screens/Authentication/login.dart';
import 'package:mobile/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mobile/utils/styles.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _formKey = GlobalKey<FormState>();
  String mail = "";
  String _message = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  void setMessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  Future<void> _setLogEvent(n, m) async {
    await widget.analytics.logEvent(name: n, parameters: <String, dynamic>{
      "Email": m,
    });
    print("Reset Password!");
  }

  Future<void> showAlertDialog(String title, String message, rName) async {
    bool isiOS = Platform.isIOS;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isiOS) {
            return CupertinoAlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Text(message, textAlign: TextAlign.center),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, rName);
                    },
                    child: Text('OK')),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, rName);
                    },
                    child: Text('OK')),
              ],
            );
          }
        });
  }

  Future<void> sendEmail(m) async {
    try {
      auth.sendPasswordResetEmail(email: m);
      _setLogEvent("Resetting Password", m);
      showAlertDialog("Email Sent!", "Please check your inbox to $m",
          Login(analytics: analytics, observer: observer));
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
      if (e.code == "auth/user-not-found") {
        setMessage("No user exists with this email!");
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Reset Password",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                            if (value == null) {
                              return 'E-mail field cannot be empty!';
                            } else {
                              String trimmedValue = value.trim();
                              if (trimmedValue.isEmpty) {
                                return 'E-mail field cannot be empty!';
                              }
                              if (!EmailValidator.validate(trimmedValue)) {
                                return 'Please enter a valid email!';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              mail = value;
                            }
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
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
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            sendEmail(mail);
                          }
                        },
                        child: Padding(
                            padding: Dimen.regularPadding,
                            child: Text(
                              'Send Reset Email',
                              style: text,
                            )),
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
