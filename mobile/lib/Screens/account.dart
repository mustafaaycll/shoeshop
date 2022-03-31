import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Color(0xfff5f3f5),
            elevation: 0,
            title: Text(
              'ACCOUNT',
              style: TextStyle(color: Color(0xff1b264f), fontSize: 30),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(customer.fullname),
                    subtitle: Text(
                      customer.email,
                      style: TextStyle(fontSize: 11),
                    ),
                    leading: QuickObjects()
                        .profilePicture(customer.fullname, 100, 100),
                    trailing: IconButton(
                      onPressed: () {
                        AuthService().signOut();
                      },
                      icon: Icon(
                        CupertinoIcons.square_arrow_left,
                        color: AppColors.negative_button,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ));
    } else {
      return Animations().scaffoldLoadingScreen('ACCOUNT');
    }
  }
}
