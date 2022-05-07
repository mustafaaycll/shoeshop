// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/models/comments/comment.dart';
import 'package:mobile/models/orders/order.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Services/database.dart';

class RatePage extends StatefulWidget {
  final Seller seller;
  final Product product;
  final Order order;
  const RatePage({Key? key, required this.seller, required this.product, required this.order}) : super(key: key);

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  String? comment = "";
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    Seller seller = widget.seller;
    Product product = widget.product;
    Order order = widget.order;
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
                                    child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: product.photos.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(product.photos[index]))),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    top: 10,
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width - 16,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            Expanded(child: Container()),
                                            SizedBox(width: 20)
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
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "${product.name + " " + product.model}",
                                  style: TextStyle(fontSize: 30, color: AppColors.title_text),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              initialRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (val) {
                                rating = val.toInt();
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Tap here to enter comment",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.7),
                                  width: 2.0,
                                ),
                              )),
                          validator: (value) {},
                          onSaved: (value) {
                            setState(() {
                              comment = value;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              comment = value;
                            });
                          },
                          maxLines: 5,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: OutlinedButton(
                              style: ShapeRules(bg_color: AppColors.filled_button, side_color: AppColors.filled_button).outlined_button_style(),
                              onPressed: () {
                                if (rating != 0 && comment != "") {
                                  Comment commentObject = Comment(
                                    id: DatabaseService(id: "", ids: []).randID(),
                                    productID: product.id,
                                    sellerID: seller.id,
                                    customerID: customer.id,
                                    comment: comment!,
                                    rating: rating,
                                    approved: false,
                                    date: DateTime.now(),
                                  );
                                  DatabaseService(id: "", ids: []).createNewComment(commentObject);
                                  DatabaseService(id: seller.id, ids: []).addRatingToSeller(seller.ratings, rating);
                                  DatabaseService(id: product.id, ids: []).addCommentToProduct(product.comments, commentObject.id);
                                  DatabaseService(id: order.id, ids: []).updateRateInfoOfOrder(true);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Give Rate", style: TextStyle(color: AppColors.filled_button_text)),
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

List<dynamic> getAvailableSizes(Map<dynamic, dynamic> map) {
  List<dynamic> sizes = [];

  map.forEach((key, value) {
    if (value != 0) {
      sizes.add(key);
    }
  });
  sizes.sort(
    (a, b) => a.compareTo(b),
  );
  return sizes;
}

Map<dynamic, dynamic> getAvailableSizesAsMap(Map<dynamic, dynamic> map) {
  Map<dynamic, dynamic> sizes = {};
  List<dynamic> keys = map.keys.toList();
  keys.sort(
    (a, b) => a.compareTo(b),
  );
  int index = 0;
  for (var i = 0; i < keys.length; i++) {
    map.forEach((key, value) {
      if (key == keys[i] && value != 0) {
        sizes[key] = value;
      }
    });
  }

  return sizes;
}
