// ignore_for_file: prefer_const_constructors

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/home/productpage.dart';
import 'package:mobile/Screens/home/sellerpage.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/users/customer.dart';
import '../../models/users/customer.dart';
import '../../utils/shapes_dimensions.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      return StreamBuilder<List<Seller>>(
        stream: DatabaseService(id: "", ids: []).allSellers,
        builder: ((context, snapshot) {
          List<Seller>? allSellers = snapshot.data;

          return StreamBuilder<List<Product>>(
              stream: DatabaseService(id: "", ids: []).allProducts,
              builder: (context, snapshot) {
                List<Product>? allProducts = snapshot.data;

                return Scaffold(
                    backgroundColor: AppColors.background,
                    appBar: AppBar(
                      backgroundColor: AppColors.background,
                      elevation: 0,
                      title: Text(
                        'HOME',
                        style: TextStyle(
                            color: AppColors.title_text, fontSize: 30),
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Explore by brands",
                                  style:
                                      TextStyle(color: AppColors.system_gray),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        "All",
                                        style: TextStyle(
                                            color: AppColors.secondary_text),
                                      ),
                                      Icon(CupertinoIcons.right_chevron,
                                          size: 13,
                                          color: AppColors.secondary_text)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 105,
                              child: allSellers != null
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: allSellers.length,
                                      itemBuilder: (context, i) {
                                        return Row(
                                          children: [
                                            OutlinedButton(
                                                style: ShapeRules(
                                                        bg_color: AppColors
                                                            .empty_button,
                                                        side_color:
                                                            Colors.transparent)
                                                    .outlined_button_style(),
                                                onPressed: () {
                                                  pushNewScreen(context,
                                                      screen: SellerPage(
                                                          seller:
                                                              allSellers[i]));
                                                },
                                                child: QuickObjects()
                                                    .namedImageBox(
                                                        allSellers[i].name,
                                                        allSellers[i].logo,
                                                        105,
                                                        100,
                                                        true)),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  : Animations().loading(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Explore by categories",
                                  style:
                                      TextStyle(color: AppColors.system_gray),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        "All",
                                        style: TextStyle(
                                            color: AppColors.secondary_text),
                                      ),
                                      Icon(CupertinoIcons.right_chevron,
                                          size: 13,
                                          color: AppColors.secondary_text)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 105,
                              child: allProducts != null
                                  ? ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          extractCategories(allProducts).length,
                                      itemBuilder: (context, j) {
                                        List<String> categories =
                                            extractCategories(allProducts);
                                        return Row(
                                          children: [
                                            OutlinedButton(
                                                style: ShapeRules(
                                                        bg_color: AppColors
                                                            .empty_button,
                                                        side_color: Colors
                                                            .transparent)
                                                    .outlined_button_style(),
                                                onPressed: () {},
                                                child: QuickObjects()
                                                    .namedImageBox(
                                                        categories[j],
                                                        categories[j]
                                                            .toLowerCase(),
                                                        105,
                                                        100,
                                                        false)),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  : Animations().loading(),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Explore by gender",
                                  style:
                                      TextStyle(color: AppColors.system_gray),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                      style: ShapeRules(
                                              bg_color: AppColors.empty_button,
                                              side_color: Colors.transparent)
                                          .outlined_button_style(),
                                      onPressed: () {},
                                      child: Text("Men's",
                                          style: TextStyle(
                                              color: AppColors.body_text))),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                      style: ShapeRules(
                                              bg_color: AppColors.empty_button,
                                              side_color: Colors.transparent)
                                          .outlined_button_style(),
                                      onPressed: () {},
                                      child: Text("Women's",
                                          style: TextStyle(
                                              color: AppColors.body_text))),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                      style: ShapeRules(
                                              bg_color: AppColors.empty_button,
                                              side_color: Colors.transparent)
                                          .outlined_button_style(),
                                      onPressed: () {},
                                      child: Text("Unisex",
                                          style: TextStyle(
                                              color: AppColors.body_text))),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Products on discount",
                                  style:
                                      TextStyle(color: AppColors.system_gray),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        "All",
                                        style: TextStyle(
                                            color: AppColors.secondary_text),
                                      ),
                                      Icon(CupertinoIcons.right_chevron,
                                          size: 13,
                                          color: AppColors.secondary_text)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            StreamBuilder<List<Product>>(
                                stream: DatabaseService(id: "", ids: [])
                                    .discountedProducts,
                                builder: (context, snapshot) {
                                  List<Product>? discounteds = snapshot.data;
                                  return SizedBox(
                                    height: 250,
                                    child: discounteds != null
                                        ? ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: discounteds.length,
                                            itemBuilder: (context, l) {
                                              return Row(
                                                children: [
                                                  OutlinedButton(
                                                      style: ShapeRules(
                                                              bg_color: AppColors
                                                                  .empty_button,
                                                              side_color: AppColors
                                                                  .empty_button_border)
                                                          .outlined_button_style_no_padding(),
                                                      onPressed: () {
                                                        pushNewScreen(context,
                                                            screen: ProductPage(
                                                                seller: allSellers!
                                                                    .where((element) =>
                                                                        element
                                                                            .name ==
                                                                        discounteds[l]
                                                                            .name)
                                                                    .toList()[0],
                                                                product: discounteds[l]));
                                                      },
                                                      child: QuickObjects()
                                                          .discountedProductTile_listView(
                                                              discounteds[l],
                                                              customer,
                                                              allSellers!
                                                                  .where((element) =>
                                                                      element
                                                                          .name ==
                                                                      discounteds[
                                                                              l]
                                                                          .name)
                                                                  .toList()[0],
                                                              250,
                                                              190)),
                                                  SizedBox(
                                                    width: 10,
                                                  )
                                                ],
                                              );
                                            },
                                          )
                                        : Animations().loading(),
                                  );
                                }),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ));
              });
        }),
      );
    } else {
      return Animations().scaffoldLoadingScreen('HOME');
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

List<String> extractCategories(List<Product>? allProducts) {
  List<String> returnList = [];
  for (var i = 0; i < allProducts!.length; i++) {
    if (!returnList.contains(allProducts[i].category.capitalize())) {
      returnList.add(allProducts[i].category.capitalize());
    }
  }
  return returnList;
}

List<Product> extractDiscountedProducts(List<Product>? allProducts) {
  List<Product> returnList = [];
  for (var i = 0; i < allProducts!.length; i++) {
    if (allProducts[i].discount_rate != 0) {
      returnList.add(allProducts[i]);
    }
  }
  return returnList;
}
