import 'package:flutter/material.dart';
import 'package:mobile/Screens/test.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f3f5),
      appBar: AppBar(
        backgroundColor: Color(0xfff5f3f5),
        elevation: 0,
        title: Text(
          'HOME',
          style: TextStyle(color: Color(0xff1b264f), fontSize: 30),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    backgroundColor: Color(0xfff5f3f5),
                    side: BorderSide(color: Color(0xff576ca8))),
                onPressed: () async {
                  pushNewScreen(context, screen: Test());
                },
                child: Text(
                  "Test Push/Pop",
                  style: TextStyle(color: Color(0xff1b264f)),
                )),
          ],
        ),
      ),
    );
  }
}
