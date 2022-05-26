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
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<Product, dynamic> basket;
  const CheckoutScreen({Key? key, required this.basket}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  BankCard? _selectedCard;
  String? _selectedAddress;
  bool wallet_will_be_used = false;
  Color buttonColor = AppColors.system_gray;

  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      buttonColor = getButtonColor(wallet_will_be_used, _selectedAddress, _selectedCard, customer.wallet, totalAmount(widget.basket));

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Swipe and select payment option",
                            style: TextStyle(color: AppColors.system_gray),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  if (wallet_will_be_used) {
                                    wallet_will_be_used = false;
                                  } else {
                                    wallet_will_be_used = true;
                                    _selectedCard = null;
                                  }
                                });
                              },
                              style: ShapeRules(bg_color: Colors.transparent, side_color: Colors.transparent).text_button_style_no_padding(),
                              child: Text(wallet_will_be_used ? "Use Card Instead" : "Use Wallet Instead",
                                  style: TextStyle(color: AppColors.title_text, decoration: TextDecoration.underline)))
                        ],
                      ),
                      wallet_will_be_used
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title:
                                            QuickObjects().balanceIndicator("Wallet Balance: " + customer.wallet.toStringAsFixed(2) + "₺", 50, 100),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            )
                          : StreamBuilder<List<BankCard>>(
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
                    style: ShapeRules(bg_color: buttonColor, side_color: buttonColor).outlined_button_style(),
                    onPressed: () async {
                      if (_selectedAddress != null && wallet_will_be_used && customer.wallet >= totalAmount(widget.basket)) {
                        List<Order> orderArr = [];
                        String pdfName = "";
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
                              date: DateTime.now(),
                              rated: false,
                              returnID: "");
                          orderArr.add(order);

                          pdfName = pdfName + order.id;
                          if (i != widget.basket.keys.toList().length - 1) {
                            pdfName = pdfName + "-";
                          }
                        }

                        DatabaseService(id: customer.id, ids: []).createNewOrder(orderArr, customer, widget.basket, _selectedAddress);
                        DatabaseService(id: "", ids: []).decreaseAmountFromSpecifiedProducts(widget.basket);
                        DatabaseService(id: customer.id, ids: []).changeWalletBalance(customer.wallet, totalAmount(widget.basket) * -1);

                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuickObjects().orderReceived(context, pdfName);
                            });

                        String? url;

                        while (url == null) {
                          try {
                            url = await DatabaseService(id: pdfName, ids: []).getPdfURL();
                          } catch (e) {
                            print(e.toString());
                          }
                        }
                        DatabaseService(id: "", ids: []).sendInvoiceMail(
                            customer.email,
                            "Invoice for order on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                            "Dear ${customer.fullname}, thank you for your purchase.",
                            "$url");
                      } else if (_selectedAddress != null && _selectedCard != null) {
                        List<Order> orderArr = [];
                        String pdfName = "";
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
                              date: DateTime.now(),
                              rated: false,
                              returnID: "");
                          orderArr.add(order);

                          pdfName = pdfName + order.id;
                          if (i != widget.basket.keys.toList().length - 1) {
                            pdfName = pdfName + "-";
                          }
                        }

                        DatabaseService(id: customer.id, ids: []).createNewOrder(orderArr, customer, widget.basket, _selectedAddress);
                        DatabaseService(id: "", ids: []).decreaseAmountFromSpecifiedProducts(widget.basket);

                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return QuickObjects().orderReceived(context, pdfName);
                            });

                        String? url;

                        while (url == null) {
                          try {
                            url = await DatabaseService(id: pdfName, ids: []).getPdfURL();
                          } catch (e) {
                            print(e.toString());
                          }
                        }
                        DatabaseService(id: "", ids: []).sendInvoiceMail(
                            customer.email,
                            "Invoice for order on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                            "Dear ${customer.fullname}, thank you for your purchase.",
                            "$url");
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

Color getButtonColor(bool wallet_will_be_used, String? selectedAddress, BankCard? selectedCard, double balance, double totalAmount) {
  if (wallet_will_be_used && balance >= totalAmount) {
    if (selectedAddress != null) {
      return AppColors.filled_button;
    } else {
      return AppColors.system_gray;
    }
  } else {
    if (selectedAddress != null && selectedCard != null) {
      return AppColors.filled_button;
    } else {
      return AppColors.system_gray;
    }
  }
}
