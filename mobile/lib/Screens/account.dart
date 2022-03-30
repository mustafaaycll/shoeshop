import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/utils/colors.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              AuthService().signOut();
            },
            icon: Icon(
              CupertinoIcons.square_arrow_left,
              color: AppColors.negative_button,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
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
