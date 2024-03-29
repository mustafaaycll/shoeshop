import 'package:flutter/services.dart';
import 'package:mobile/Screens/Authentication/signup.dart';
import 'package:mobile/navbar.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:mobile/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:mobile/Screens/Authentication/resetpass.dart';

import 'package:mobile/Services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final SharedPreferences? prefs;
  const Login({Key? key, required this.prefs}) : super(key: key);

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
                    style: ShapeRules(bg_color: AppColors.empty_button, side_color: AppColors.empty_button_border).outlined_button_style(),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.popAndPushNamed(context, rName);
                    },
                    child: Text(
                      'PROCEED',
                      style: text,
                    )),
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
                    style: ShapeRules(bg_color: AppColors.empty_button, side_color: AppColors.empty_button_border).outlined_button_style(),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.popAndPushNamed(context, rName);
                    },
                    child: Text(
                      'PROCEED',
                      style: text,
                    )),
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            systemNavigationBarColor: AppColors.title_text,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: AppColors.opposite_case_background,
          body: SafeArea(
            child: Padding(
              padding: Dimen.regularPadding,
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ShoeShop',
                              style: TextStyle(color: AppColors.opposite_case_title_text, fontSize: 30),
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
                              child: OutlinedButton(
                                style: ShapeRules(bg_color: AppColors.positive_button, side_color: AppColors.positive_button_border)
                                    .outlined_button_style(),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    AuthService().loginWithMailandPass(mail, pass);
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: AppColors.filled_button_text),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: AppColors.background,
                          )),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "OR",
                            style: TextStyle(color: AppColors.background, fontSize: 10),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(child: Divider(color: AppColors.background)),
                        ]),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                style:
                                    ShapeRules(bg_color: AppColors.empty_button, side_color: AppColors.empty_button_border).outlined_button_style(),
                                onPressed: () async {
                                  await AuthService().signInAnon();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Continue Anonymously',
                                      style: TextStyle(color: AppColors.opposite_case_filled_button_text),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't you have an account?",
                              style: TextStyle(
                                color: AppColors.opposite_case_title_text,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                style: ShapeRules(
                                        bg_color: AppColors.opposite_case_filled_button, side_color: AppColors.opposite_case_filled_button_border)
                                    .outlined_button_style(),
                                onPressed: () {
                                  pushNewScreen(context, screen: Signup());
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(color: AppColors.filled_button_text),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 100),
                        TextButton(
                            onPressed: () {
                              pushNewScreen(context, screen: ResetPass(analytics: analytics, observer: observer));
                            },
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(color: AppColors.opposite_case_body_text),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return NavBar(
        prefs: widget.prefs,
      );
    }
  }
}
