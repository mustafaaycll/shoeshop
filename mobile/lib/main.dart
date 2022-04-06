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

void turnBlue() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.title_text,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent));
}

void main() {
  turnBlue();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseInit());
}

class FirebaseInit extends StatefulWidget {
  const FirebaseInit({Key? key}) : super(key: key);

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
                  'No Firebase Connection\n' + '${snapshot.error.toString()}',
                  style: TextStyle(color: AppColors.background, fontSize: 30),
                ),
              ),
              backgroundColor: AppColors.title_text,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        return MaterialApp(
          home: Scaffold(
            body: Center(
              child:
                  SpinKitFadingCircle(color: AppColors.background, size: 50.0),
            ),
            backgroundColor: AppColors.title_text,
          ),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        routes: {
          '/NavBar': (context) =>
              NavBar(analytics: analytics, observer: observer),
        },
        initialRoute: '/NavBar',
      ),
    );
  }
}
