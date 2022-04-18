// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/home/productpage.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/objects.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

Size _getSizeOfWidget(GlobalKey key) {
  final RenderBox? renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
  return renderBox!.size;
}

Offset _getPositionOfWidget(GlobalKey key) {
  final RenderBox? renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
  return renderBox!.localToGlobal(Offset.zero);
}

class SellerPage extends StatefulWidget {
  final Seller seller;
  const SellerPage({required this.seller, Key? key}) : super(key: key);

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  List<String> sortMethods = [
    "Price: Ascending",
    "Price: Descending",
    "Popularity: Ascending",
    "Popularity: Descending"
  ];
  String sorting = "natural";
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
                                style: TextStyle(
                                    fontSize: 35, color: AppColors.title_text),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.orange,
                                    size: 15,
                                  ),
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.orange,
                                    size: 15,
                                  ),
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.orange,
                                    size: 15,
                                  ),
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: Colors.orange,
                                    size: 15,
                                  ),
                                  Icon(
                                    CupertinoIcons.star_fill,
                                    color: AppColors.system_gray,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "(2312)",
                                    style:
                                        TextStyle(color: AppColors.system_gray),
                                  )
                                ],
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
                              icon: Icon(
                                  CupertinoIcons
                                      .line_horizontal_3_decrease_circle,
                                  size: 18,
                                  color: AppColors.secondary_text),
                              alignment: AlignmentDirectional.centerEnd,
                              dropdownColor: AppColors.background,
                              hint: Row(
                                children: [
                                  Text(
                                    "Sort by",
                                    style: TextStyle(
                                        color: AppColors.secondary_text),
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
                              children:
                                  List.generate(products!.length, (index) {
                                return OutlinedButton(
                                  style: ShapeRules(
                                          bg_color: AppColors.empty_button,
                                          side_color: AppColors.empty_button)
                                      .outlined_button_style_no_padding(),
                                  onPressed: () {
                                    pushNewScreen(context,
                                        screen: ProductPage(
                                            seller: seller,
                                            product: products![index]));
                                  },
                                  child: QuickObjects().productTile_gridView(
                                      products![index],
                                      customer,
                                      seller,
                                      constraints.heightConstraints().maxHeight,
                                      constraints.widthConstraints().maxWidth),
                                );
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
  } else {
    return productList;
  }
}
