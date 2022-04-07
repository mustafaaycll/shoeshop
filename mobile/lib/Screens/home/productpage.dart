import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final Seller seller;
  final Product product;
  const ProductPage({Key? key, required this.seller, required this.product})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          SizedBox(
                            height:
                                constraints.heightConstraints().maxHeight / 2,
                            width: constraints.widthConstraints().maxWidth,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: product.photos.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: constraints
                                          .heightConstraints()
                                          .maxHeight /
                                      2,
                                  width:
                                      constraints.widthConstraints().maxWidth,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
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
                                    customer.fav_products.contains(product.id)
                                        ? IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              CupertinoIcons.heart_fill,
                                              color: AppColors.negative_button,
                                              size: 40,
                                            ))
                                        : IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              CupertinoIcons.heart,
                                              color: AppColors.negative_button,
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
              ],
            ),
          ),
        ));
  }
}
