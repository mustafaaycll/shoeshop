import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/Authentication/login.dart';
import 'package:mobile/Screens/Authentication/signup.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/styles.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key, required this.analytics, required this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircleAvatar(
                backgroundColor: AppColors.circleAvatarBackground,
                child: ClipOval(
                  child: Image.network(
                    'https://logopond.com/logos/c9615b066d9baa5342ea4cc5312b4af7.png',
                    fit: BoxFit.cover,
                  ),
                ),
                radius: 100,
              ),
            ),
            Center(
              child: Padding(
                  padding: Dimen.regularPadding,
                  child: Text(
                    "Welcome",
                    style: text,
                  )),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: ShapeRules(
                          bg_color: AppColors.empty_button,
                          side_color: AppColors.empty_button_border)
                          .outlined_button_style(),
                      onPressed: () async{
                        pushNewScreen(context, screen: Signup(analytics: analytics,observer: observer));
                        //_setCurrentScreen();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Register',
                          style: text,
                        ),
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: ShapeRules(
                          bg_color: AppColors.empty_button,
                          side_color: AppColors.empty_button_border)
                          .outlined_button_style(),
                      onPressed: () async {
                        pushNewScreen(context, screen: Login(analytics: analytics,observer: observer));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Login',
                          style: text,
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),
            /*Text(
              //_message,
            )*/
          ],
        ),
      ),
    );
  }
}
