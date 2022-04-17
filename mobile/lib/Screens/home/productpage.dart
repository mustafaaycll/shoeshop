import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/home/sellerpage.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../Services/database.dart';

class ProductPage extends StatefulWidget {
  final Seller seller;
  final Product product;
  const ProductPage({Key? key, required this.seller, required this.product})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<int> nums = [35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47];
  @override
  Widget build(BuildContext context) {
    Seller seller = widget.seller;
    Product product = widget.product;
    Customer customer = Provider.of<Customer>(context);
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: (3 * MediaQuery.of(context).size.height) / 8,
                          width: MediaQuery.of(context).size.width - 16,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    height: constraints
                                        .heightConstraints()
                                        .maxHeight,
                                    width:
                                        constraints.widthConstraints().maxWidth,
                                    child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: product.photos.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: constraints
                                                  .heightConstraints()
                                                  .maxHeight /
                                              2,
                                          width: constraints
                                              .widthConstraints()
                                              .maxWidth,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      product.photos[index]))),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    top: 10,
                                    child: Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  CupertinoIcons.chevron_back,
                                                  color: AppColors.title_text,
                                                  size: 40,
                                                )),
                                            customer.fav_products
                                                    .contains(product.id)
                                                ? IconButton(
                                                    onPressed: () async {
                                                      await DatabaseService(
                                                              id: customer.id,
                                                              ids: [])
                                                          .removeFromFavs(
                                                              customer
                                                                  .fav_products,
                                                              product.id);
                                                    },
                                                    icon: Icon(
                                                      CupertinoIcons.heart_fill,
                                                      color: AppColors
                                                          .negative_button,
                                                      size: 40,
                                                    ))
                                                : IconButton(
                                                    onPressed: () async {
                                                      await DatabaseService(
                                                              id: customer.id,
                                                              ids: [])
                                                          .addToFavs(
                                                              customer
                                                                  .fav_products,
                                                              product.id);
                                                    },
                                                    icon: Icon(
                                                      CupertinoIcons.heart,
                                                      color: AppColors
                                                          .negative_button,
                                                      size: 40,
                                                    )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: ShapeRules(
                                      bg_color: AppColors.background,
                                      side_color: AppColors.background)
                                  .outlined_button_style_no_padding(),
                              onPressed: () {
                                pushNewScreen(context,
                                    screen: SellerPage(seller: seller));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.network(seller.logo),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${seller.name}",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: AppColors.body_text),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: OutlinedButton(
                                style: ShapeRules(
                                        bg_color: AppColors.background,
                                        side_color: AppColors.background)
                                    .outlined_button_style_no_padding(),
                                onPressed: () {},
                                child: Text(
                                  "Comments",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: AppColors.body_text),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "${product.name + " " + product.model}",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: AppColors.title_text),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "${product.description}",
                                  style: TextStyle(
                                      fontSize: 15, color: AppColors.body_text),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Warranty: ${product.warranty ? 'Yes' : 'No'}",
                                style: TextStyle(color: AppColors.system_gray),
                              ),
                              Text(
                                "Amount in Stock: ${product.quantity}",
                                style: TextStyle(color: AppColors.system_gray),
                              ),
                              Text(
                                "Available Sizes: ${product.sizes.join(", ")}",
                                style: TextStyle(color: AppColors.system_gray),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: product.discount_rate > 0
                      ? Container(
                          height: 50,
                          width: 50,
                          color: AppColors.negative_button,
                          child: Center(
                              child: Text(
                            "${product.discount_rate}%",
                            style: TextStyle(
                                color: AppColors.background, fontSize: 15),
                          )),
                        )
                      : null,
                  title: Text(
                    "${product.price.toStringAsFixed(2)}₺",
                    style: TextStyle(
                        fontSize: 25,
                        color: product.discount_rate > 0
                            ? AppColors.negative_button
                            : AppColors.title_text),
                  ),
                  subtitle: product.discount_rate > 0
                      ? Text(
                          "${((product.price * 100) / (100 - product.discount_rate)).toStringAsFixed(2)}₺",
                          style: TextStyle(
                            color: AppColors.secondary_text,
                            decoration: TextDecoration.lineThrough,
                          ),
                        )
                      : null,
                  trailing: OutlinedButton.icon(
                    style: ShapeRules(
                            bg_color: AppColors.filled_button,
                            side_color: AppColors.filled_button)
                        .outlined_button_style(),
                    onPressed: () async {
                      await DatabaseService(id: customer.id, ids: []).addToCart(
                          customer.amounts, customer.basket, product.id);
                    },
                    icon: Icon(
                      CupertinoIcons.cart_badge_plus,
                      color: AppColors.filled_button_text,
                    ),
                    label: Text("Add to Cart",
                        style: TextStyle(color: AppColors.filled_button_text)),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
