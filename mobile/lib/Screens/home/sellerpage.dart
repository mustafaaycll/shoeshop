// ignore_for_file: prefer_const_constructors

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

class SellerPage extends StatefulWidget {
  final Seller seller;
  const SellerPage({required this.seller, Key? key}) : super(key: key);

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  List<String> sortMethods = ["Price: Ascending", "Price: Descending", "Popularity: Ascending", "Popularity: Descending"];
  String sorting = "natural";

  int x = 0;
  double v = 0.0;

  @override
  Widget build(BuildContext context) {
    Seller seller = widget.seller;
    Customer customer = Provider.of<Customer>(context);
    return StreamBuilder<List<Product>>(
        stream: DatabaseService(id: "", ids: seller.products).specifiedProducts,
        builder: (context, snapshot) {
          List<Product>? products = snapshot.data;
          products = reOrder(products, sorting);
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
                              leading: Image.network(seller.logo),
                              title: Text(
                                seller.name,
                                style: TextStyle(fontSize: 35, color: AppColors.title_text),
                              ),
                              subtitle: RateBar(seller),
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
                              children: List.generate(products!.length, (index) {
                                return StreamBuilder<List<Comment>>(
                                    stream: DatabaseService(id: "", ids: products![index].comments).specifiedComments,
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
                                            pushNewScreen(context, screen: ProductPage(seller: seller, productID: products![index].id));
                                          },
                                          child: QuickObjects().productTile_gridView(products![index], customer, comments, seller,
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
  }

  Row RateBar(Seller seller) {
    if (seller.ratings.isNotEmpty) {
      return Row(
        children: [
          RatingBarIndicator(
            itemSize: 20,
            rating: getBrandRate(seller.ratings),
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.orange,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "${getBrandRate(seller.ratings).toStringAsFixed(1)}",
            style: TextStyle(color: AppColors.system_gray),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            "No Review",
            style: TextStyle(color: AppColors.system_gray),
          )
        ],
      );
    }
  }
}

double getAveRating(List<Comment>? comments) {
  double sum = 0;
  double count = comments!.length.toDouble();
  for (var i = 0; i < comments.length; i++) {
    sum += comments[i].rating;
  }

  return sum / count;
}

double getBrandRate(List<dynamic> comments) {
  double sum = 0;
  double count = comments.length.toDouble();
  for (var i = 0; i < comments.length; i++) {
    sum += comments[i];
  }

  return sum / count;
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
