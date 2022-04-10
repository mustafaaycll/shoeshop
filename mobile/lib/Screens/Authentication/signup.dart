import 'package:flutter/material.dart';
import 'package:mobile/Screens/home/home.dart';
import 'package:mobile/Services/authentication.dart';
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
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String mail = "";
  String fullname = "";
  String pass = "";
  String _message = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  void setMessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      backgroundColor: AppColors.opposite_case_background,
      body: SafeArea(
        child: Padding(
          padding: Dimen.regularPadding,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Let's sign you up!",
                          style: TextStyle(
                              color: AppColors.opposite_case_title_text,
                              fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                              "Please fill the form below and start shopping.",
                              style: TextStyle(
                                  color: AppColors.opposite_case_title_text)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                icon: Icon(
                                  CupertinoIcons.mail,
                                  color: AppColors.background,
                                ),
                                hintText: 'E-mail',
                                fillColor: AppColors.background,
                                filled: true,
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
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                icon: Icon(
                                  CupertinoIcons.person,
                                  color: AppColors.background,
                                ),
                                hintText: 'Full Name',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Username field cannot be empty!';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Username field cannot be empty!';
                                  }
                                  if (trimmedValue.length < 4) {
                                    return 'Username must be at least 4 characters!';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  fullname = value;
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
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.key,
                                    color: AppColors.background,
                                  ),
                                  hintText: 'Password',
                                  fillColor: AppColors.background,
                                  filled: true,
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Password field cannot be empty!';
                                  } else {
                                    String trimmedValue = value.trim();
                                    if (trimmedValue.isEmpty) {
                                      return 'Password field cannot be empty!';
                                    }
                                    if (trimmedValue.length < 8) {
                                      return 'Password must be at least 8 characters!';
                                    }
                                  }
                                  pass = value;
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null) {
                                    pass = value;
                                  }
                                })),
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
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.key,
                                  color: AppColors.background,
                                ),
                                hintText: 'Confirm Password',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Confirm Password field cannot be empty!';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Confirm Password field cannot be empty!';
                                  }
                                  if (trimmedValue != pass) {
                                    return 'Passwords do not match';
                                  }
                                }
                                return null;
                              },
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style: ShapeRules(
                                    bg_color:
                                        AppColors.opposite_case_filled_button,
                                    side_color: AppColors
                                        .opposite_case_filled_button_border)
                                .outlined_button_style(),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await AuthService()
                                    .signUp(fullname, mail, pass);
                                if (user != null) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Padding(
                                padding: Dimen.regularPadding,
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: AppColors.filled_button_text),
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
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                              color: AppColors.opposite_case_body_text,
                            ),
                            Text(
                              "Turn back to login screen",
                              style: TextStyle(
                                  color: AppColors.opposite_case_body_text),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
