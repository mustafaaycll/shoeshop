// ignore_for_file: prefer_const_constructors

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/navbar.dart';
import 'package:flutter/services.dart';
import 'package:mobile/utils/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void turnBlue() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.title_text,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent));
}

SharedPreferences? prefs;
void main() async {
  turnBlue();
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(FirebaseInit(prefs: prefs));
}

class FirebaseInit extends StatefulWidget {
  final SharedPreferences? prefs;
  const FirebaseInit({Key? key, required this.prefs}) : super(key: key);

  @override
  State<FirebaseInit> createState() => _FirebaseInitState();
}

class _FirebaseInitState extends State<FirebaseInit> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'No Firebase Connection\n' + snapshot.error.toString(),
                  style: TextStyle(color: AppColors.background, fontSize: 30),
                ),
              ),
              backgroundColor: AppColors.title_text,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp(prefs: widget.prefs);
        }

        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: SpinKitFadingCircle(color: AppColors.background, size: 50.0),
            ),
            backgroundColor: AppColors.title_text,
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences? prefs;
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/NavBar': (context) => NavBar(
                prefs: prefs,
              ),
        },
        initialRoute: '/NavBar',
      ),
    );
  }
}
