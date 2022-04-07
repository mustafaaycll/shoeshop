import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:icon_badge/icon_badge.dart';
import '../../models/users/customer.dart';
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
    //print(customer?.fullname);
    // List<QueryDocumentSnapshot<Product>> get docs;
    if (customer != null) {
      List productlist = customer.basket;
      List amountlist = customer.amounts;
      //print(productlist);
      if (productlist[0] != "") {
        return StreamBuilder<List<Product>>(
            stream: DatabaseService(id: customer.id, ids: []).allProducts,
            builder: ((context, snapshot) {
              List<Product>? allproducts = snapshot.data;

              return StreamBuilder<List<Product>>(
                  stream: DatabaseService(id: "", ids: productlist)
                      .specifiedProducts,
                  builder: (context, snapshot) {
                    List<Product>? specProducts = snapshot.data;

                    return Scaffold(
                      backgroundColor: AppColors.background,
                      appBar: AppBar(
                        backgroundColor: AppColors.background,
                        elevation: 0,
                        title: Text(
                          'CART',
                          style: TextStyle(
                              color: AppColors.title_text, fontSize: 30),
                        ),
                      ),
                      body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                   specProducts != null
                                        ? ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            controller: ScrollController(),
                                            shrinkWrap: true,
                                            itemExtent: 100.0,
                                            itemCount: productlist.length,
                                            itemBuilder: (context, i) {
                                             return  Row(
                                               mainAxisAlignment: MainAxisAlignment.start,

                                                children: [
                                                  OutlinedButton(
                                                      style: ShapeRules(
                                                              bg_color: AppColors
                                                                  .empty_button,
                                                              side_color: Colors
                                                                  .transparent)
                                                          .outlined_button_style(),
                                                      onPressed: () {
                                                        
                                                      },
                                                      child: QuickObjects()
                                                          .ImageBoxProducts(
                                                            specProducts[i].model,
                                                              specProducts[i]
                                                                  .name,
                                                              specProducts[i].sex,
                                                              specProducts[i]
                                                                      .price *
                                                                  amountlist[i],
                                                              amountlist[i],
                                                              specProducts[i]
                                                                  .photos[0],
                                                              100,
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                              true)),
                                                ],
                                              );
                                            })
                                        : Animations().loading(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                          style: ShapeRules(
                                                  bg_color:
                                                      AppColors.filled_button,
                                                  side_color: Colors.transparent)
                                              .outlined_button_style(),
                                          onPressed: () {},
                                          child: Text(
                                            'CHECKOUT',
                                            style: TextStyle(
                                              color: AppColors
                                                 .filled_button_text,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                            ),
                          ),
                          
                      );
                  });
            }));
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
          body: Center(
            child: Padding(
              child: IconBadge(
                icon: Icon(
                  CupertinoIcons.cart,
                  size: 110.0,
                  color: AppColors.opposite_case_filled_button_text,
                ),
                badgeColor: AppColors.circleAvatarBackground,
                itemColor: AppColors.opposite_case_filled_button_text,
                hideZero: true,
              ),
              padding: EdgeInsets.fromLTRB(5.0, 12.0, 55.0, 12.0),
            ),
          ),
        );
      }
    } else {
      return Animations().scaffoldLoadingScreen('CART');
    }
  }
}
