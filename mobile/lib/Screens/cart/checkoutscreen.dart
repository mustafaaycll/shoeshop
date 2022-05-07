import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:mobile/Screens/account/newaddress.dart';
import 'package:mobile/Screens/account/newpayment.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/bankCards/bankCard.dart';
import 'package:mobile/models/orders/order.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<Product, dynamic> basket;
  const CheckoutScreen({Key? key, required this.basket}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  BankCard? _selectedCard;
  String? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Swipe and select payment option",
                            style: TextStyle(color: AppColors.system_gray),
                          ),
                        ],
                      ),
                      StreamBuilder<List<BankCard>>(
                          stream: DatabaseService(id: "", ids: customer.credit_cards).specifiedCards,
                          builder: (context, snapshot) {
                            List<BankCard>? cards = snapshot.data;

                            return SizedBox(
                                height: 250,
                                child: cards != null
                                    ? PageView.builder(
                                        itemCount: cards.length + 1,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          if (index == cards.length) {
                                            return IconButton(
                                              onPressed: () {
                                                pushNewScreen(context, screen: NewPaymentOption(customer: customer));
                                              },
                                              icon: Icon(CupertinoIcons.add),
                                            );
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width - 32,
                                                child: Badge(
                                                  animationType: BadgeAnimationType.scale,
                                                  elevation: 0,
                                                  position: BadgePosition.topStart(),
                                                  badgeColor: AppColors.background,
                                                  badgeContent: IconButton(
                                                    onPressed: () {
                                                      _selectedCard = cards[index];
                                                      setState(() {});
                                                    },
                                                    icon: Icon(
                                                      _selectedCard == null || _selectedCard!.id != cards[index].id
                                                          ? CupertinoIcons.square
                                                          : CupertinoIcons.checkmark_square,
                                                      color: AppColors.filled_button,
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
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : SizedBox(
                                        width: MediaQuery.of(context).size.width - 16,
                                        height: 100,
                                        child: IconButton(
                                          onPressed: () {
                                            pushNewScreen(context, screen: NewPaymentOption(customer: customer));
                                          },
                                          icon: Icon(CupertinoIcons.add),
                                        ),
                                      ));
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Swipe and select delivery address",
                            style: TextStyle(color: AppColors.system_gray),
                          ),
                        ],
                      ),
                      customer.addresses.length != 0
                          ? SizedBox(
                              height: 100,
                              child: PageView.builder(
                                itemCount: customer.addresses.length + 1,
                                itemBuilder: (context, j) {
                                  if (j == customer.addresses.length) {
                                    return IconButton(
                                      onPressed: () {
                                        pushNewScreen(context, screen: NewAddressOption(customer: customer));
                                      },
                                      icon: Icon(CupertinoIcons.add),
                                    );
                                  } else {
                                    return Center(
                                      child: ListTile(
                                        leading: IconButton(
                                          onPressed: () {
                                            _selectedAddress = customer.addresses[j];
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            _selectedAddress == null || _selectedAddress != customer.addresses[j]
                                                ? CupertinoIcons.square
                                                : CupertinoIcons.checkmark_square,
                                            color: AppColors.filled_button,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        title: Text(customer.addresses[j]),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width - 16,
                              height: 100,
                              child: IconButton(
                                onPressed: () {
                                  pushNewScreen(context, screen: NewAddressOption(customer: customer));
                                },
                                icon: Icon(CupertinoIcons.add),
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Items in cart",
                            style: TextStyle(color: AppColors.system_gray),
                          ),
                        ],
                      ),
                      Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.basket.keys.toList().length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<Seller>(
                                stream: DatabaseService(id: widget.basket.keys.toList()[index].distributor_information, ids: []).sellerData,
                                builder: (context, snapshot) {
                                  Seller? seller = snapshot.data;
                                  if (seller != null) {
                                    return QuickObjects()
                                        .cartItem_withoutButtons(customer, widget.basket, index, MediaQuery.of(context).size.width - 16);
                                  } else {
                                    return Animations().loading();
                                  }
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                  title: Text(
                    "${totalAmount(widget.basket).toStringAsFixed(2)} ₺",
                    style: TextStyle(fontSize: 25, color: AppColors.title_text),
                  ),
                  trailing: OutlinedButton.icon(
                    style: ShapeRules(
                            bg_color: _selectedAddress != null && _selectedCard != null ? AppColors.filled_button : AppColors.system_gray,
                            side_color: _selectedAddress != null && _selectedCard != null ? AppColors.filled_button : AppColors.system_gray)
                        .outlined_button_style(),
                    onPressed: () async {
                      if (_selectedAddress != null && _selectedCard != null) {
                        List<Order> orderArr = [];

                        for (var i = 0; i < widget.basket.keys.toList().length; i++) {
                          Order order = Order(
                              id: DatabaseService(id: "", ids: []).randID(),
                              customerID: customer.id,
                              sellerID: widget.basket.keys.toList()[i].distributor_information,
                              productID: widget.basket.keys.toList()[i].id,
                              address: _selectedAddress!,
                              status: "processing",
                              size: widget.basket[widget.basket.keys.toList()[i]][1],
                              price: widget.basket.keys.toList()[i].price * widget.basket[widget.basket.keys.toList()[i]][0],
                              quantity: widget.basket[widget.basket.keys.toList()[i]][0],
                              date: DateTime.now());
                          orderArr.add(order);
                        }
                        DatabaseService(id: customer.id, ids: []).createNewOrder(orderArr, customer, widget.basket, _selectedAddress);
                        DatabaseService(id: "", ids: []).decreaseAmountFromSpecifiedProducts(widget.basket);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String pdfName = "";
                              for (var i = 0; i < orderArr.length; i++) {
                                Order order = orderArr[i];
                                pdfName = pdfName + order.id;
                                if (i != orderArr.length - 1) {
                                  pdfName = pdfName + "-";
                                }
                              }
                              return QuickObjects().orderReceived(context, pdfName);
                            });
                      }
                    },
                    icon: Icon(
                      CupertinoIcons.check_mark_circled,
                      color: AppColors.filled_button_text,
                    ),
                    label: Text("Complete", style: TextStyle(color: AppColors.filled_button_text)),
                  ))
            ],
          ),
        ),
      );
    } else {
      return Animations().scaffoldLoadingScreen('');
    }
  }
}

double totalAmount(Map<Product, dynamic> basketMap) {
  double sum = 0;
  basketMap.forEach((key, value) {
    sum += key.price * value[0];
  });
  return sum;
}
