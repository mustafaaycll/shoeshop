import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:mobile/Screens/account/newpayment.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/bankCards/bankCard.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({Key? key}) : super(key: key);

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      List cardIDs = customer.credit_cards;

      if (cardIDs != null && cardIDs.isNotEmpty) {
        return StreamBuilder<List<BankCard>>(
          stream: DatabaseService(id: "", ids: cardIDs).specifiedCards,
          builder: (context, snapshot) {
            List<BankCard>? cards = snapshot.data;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cards!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Badge(
                              animationType: BadgeAnimationType.scale,
                              elevation: 0,
                              position: BadgePosition.topStart(),
                              badgeColor: AppColors.background,
                              badgeContent: IconButton(
                                onPressed: () async {
                                  await DatabaseService(id: customer.id, ids: []).deleteExistingPaymentMethod(customer, cards[index].id);
                                },
                                icon: Icon(
                                  CupertinoIcons.xmark_circle,
                                  color: AppColors.negative_button,
                                ),
                                padding: EdgeInsets.all(0),
                                visualDensity: VisualDensity.compact,
                              ),
                              child: CreditCardWidget(
                                backgroundImage: 'assets/bg_card.jpg',
                                isChipVisible: false,
                                isHolderNameVisible: true,
                                onCreditCardWidgetChange: (p0) => {},
                                cardNumber: cards[index].cardNumber,
                                expiryDate: cards[index].expiryDate,
                                cardHolderName: cards[index].cardHolderName,
                                cvvCode: cards[index].cvvCode,
                                showBackView: false,
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
                        pushNewScreen(context, screen: NewPaymentOption(customer: customer));
                      },
                      icon: Icon(
                        CupertinoIcons.creditcard,
                        color: AppColors.filled_button_text,
                      ),
                      label: Text("Add New Card", style: TextStyle(color: AppColors.filled_button_text)),
                    ))
                  ],
                ),
              ),
            );
          },
        );
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
                          CupertinoIcons.creditcard,
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
                                      "No payment method",
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
                        pushNewScreen(context, screen: NewPaymentOption(customer: customer));
                      },
                      child: Text("Add New Method", style: TextStyle(color: AppColors.filled_button_text)),
                    ),
                  ],
                ),
              )),
        );
      }
    } else {
      return Animations().scaffoldLoadingScreen('PAYMENT');
    }
  }
}
