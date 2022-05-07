// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../Services/database.dart';
import '../../models/products/product.dart';
import '../../models/users/customer.dart';
import '../../utils/animations.dart';
import '../../utils/colors.dart';
import '../../utils/objects.dart';
import '../../utils/shapes_dimensions.dart';
import '../home/productpage.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      List wishIDList = customer.fav_products.toList();

      return StreamBuilder<List<Product>>(
          stream: DatabaseService(id: "", ids: wishIDList).specifiedProducts,
          builder: (context, snapshot) {
            List<Product>? wishlistItems = snapshot.data;

            if (wishlistItems != null && wishlistItems.isNotEmpty) {
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  title: Text(
                    'WISHLIST',
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
                          itemCount: wishlistItems.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<Seller>(
                                stream: DatabaseService(id: wishlistItems[index].distributor_information, ids: []).sellerData,
                                builder: (context, snapshot) {
                                  Seller? seller = snapshot.data;
                                  if (seller != null) {
                                    return OutlinedButton(
                                      onPressed: () => {pushNewScreen(context, screen: ProductPage(seller: seller, product: wishlistItems[index]))},
                                      style: ShapeRules(bg_color: AppColors.background, side_color: AppColors.background)
                                          .outlined_button_style_no_padding(),
                                      child: QuickObjects().wishlistItem(customer, wishlistItems, index, MediaQuery.of(context).size.width - 16),
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
                    'WISHLIST',
                    style: TextStyle(color: AppColors.title_text, fontSize: 30),
                  ),
                ),
                body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.heart,
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
                                        "Your wishlist is empty",
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
      return Animations().scaffoldLoadingScreen('WISHLIST');
    }
  }
}
