import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/account/newpayment.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class NewAddressOption extends StatefulWidget {
  final Customer customer;

  const NewAddressOption({Key? key, required this.customer}) : super(key: key);

  @override
  State<NewAddressOption> createState() => _NewAddressOptionState();
}

class _NewAddressOptionState extends State<NewAddressOption> {
  final _formKeyAddress = GlobalKey<FormState>();

  String neighborhood = "";
  String street = "";
  String aptNo = "";
  String flatNo = "";
  String zipCode = "";
  String district = "";
  String city = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.title_text,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKeyAddress,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Let's add a new address!",
                        style: TextStyle(color: AppColors.title_text, fontSize: 30),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Please fill the form below.", style: TextStyle(color: AppColors.title_text)),
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
                              keyboardType: TextInputType.streetAddress,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'Neighborhood',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter neighborhood';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Enter neighborhood';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  neighborhood = value;
                                }
                              }))
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
                          child: TextFormField(
                              keyboardType: TextInputType.streetAddress,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'Street',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter street';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Enter street';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  street = value;
                                }
                              }))
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
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'Aprt. No.',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter apartment number';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Enter apartment number';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  aptNo = value;
                                }
                              })),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'Flat No.',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter flat number';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Enter flat number';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  flatNo = value;
                                }
                              })),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'Zip Code',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter zip code';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Enter zip code';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  zipCode = value;
                                }
                              }))
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
                          child: TextFormField(
                              keyboardType: TextInputType.streetAddress,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'District',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter district';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Enter district';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  district = value;
                                }
                              })),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                              keyboardType: TextInputType.streetAddress,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                hintText: 'City',
                                fillColor: AppColors.background,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter city';
                                } else {
                                  String trimmedValue = value.trim();
                                  if (trimmedValue.isEmpty) {
                                    return 'Enter city';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  city = value;
                                }
                              })),
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
                          style: ShapeRules(bg_color: AppColors.filled_button, side_color: AppColors.filled_button_border).outlined_button_style(),
                          onPressed: () async {
                            if (_formKeyAddress.currentState!.validate()) {
                              _formKeyAddress.currentState!.save();
                              String address = "$neighborhood, $street, Apartment: $aptNo, Flat: $flatNo, $zipCode $district/$city";
                              DatabaseService(id: widget.customer.id, ids: []).addAddressOption(widget.customer.addresses, address);
                              Navigator.pop(context);
                            }
                          },
                          child: Padding(
                              padding: Dimen.regularPadding,
                              child: Text(
                                'Add',
                                style: TextStyle(color: AppColors.filled_button_text),
                              )),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
