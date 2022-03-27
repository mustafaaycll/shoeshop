import 'package:flutter/material.dart';
import 'package:mobile/Screens/test.dart';
import 'package:mobile/navbar.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xfff5f3f5), // status bar color
      statusBarBrightness: Brightness.light, //status bar brigtness
      statusBarIconBrightness: Brightness
          .dark, //status barIcon Brightness //Navigation bar divider color
      systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
      statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavBar(),
      routes: {
        '/NavBar': (context) => NavBar(),
        '/TestPage': (context) => Test(),
      },
      initialRoute: '/NavBar',
    );
  }
}
