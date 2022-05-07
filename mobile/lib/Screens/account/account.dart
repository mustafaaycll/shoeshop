import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/account/addressoptions.dart';
import 'package:mobile/Screens/account/paymentoptions.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
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
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(customer.fullname),
                      subtitle: Text(
                        customer.email,
                        style: TextStyle(fontSize: 11),
                      ),
                      leading: QuickObjects().profilePicture(customer.fullname, 100, 100),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Account Information",
                    style: TextStyle(color: AppColors.system_gray),
                  ),
                  ListTile(
                    onTap: () {
                      if (customer.method != "anonymous") {
                        pushNewScreen(context, screen: ChangeName());
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuickObjects().prevention(context);
                            });
                      }
                    },
                    title: Text("Change Name"),
                    trailing: Icon(CupertinoIcons.chevron_right),
                    leading: Icon(CupertinoIcons.person),
                  ),
                  ListTile(
                    onTap: () {
                      if (customer.method != "anonymous") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "We will send you an email to change your password",
                                  style: TextStyle(color: AppColors.empty_button_text),
                                ),
                                content: Text(
                                  "Are you sure?",
                                  style: TextStyle(color: AppColors.empty_button_text),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        auth.sendPasswordResetEmail(email: customer.email);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(color: AppColors.positive_button),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: AppColors.negative_button),
                                      ))
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuickObjects().prevention(context);
                            });
                      }
                    },
                    title: Text("Change Password"),
                    trailing: Icon(CupertinoIcons.chevron_right),
                    leading: Icon(CupertinoIcons.lock),
                  ),
                  ListTile(
                    onTap: () {
                      if (customer.method != "anonymous") {
                        pushNewScreen(context, screen: AddressOptions());
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuickObjects().prevention(context);
                            });
                      }
                    },
                    title: Text("Manage Addresses"),
                    trailing: Icon(CupertinoIcons.chevron_right),
                    leading: Icon(CupertinoIcons.home),
                  ),
                  ListTile(
                    onTap: () {
                      if (customer.method != "anonymous") {
                        pushNewScreen(context, screen: PaymentOptions());
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuickObjects().prevention(context);
                            });
                      }
                    },
                    title: Text("Manage Payment Options"),
                    trailing: Icon(CupertinoIcons.chevron_right),
                    leading: Icon(CupertinoIcons.creditcard),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Account Activity",
                    style: TextStyle(color: AppColors.system_gray),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text("Previous Orders"),
                    trailing: Icon(CupertinoIcons.chevron_right),
                    leading: Icon(CupertinoIcons.square_stack_3d_up),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text("Comments & Reviews"),
                    trailing: Icon(CupertinoIcons.chevron_right),
                    leading: Icon(CupertinoIcons.chat_bubble),
                  ),
                ]),
              )
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
