import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/Screens/home/home.dart';
import 'package:mobile/Screens/home/productpage.dart';
import 'package:mobile/Screens/home/singlecategorypage.dart';
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

class allcategoriespage extends StatefulWidget {
  const allcategoriespage({ Key? key }) : super(key: key);

  @override
  State<allcategoriespage> createState() => _allcategoriespageState();
}

class _allcategoriespageState extends State<allcategoriespage> {

  int x = 0;
  double v = 0.0;

  @override
  Widget build(BuildContext context) {

    Customer customer = Provider.of<Customer>(context);

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
                                "All categories",
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
                              children: List.generate(extractCategories(products).length, (index) {
                                List<String> categories = extractCategories(products);
                                return OutlinedButton(
                                  style: ShapeRules(bg_color: AppColors.empty_button, side_color: Colors.transparent)
                                      .outlined_button_style(),
                                  onPressed: () {
                                    pushNewScreen(context, screen: singlecategorypage(category: categories[index]));
                                  },
                                  child: QuickObjects().namedImageBox(categories[index], categories[index].toLowerCase(), 105, 100, false));
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

List<String> extractCategories(List<Product>? allProducts) {
  List<String> returnList = [];
  for (var i = 0; i < allProducts!.length; i++) {
    if (!returnList.contains(allProducts[i].category.capitalize())) {
      returnList.add(allProducts[i].category.capitalize());
    }
  }
  return returnList;
}