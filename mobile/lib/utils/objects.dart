import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';

class QuickObjects {
  String getInitials(String text) {
    List<String> words = text.split(" ");
    String strToReturn = "";

    for (var i = 0; i < words.length; i++) {
      strToReturn = strToReturn + words[i][0];
    }

    return strToReturn;
  }

  Widget profilePicture(String fullname, double h, double w) {
    return SizedBox(
      height: h,
      width: w,
      child: Card(
        color: AppColors.opposite_case_filled_button,
        elevation: 0,
        child: Center(
            child: Text(
          getInitials(fullname),
          style: TextStyle(
              color: AppColors.opposite_case_title_text, fontSize: h / 3),
        )),
      ),
    );
  }

  Widget namedImageBox(
      String name, String src, double h, double w, bool network) {
    return SizedBox(
      height: h,
      width: w,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
              child: Column(
            children: [
              SizedBox(
                height: (h - 5) / 11,
              ),
              SizedBox(
                  width: w,
                  height: (h - 5) / 2,
                  child: network
                      ? Image.network(src)
                      : Image.asset('assets/category_pictures/${src}.png')),
              SizedBox(
                height: (h - 5) / 11,
              ),
              Text(
                name,
                style: TextStyle(color: AppColors.title_text, fontSize: 15),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget productTile(
      Product product, Customer customer, Seller seller, double h, double w) {
    return Container(
      height: h,
      width: w,
      child: Column(
        children: [
          Stack(children: [
            Container(
              width: w,
              height: 3 * h / 5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(product.photos[0]))),
            ),
            customer.fav_products.contains(product.id)
                ? Positioned(
                    left: w - 30 - 20,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.heart_fill,
                          color: AppColors.negative_button,
                          size: 30,
                        )),
                  )
                : Positioned(
                    left: w - 30 - 20,
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.heart,
                          color: AppColors.negative_button,
                          size: 30,
                        )),
                  ),
            Positioned(
                left: 15,
                top: 5,
                child: Container(
                  height: 40,
                  width: 40,
                  child: Image.network(seller.logo),
                ))
          ]),
          Container(
            width: w,
            height: 2 * h / 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        product.name + " ",
                        style:
                            TextStyle(color: AppColors.body_text, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          product.model,
                          style: TextStyle(
                              color: AppColors.body_text, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Expanded(
                    child: Text(
                      product.sex + "'s " + product.category + " shoe",
                      style:
                          TextStyle(color: AppColors.system_gray, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
