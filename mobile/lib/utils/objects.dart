import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:mobile/utils/styles.dart';

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

  Widget ImageBoxProducts(String model, String name, String sex, double price,
      int amm, String src, double h, double w, bool network) {
    return SizedBox(
      height: h,
      width: w - 49,
      child: Card(
        color: AppColors.circleAvatarBackground,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  network
                      ? Image.network(
                          src,
                          width: 50.0,
                          height: 80.0,
                        )
                      : Image.asset('assets/category_pictures/${src}.png'),
                ],
              ),
              SizedBox(
                height: h,
                width: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        color: AppColors.filled_button_text, fontSize: 15),
                  ),
                  Text(
                    model,
                    style: TextStyle(
                        color: AppColors.filled_button_text, fontSize: 15),
                  ),
                  Text(
                    sex,
                    style: TextStyle(
                        color: AppColors.filled_button_text, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: h,
                width: 20.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '\$ ' + price.toStringAsFixed(2),
                    style: TextStyle(
                        color: AppColors.filled_button_text, fontSize: 15),
                  ),
                  Text(
                    'x' + amm.toString(),
                    style: TextStyle(
                        color: AppColors.filled_button_text, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget discountedProductTile_listView(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: Image.network(seller.logo),
                ),
                Expanded(
                  child: Container(),
                ),
                customer.fav_products.contains(product.id)
                    ? IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.heart_fill,
                          color: AppColors.negative_button,
                          size: 30,
                        ))
                    : IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.heart,
                          color: AppColors.negative_button,
                          size: 30,
                        )),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Positioned(
                left: 8,
                top: (3 * h / 5) - 20,
                child: Container(
                  height: 20,
                  width: 40,
                  child: Center(
                    child: Text(
                      "${product.discount_rate}%",
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                  color: AppColors.negative_button,
                )),
            product.quantity <= 5
                ? Positioned(
                    left: 50,
                    top: (3 * h / 5) - 20,
                    child: Container(
                      height: 20,
                      width: 80,
                      child: Center(
                        child: Text(
                          "Last ${product.quantity} in stock",
                          style: TextStyle(
                              color: AppColors.background, fontSize: 11),
                        ),
                      ),
                      color: AppColors.negative_button,
                    ))
                : Container(),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${product.price.toStringAsFixed(2)} ₺",
                              style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.secondary_text)),
                          Text(
                              "${(product.price - (product.price * product.discount_rate / 100)).toStringAsFixed(2)} ₺",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.negative_button)),
                        ],
                      ),
                      Expanded(child: Container()),
                      customer.basket.contains(product.id)
                          ? IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.cart_fill_badge_minus,
                                color: AppColors.active_icon,
                                size: 30,
                              ))
                          : IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.cart_badge_plus,
                                color: AppColors.active_icon,
                                size: 30,
                              ))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
