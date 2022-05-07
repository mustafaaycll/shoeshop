// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/cart/checkoutscreen.dart';
import 'package:mobile/Screens/home/productpage.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../models/users/customer.dart';
import '../../utils/shapes_dimensions.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      List basketIDs = customer.basketMap.keys.toList();

      return StreamBuilder<List<Product>>(
          stream: DatabaseService(id: "", ids: basketIDs).specifiedProducts,
          builder: (context, snapshot) {
            List<Product>? basketItems = snapshot.data;

            if (basketItems != null && basketItems.isNotEmpty) {
              Map<Product, dynamic> basket = recreateBasketMap(basketItems, customer.basketMap);

              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  title: Text(
                    'CART',
                    style: TextStyle(color: AppColors.title_text, fontSize: 30),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: basket.keys.toList().length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<Seller>(
                                stream: DatabaseService(id: basket.keys.toList()[index].distributor_information, ids: []).sellerData,
                                builder: (context, snapshot) {
                                  Seller? seller = snapshot.data;
                                  if (seller != null) {
                                    return OutlinedButton(
                                      onPressed: () =>
                                          {pushNewScreen(context, screen: ProductPage(seller: seller, product: basket.keys.toList()[index]))},
                                      style: ShapeRules(bg_color: AppColors.background, side_color: AppColors.background)
                                          .outlined_button_style_no_padding(),
                                      child: QuickObjects().cartItem(customer, basket, index, MediaQuery.of(context).size.width - 16),
                                    );
                                  } else {
                                    return OutlinedButton(
                                      onPressed: () => {},
                                      style: ShapeRules(bg_color: AppColors.background, side_color: AppColors.background)
                                          .outlined_button_style_no_padding(),
                                      child: Animations().loading(),
                                    );
                                  }
                                });
                          },
                        ),
                      ),
                      ListTile(
                          title: Text(
                            "${totalAmount(basket).toStringAsFixed(2)} ₺",
                            style: TextStyle(fontSize: 25, color: AppColors.title_text),
                          ),
                          trailing: OutlinedButton.icon(
                            style: ShapeRules(bg_color: AppColors.filled_button, side_color: AppColors.filled_button).outlined_button_style(),
                            onPressed: () {
                              if (customer.email != "No Email") {
                                pushNewScreen(context, screen: CheckoutScreen(basket: basket));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return QuickObjects().prevention(context);
                                    });
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.creditcard,
                              color: AppColors.filled_button_text,
                            ),
                            label: Text("Checkout", style: TextStyle(color: AppColors.filled_button_text)),
                          ))
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  title: Text(
                    'CART',
                    style: TextStyle(color: AppColors.title_text, fontSize: 30),
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.cart,
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
                                        "Your cart is empty",
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
                                    "When you add products, they'll appear here.",
                                    style: TextStyle(color: AppColors.system_gray),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              );
            }
          });
    } else {
      return Animations().scaffoldLoadingScreen('CART');
    }
  }
}

Map<Product, dynamic> recreateBasketMap(List<Product>? basketItems, Map<dynamic, dynamic> basketMap) {
  Map<Product, dynamic> basket = {};

  for (var i = 0; i < basketItems!.length; i++) {
    basketMap.forEach((key, value) {
      if (key == basketItems[i].id) {
        basket[basketItems[i]] = value;
      }
    });
  }

  return basket;
}

double totalAmount(Map<Product, dynamic> basketMap) {
  double sum = 0;
  basketMap.forEach((key, value) {
    sum += key.price * value[0];
  });
  return sum;
}
