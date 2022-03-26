import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff1b264f), //change your color here
        ),
        backgroundColor: Color(0xfff5f3f5),
        elevation: 0,
        title: Text(
          'TEST',
          style: TextStyle(color: Color(0xff1b264f), fontSize: 30),
        ),
      ),
      body: Container(color: Color(0xfff5f3f5)),
    );
  }
}
