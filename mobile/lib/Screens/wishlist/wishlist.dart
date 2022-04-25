// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/database.dart';
import '../../models/products/product.dart';
import '../../models/users/customer.dart';
import '../../utils/animations.dart';
import '../../utils/colors.dart';
import '../../utils/objects.dart';
import '../../utils/shapes_dimensions.dart';

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
              
              //Map<Product, dynamic> basket =
                  //recreateBasketMap(basketItems, customer.basketMap);
                  /*
                  return Scaffold(
                    body: Container(),
                  );
                    */
              
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
                            return QuickObjects().wishlistItem(customer, wishlistItems,
                                index, MediaQuery.of(context).size.width - 16);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
              
            }
            
            else {
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
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Your wishlist is empty",
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
      
    }

    else {
      return Animations().scaffoldLoadingScreen('WISHLIST');
    }

  }
}
