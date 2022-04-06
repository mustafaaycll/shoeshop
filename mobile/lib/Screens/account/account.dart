import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/Screens/Authentication/resetpass.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:provider/provider.dart';

import '../../utils/styles.dart';
import 'changename.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FirebaseAuth auth = FirebaseAuth.instance;

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
          body: Column(
            children: [
              Padding(
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
              ),
              Padding(
                padding: EdgeInsets.all(Dimen.regularMargin),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {},
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Orders",
                          style: TextStyle(
                              color: IfInactive(customer.method), fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.filled_button,
                      ),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimen.regularMargin),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {},
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Comments & Reviews",
                          style: TextStyle(
                              color: IfInactive(customer.method), fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.filled_button,
                      ),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimen.regularMargin),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {
                        if (customer.method != "anonymous") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeName(
                                      analytics: FirebaseAnalytics.instance,
                                      observer: FirebaseAnalyticsObserver(
                                          analytics:
                                              FirebaseAnalytics.instance))));
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Change Name",
                          style: TextStyle(
                              color: IfInactive(customer.method), fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.filled_button,
                      ),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimen.regularMargin),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {
                        if (customer.method != "anonymous") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "We will send you an email to change your password",
                                    style: TextStyle(
                                        color: AppColors.empty_button_text),
                                  ),
                                  content: Text(
                                    "Are you sure?",
                                    style: TextStyle(
                                        color: AppColors.empty_button_text),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          auth.sendPasswordResetEmail(
                                              email: customer.email);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                              color: AppColors.positive_button),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                              color: AppColors.negative_button),
                                        ))
                                  ],
                                );
                              });
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                              color: IfInactive(customer.method), fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.filled_button,
                      ),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimen.regularMargin),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {},
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Adresses",
                          style: TextStyle(
                              color: IfInactive(customer.method), fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.filled_button,
                      ),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimen.regularMargin),
                child: Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                      onPressed: () {},
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Payment Options",
                          style: TextStyle(
                              color: IfInactive(customer.method), fontSize: 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.filled_button,
                      ),
                    ))
                  ],
                ),
              ),
            ],
          ));
    } else {
      return Animations().scaffoldLoadingScreen('ACCOUNT');
    }
  }

  Color IfInactive(String type) {
    if (type == "anonymous") {
      return AppColors.deactive_icon;
    } else {
      return AppColors.filled_button_text;
    }
  }
}
