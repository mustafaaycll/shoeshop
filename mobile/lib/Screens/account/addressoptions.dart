import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/account/newaddress.dart';
import 'package:mobile/Screens/account/newpayment.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class AddressOptions extends StatefulWidget {
  const AddressOptions({Key? key}) : super(key: key);

  @override
  State<AddressOptions> createState() => _AddressOptionsState();
}

class _AddressOptionsState extends State<AddressOptions> {
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      List<dynamic> addresses = customer.addresses;

      if (addresses != null && !addresses.isEmpty) {
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
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(CupertinoIcons.home),
                          title: Text(addresses[index]),
                          trailing: IconButton(
                            onPressed: () {
                              DatabaseService(id: customer.id, ids: []).removeAddressOption(customer.addresses, addresses[index]);
                            },
                            icon: Icon(
                              CupertinoIcons.xmark_circle,
                              color: AppColors.negative_button,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                      trailing: OutlinedButton.icon(
                    style: ShapeRules(bg_color: AppColors.filled_button, side_color: AppColors.filled_button).outlined_button_style(),
                    onPressed: () {
                      pushNewScreen(context, screen: NewAddressOption(customer: customer));
                    },
                    icon: Icon(
                      CupertinoIcons.home,
                      color: AppColors.filled_button_text,
                    ),
                    label: Text("Add New Address", style: TextStyle(color: AppColors.filled_button_text)),
                  ))
                ],
              ),
            ));
      } else {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.title_text,
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.home,
                          size: 50,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 50),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 84,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "No address",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "When you add one, it'll appear here.",
                                  style: TextStyle(color: AppColors.system_gray),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    OutlinedButton(
                      style: ShapeRules(bg_color: AppColors.filled_button, side_color: AppColors.filled_button_border).outlined_button_style(),
                      onPressed: () {
                        pushNewScreen(context, screen: NewAddressOption(customer: customer));
                      },
                      child: Text("Add New Address", style: TextStyle(color: AppColors.filled_button_text)),
                    ),
                  ],
                ),
              )),
        );
      }
    } else {
      return Animations().scaffoldLoadingScreen('');
    }
  }
}
