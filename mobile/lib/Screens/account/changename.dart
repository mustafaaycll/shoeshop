import 'package:mobile/Services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import '../../models/users/customer.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final _formKey = GlobalKey<FormState>();
  String mail = "";
  String _message = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  void setMessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  Future<void> showAlertDialog(String title, String message) async {
    bool isiOS = Platform.isIOS;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isiOS) {
            return CupertinoAlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Text(message, textAlign: TextAlign.center),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          } else {
            return AlertDialog(
              title: Text(title, textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Text(message, textAlign: TextAlign.center),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK')),
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    return Scaffold(
      backgroundColor: AppColors.opposite_case_background,
      body: SafeArea(
        child: Padding(
          padding: Dimen.regularPadding,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Change Your name",
                          style: TextStyle(color: AppColors.opposite_case_title_text, fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text("Please type your name in the text field below", style: TextStyle(color: AppColors.opposite_case_title_text)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Name field cannot be empty!';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Name field cannot be empty!';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  mail = value;
                                }
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style:
                                ShapeRules(bg_color: AppColors.opposite_case_filled_button, side_color: AppColors.opposite_case_filled_button_border)
                                    .outlined_button_style(),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                DatabaseService(id: customer!.id, ids: []).changeName(mail);
                                //FocusManager.instance.primaryFocus?.unfocus();
                                Navigator.pop(context);
                              }
                            },
                            child: Padding(
                                padding: Dimen.regularPadding,
                                child: Text(
                                  'Change',
                                  style: TextStyle(color: AppColors.filled_button_text),
                                )),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: Dimen.largePadding,
                      child: Text(
                        _message,
                        style: TextStyle(
                          color: AppColors.negative_button_border,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          //FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                              color: AppColors.opposite_case_body_text,
                            ),
                            Text(
                              "Turn back to account screen",
                              style: TextStyle(color: AppColors.opposite_case_body_text),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
