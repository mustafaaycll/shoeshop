// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/cart/invoiceView.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
          style: TextStyle(color: AppColors.opposite_case_title_text, fontSize: h / 3),
        )),
      ),
    );
  }

  Widget namedImageBox(String name, String src, double h, double w, bool network) {
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
                      ? Image.network(
                          src,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Animations().loading();
                            }
                          },
                        )
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

  Widget ImageBoxProducts(String model, String name, String sex, double price, int amm, String src, double h, double w, bool network) {
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
                    style: TextStyle(color: AppColors.filled_button_text, fontSize: 15),
                  ),
                  Text(
                    model,
                    style: TextStyle(color: AppColors.filled_button_text, fontSize: 15),
                  ),
                  Text(
                    sex,
                    style: TextStyle(color: AppColors.filled_button_text, fontSize: 15),
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
                    style: TextStyle(color: AppColors.filled_button_text, fontSize: 15),
                  ),
                  Text(
                    'x' + amm.toString(),
                    style: TextStyle(color: AppColors.filled_button_text, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget discountedProductTile_listView(Product product, Customer customer, Seller seller, double h, double w) {
    return Container(
      height: h,
      width: w,
      child: Column(
        children: [
          Stack(children: [
            Container(
              width: w,
              height: 3 * h / 5,
              decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(product.photos[0]))),
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
                  child: Image.network(
                    seller.logo,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                customer.fav_products.contains(product.id)
                    ? IconButton(
                        onPressed: () async {
                          await DatabaseService(id: customer.id, ids: []).removeFromFavs(customer.fav_products, product.id);
                        },
                        icon: Icon(
                          CupertinoIcons.heart_fill,
                          color: AppColors.negative_button,
                          size: 30,
                        ))
                    : IconButton(
                        onPressed: () async {
                          await DatabaseService(id: customer.id, ids: []).addToFavs(customer.fav_products, product.id);
                        },
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
                          style: TextStyle(color: AppColors.background, fontSize: 11),
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
                        style: TextStyle(color: AppColors.body_text, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          product.model,
                          style: TextStyle(color: AppColors.body_text, fontSize: 15),
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
                      style: TextStyle(color: AppColors.system_gray, fontSize: 12),
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
                          Text("${((product.price * 100) / (100 - product.discount_rate)).toStringAsFixed(2)} ₺",
                              style: TextStyle(fontSize: 15, decoration: TextDecoration.lineThrough, color: AppColors.secondary_text)),
                          Text("${product.price.toStringAsFixed(2)} ₺", style: TextStyle(fontSize: 20, color: AppColors.negative_button)),
                        ],
                      ),
                      Expanded(child: Container()),
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

  Widget productTile_gridView(Product product, Customer customer, Seller seller, double height, double width) {
    double h = height / 2;
    double w = width / 2;
    return Container(
      height: h,
      width: w,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                foregroundDecoration: product.quantity == 0
                    ? BoxDecoration(
                        color: Colors.grey,
                        backgroundBlendMode: BlendMode.saturation,
                      )
                    : null,
                width: w,
                height: 6 * h / 12,
                decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(product.photos[0]))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  customer.fav_products.contains(product.id)
                      ? IconButton(
                          onPressed: () async {
                            await DatabaseService(id: customer.id, ids: []).removeFromFavs(customer.fav_products, product.id);
                          },
                          icon: Icon(
                            CupertinoIcons.heart_fill,
                            color: AppColors.negative_button,
                            size: 30,
                          ))
                      : IconButton(
                          onPressed: () async {
                            await DatabaseService(id: customer.id, ids: []).addToFavs(customer.fav_products, product.id);
                          },
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
                top: (6 * h / 12) - 20,
                child: product.discount_rate != 0 && product.quantity < 5
                    ? Row(
                        children: [
                          Container(
                            height: 20,
                            width: 40,
                            child: Center(
                              child: Text(
                                "${product.discount_rate}%",
                                style: TextStyle(color: AppColors.background),
                              ),
                            ),
                            color: AppColors.negative_button,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Container(
                            height: 20,
                            width: 80,
                            child: Center(
                              child: product.quantity != 0
                                  ? Text(
                                      "Last ${product.quantity} in stock",
                                      style: TextStyle(color: AppColors.background, fontSize: 11),
                                    )
                                  : Text(
                                      "Out-of-stock",
                                      style: TextStyle(color: AppColors.background, fontSize: 11),
                                    ),
                            ),
                            color: AppColors.negative_button,
                          )
                        ],
                      )
                    : product.discount_rate != 0 && product.quantity >= 5
                        ? Row(
                            children: [
                              Container(
                                height: 20,
                                width: 40,
                                child: Center(
                                  child: Text(
                                    "${product.discount_rate}%",
                                    style: TextStyle(color: AppColors.background),
                                  ),
                                ),
                                color: AppColors.negative_button,
                              )
                            ],
                          )
                        : product.discount_rate == 0 && product.quantity < 5
                            ? Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 80,
                                    child: Center(
                                      child: product.quantity != 0
                                          ? Text(
                                              "Last ${product.quantity} in stock",
                                              style: TextStyle(color: AppColors.background, fontSize: 11),
                                            )
                                          : Text(
                                              "Out-of-stock",
                                              style: TextStyle(color: AppColors.background, fontSize: 11),
                                            ),
                                    ),
                                    color: AppColors.negative_button,
                                  )
                                ],
                              )
                            : Container(),
              ),
            ],
          ),
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
                        style: TextStyle(color: AppColors.body_text, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          product.model,
                          style: TextStyle(color: AppColors.body_text, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    product.sex + "'s " + product.category + " shoe",
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3),
                  product.discount_rate != 0
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${((product.price * 100) / (100 - product.discount_rate)).toStringAsFixed(2)} ₺",
                                    style: TextStyle(fontSize: 15, decoration: TextDecoration.lineThrough, color: AppColors.secondary_text)),
                                Text("${product.price.toStringAsFixed(2)} ₺", style: TextStyle(fontSize: 20, color: AppColors.negative_button)),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${(product.price).toStringAsFixed(2)} ₺", style: TextStyle(fontSize: 20, color: AppColors.title_text)),
                              ],
                            ),
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

  Widget cartItem(Customer customer, Map<Product, dynamic> basket, int index, double width) {
    double height = 200;
    Product product = basket.keys.toList()[index];
    Map<dynamic, dynamic> extractedBasket = customer.basketMap;

    return Container(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    height: width / 2,
                    width: width / 2,
                    decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(product.photos[0])))),
                Positioned(
                  top: width / 2 - 50,
                  left: 0,
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            await DatabaseService(id: customer.id, ids: []).removeFromCart(customer.basketMap, product.id);
                          },
                          icon: Icon(
                            CupertinoIcons.bin_xmark,
                            color: AppColors.negative_button,
                          )),
                      SizedBox(
                        width: 45,
                      ),
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            if (extractedBasket[product.id][0] > 1) {
                              await DatabaseService(id: customer.id, ids: []).decreaseAmount(extractedBasket, product.id);
                            }
                          },
                          icon: Icon(
                            CupertinoIcons.minus,
                            color: extractedBasket[product.id][0] > 1 ? AppColors.active_icon : AppColors.system_gray,
                          )),
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            dynamic available = product.sizesMap[extractedBasket[product.id][1].toString()] as int;
                            if (extractedBasket[product.id][0] < available) {
                              await DatabaseService(id: customer.id, ids: []).increaseAmount(extractedBasket, product.id);
                            }
                          },
                          icon: Icon(
                            CupertinoIcons.plus,
                            color: (extractedBasket[product.id][0] < product.sizesMap[extractedBasket[product.id][1].toString()])
                                ? AppColors.active_icon
                                : AppColors.system_gray,
                          )),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    product.name,
                    style: TextStyle(color: AppColors.title_text, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.model,
                    style: TextStyle(color: AppColors.title_text, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.sex + "'s " + product.category + " shoe",
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Quantity: " + extractedBasket[product.id][0].toString(),
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    "Size: " + extractedBasket[product.id][1].toString(),
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.warranty ? "Warranty: Yes" : "Warranty: No",
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(child: Container()),
                  Text("${getIndividualPriceForCartItem(product, basket).toStringAsFixed(2)} ₺",
                      style: TextStyle(color: AppColors.title_text, fontSize: 20)),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cartItem_withoutButtons(Customer customer, Map<Product, dynamic> basket, int index, double width) {
    double height = 200;
    Product product = basket.keys.toList()[index];
    Map<dynamic, dynamic> extractedBasket = customer.basketMap;

    return Container(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: width / 2,
                width: width / 2,
                decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(product.photos[0])))),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    product.name,
                    style: TextStyle(color: AppColors.title_text, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.model,
                    style: TextStyle(color: AppColors.title_text, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.sex + "'s " + product.category + " shoe",
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Quantity: " + extractedBasket[product.id][0].toString(),
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    "Size: " + extractedBasket[product.id][1].toString(),
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.warranty ? "Warranty: Yes" : "Warranty: No",
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(child: Container()),
                  Text("${getIndividualPriceForCartItem(product, basket).toStringAsFixed(2)} ₺",
                      style: TextStyle(color: AppColors.title_text, fontSize: 20)),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget wishlistItem(Customer customer, List<Product> wishlistItems, int index, double width) {
    double height = 200;
    Product product = wishlistItems[index];

    return Container(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    foregroundDecoration: product.quantity == 0
                        ? BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.saturation,
                          )
                        : null,
                    height: width / 2,
                    width: width / 2,
                    decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(product.photos[0])))),
                Positioned(
                  top: width / 2 - 50,
                  left: 0,
                  child: Row(
                    children: [
                      IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () async {
                            await DatabaseService(id: customer.id, ids: []).removeFromFavs(customer.fav_products, product.id);
                          },
                          icon: Icon(
                            CupertinoIcons.bin_xmark,
                            color: AppColors.negative_button,
                          )),
                      SizedBox(
                        width: 45,
                      ),
                      product.quantity == 0
                          ? Container(
                              height: 20,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "Out-of-stock",
                                  style: TextStyle(color: AppColors.background, fontSize: 11),
                                ),
                              ),
                              color: AppColors.negative_button,
                            )
                          : product.quantity < 5
                              ? Container(
                                  height: 20,
                                  width: 80,
                                  child: Center(
                                      child: Text(
                                    "Last ${product.quantity} in stock",
                                    style: TextStyle(color: AppColors.background, fontSize: 11),
                                  )),
                                  color: AppColors.negative_button,
                                )
                              : Container(),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    product.name,
                    style: TextStyle(color: AppColors.title_text, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.model,
                    style: TextStyle(color: AppColors.title_text, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.sex + "'s " + product.category + " shoe",
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    product.warranty ? "Warranty: Yes" : "Warranty: No",
                    style: TextStyle(color: AppColors.system_gray, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(child: Container()),
                  Text("${getIndividualPriceForWishlistItem(product).toStringAsFixed(2)} ₺",
                      style: TextStyle(color: AppColors.title_text, fontSize: 20)),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget failedToAddToCart() {
    return AlertDialog(
        backgroundColor: AppColors.background,
        scrollable: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.cube_box,
                  color: AppColors.negative_button,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "No more left",
                  style: TextStyle(color: AppColors.negative_button, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "all available stock is in your cart",
                  style: TextStyle(color: AppColors.title_text, fontSize: 15),
                ),
              ],
            ),
          ],
        ));
  }

  Widget addedToCart() {
    return AlertDialog(
        backgroundColor: AppColors.background,
        scrollable: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.cart,
                  color: AppColors.positive_button,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Added to your cart",
                  style: TextStyle(color: AppColors.positive_button, fontSize: 20),
                ),
              ],
            ),
          ],
        ));
  }

  Widget orderReceived(BuildContext context, String pdfName) {
    return AlertDialog(
        backgroundColor: AppColors.background,
        scrollable: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.cube_box,
                  color: AppColors.title_text,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Order received",
                  style: TextStyle(color: AppColors.title_text, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Text(
                  "Thank you for your purchase",
                  style: TextStyle(color: AppColors.title_text, fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ShapeRules(bg_color: AppColors.filled_button, side_color: AppColors.filled_button).outlined_button_style(),
                    onPressed: () async {
                      String url = await DatabaseService(id: pdfName, ids: []).getPdfURL();
                      Navigator.pop(context);
                      pushNewScreen(context, screen: InvoiceView(pdfName: pdfName, url: url));
                    },
                    child: Text(
                      "View Invoice",
                      style: TextStyle(color: AppColors.filled_button_text),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

double getIndividualPriceForCartItem(Product product, Map<Product, dynamic> basket) {
  double price = 0;
  basket.forEach((key, value) {
    if (key.id == product.id) {
      price = product.price * value[0];
    }
  });

  return price;
}

double getIndividualPriceForWishlistItem(Product product) {
  double price = product.price;
  return price;
}
