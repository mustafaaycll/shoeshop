import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/Screens/home/productpage.dart';
import 'package:mobile/Screens/home/sellerpage.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/comments/comment.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/objects.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class allbrands extends StatefulWidget {
  const allbrands({ Key? key }) : super(key: key);

  @override
  State<allbrands> createState() => _allbrandsState();
}

class _allbrandsState extends State<allbrands> {

  int x = 0;
  double v = 0.0;

  @override
  Widget build(BuildContext context) {

    Customer customer = Provider.of<Customer>(context);

    return StreamBuilder<List<Seller>>(
      stream: DatabaseService(id: "", ids: []).allSellers,
      builder: ((context, snapshot) {
        List<Seller>? allSellers = snapshot.data;

        return StreamBuilder<List<Product>>(
          stream: DatabaseService(id: "", ids: []).allProducts,
          builder: (context, snapshot) {
            List<Product>? products = snapshot.data;

            if (products != null) {
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "All brands",
                                    style: TextStyle(fontSize: 35, color: AppColors.title_text),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(child: LayoutBuilder(
                            builder: (context, constraints) {
                              return GridView.count(
                                  crossAxisCount: 2,
                                  primary: true,
                                  childAspectRatio: 0.75,
                                  children: List.generate(allSellers!.length, (index) {
                                    return OutlinedButton(
                                      style: ShapeRules(bg_color: AppColors.empty_button, side_color: Colors.transparent)
                                          .outlined_button_style(),
                                      onPressed: () {
                                        pushNewScreen(context, screen: SellerPage(seller: allSellers[index]));
                                      },
                                      child: QuickObjects().namedImageBox(allSellers[index].name, allSellers[index].logo, 105, 100, true));
                                  }));
                            },
                          ))
                        ],
                      )),
                );
              } else {
                return Animations().scaffoldLoadingScreen_without_appbar();
              }
          });
        }),
      );
  }
}