// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:provider/provider.dart';
import 'package:icon_badge/icon_badge.dart';
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
      List basketIDs = customer.basket;
      List amounts = customer.amounts;
      return StreamBuilder<List<Product>>(
          stream: DatabaseService(id: "", ids: basketIDs).specifiedProducts,
          builder: (context, snapshot) {
            List<Product>? basket = snapshot.data;

            if (basket != null && basket.isNotEmpty) {
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
                          itemCount: basket.length,
                          itemBuilder: (context, index) {
                            return QuickObjects().cartItem(
                                customer,
                                basket[index],
                                amounts[index + 1],
                                MediaQuery.of(context).size.width - 16);
                          },
                        ),
                      ),
                      ListTile(
                          title: Text(
                            "${totalAmount(amounts, basket).toStringAsFixed(2)} ₺",
                            style: TextStyle(
                                fontSize: 25, color: AppColors.title_text),
                          ),
                          trailing: OutlinedButton.icon(
                            style: ShapeRules(
                                    bg_color: AppColors.filled_button,
                                    side_color: AppColors.filled_button)
                                .outlined_button_style(),
                            onPressed: () async {},
                            icon: Icon(
                              CupertinoIcons.creditcard,
                              color: AppColors.filled_button_text,
                            ),
                            label: Text("Checkout",
                                style: TextStyle(
                                    color: AppColors.filled_button_text)),
                          ))
                    ],
                  ),
                ),
              );
              /*
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemExtent: 100.0,
                          itemCount: basket.length,
                          itemBuilder: (context, i) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                OutlinedButton(
                                    style: ShapeRules(
                                            bg_color: AppColors.empty_button,
                                            side_color: Colors.transparent)
                                        .outlined_button_style(),
                                    onPressed: () {},
                                    child: QuickObjects().ImageBoxProducts(
                                        basket[i].model,
                                        basket[i].name,
                                        basket[i].sex,
                                        basket[i].price * amounts[i],
                                        amounts[i],
                                        basket[i].photos[0],
                                        100,
                                        MediaQuery.of(context).size.width,
                                        true)),
                              ],
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          OutlinedButton(
                              style: ShapeRules(
                                      bg_color: AppColors.filled_button,
                                      side_color: Colors.transparent)
                                  .outlined_button_style(),
                              onPressed: () {},
                              child: Text(
                                'CHECKOUT',
                                style: TextStyle(
                                  color: AppColors.filled_button_text,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );*/
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
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Your cart is empty",
                                    style: TextStyle(fontSize: 30),
                                  )
                                ],
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
                                    style:
                                        TextStyle(color: AppColors.system_gray),
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

double totalAmount(List<dynamic> amounts, List<Product> cart) {
  double sum = 0;
  for (var i = 0; i < cart.length; i++) {
    sum += cart[i].price * amounts[i + 1];
  }
  return sum;
}
