import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff5f3f5),
        elevation: 0,
        title: Text(
          'ACCOUNT',
          style: TextStyle(color: Color(0xff1b264f), fontSize: 30),
        ),
      ),
      body: Container(color: Color(0xfff5f3f5)),
    );
  }
}
