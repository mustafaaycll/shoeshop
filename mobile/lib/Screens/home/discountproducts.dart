import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/Screens/home/productpage.dart';
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

class discountproducts extends StatefulWidget {
  const discountproducts({ Key? key }) : super(key: key);

  @override
  State<discountproducts> createState() => _discountproductsState();
}

class _discountproductsState extends State<discountproducts> {

  List<String> sortMethods = ["Price: Ascending", "Price: Descending", "Popularity: Ascending", "Popularity: Descending"];
  String sorting = "natural";

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
          stream: DatabaseService(id: "", ids: []).discountedProducts,
          builder: (context, snapshot) {
            List<Product>? discounteds = snapshot.data;
            discounteds = reOrder(discounteds, sorting);

            if (discounteds != null) {
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
                                    "Products on discount",
                                    style: TextStyle(fontSize: 35, color: AppColors.title_text),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Container()),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: Icon(CupertinoIcons.line_horizontal_3_decrease_circle, size: 18, color: AppColors.secondary_text),
                                  alignment: AlignmentDirectional.centerEnd,
                                  dropdownColor: AppColors.background,
                                  hint: Row(
                                    children: [
                                      Text(
                                        "Sort by",
                                        style: TextStyle(color: AppColors.secondary_text),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  ),
                                  items: sortMethods.map((element) {
                                    return DropdownMenuItem(
                                      value: element,
                                      child: Text(element),
                                    );
                                  }).toList(),
                                  onChanged: (String? val) {
                                    setState(() {
                                      sorting = val!;
                                    });
                                  },
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
                                  children: List.generate(discounteds!.length, (index) {
                                    return StreamBuilder<List<Comment>>(
                                        stream: DatabaseService(id: "", ids: discounteds![index].comments).specifiedComments,
                                        builder: (context, snapshot) {
                                          List<Comment>? comments = snapshot.data;
                                          if (comments != null) {
                                            if (comments.isNotEmpty) {
                                              double aveRating = getAveRating(comments);
                                            }
                                            return OutlinedButton(
                                              style: ShapeRules(bg_color: AppColors.empty_button, side_color: AppColors.empty_button)
                                                  .outlined_button_style_no_padding(),
                                              onPressed: () {
                                                pushNewScreen(context, screen: ProductPage(seller: allSellers!
                                                                            .where((element) => element.name == discounteds![index].name)
                                                                            .toList()[0], productID: discounteds![index].id));
                                              },
                                              child: QuickObjects().productTile_gridView(discounteds![index], customer, comments, allSellers!
                                                                            .where((element) => element.name == discounteds![index].name)
                                                                            .toList()[0],
                                                  constraints.heightConstraints().maxHeight, constraints.widthConstraints().maxWidth),
                                            );
                                          } else {
                                            return Animations().loading();
                                          }
                                        });
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

List<Product>? reOrder(List<Product>? productList, String method) {
  if (method == "natural") {
    return productList;
  } else if (method == "Price: Ascending") {
    productList!.sort((a, b) => a.price.compareTo(b.price));
    return productList;
  } else if (method == "Price: Descending") {
    productList!.sort((a, b) => b.price.compareTo(a.price));
    return productList;
  } else if (method == "Popularity: Ascending") {
    productList!.sort((a, b) => a.averageRate.compareTo(b.averageRate));
    return productList;
  } else if (method == "Popularity: Descending") {
    productList!.sort((a, b) => b.averageRate.compareTo(a.averageRate));
    return productList;
  } else {
    return productList;
  }
}