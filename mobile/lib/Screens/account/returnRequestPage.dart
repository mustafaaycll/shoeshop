// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/Screens/home/sellerpage.dart';
import 'package:mobile/models/comments/comment.dart';
import 'package:mobile/models/orders/order.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/returnRequests/returnRequest.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Services/database.dart';

class ReturnPage extends StatefulWidget {
  final Seller seller;
  final String productID;
  final Order order;
  const ReturnPage({Key? key, required this.seller, required this.productID, required this.order}) : super(key: key);

  @override
  State<ReturnPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ReturnPage> {
  String? selectedReason = null;
  List<String> reasons = [
    "Size is small/big",
    "Shows wear/defect",
    "Not like in the picture above",
    "Decided not needing it",
    "Just want to return it"
  ];

  @override
  Widget build(BuildContext context) {
    Seller seller = widget.seller;
    Customer customer = Provider.of<Customer>(context);

    return StreamBuilder<Product>(
        stream: DatabaseService(id: widget.productID, ids: []).productData,
        builder: (context, snapshot) {
          Product? product = snapshot.data;
          if (product != null) {
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
                                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                /*Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton(
                                      style: ShapeRules(bg_color: AppColors.background, side_color: AppColors.background)
                                          .outlined_button_style_no_padding(),
                                      onPressed: () {
                                        pushNewScreen(context, screen: SellerPage(seller: seller));
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
                                            style: TextStyle(decoration: TextDecoration.underline, color: AppColors.body_text),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),*/
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Purchased on ${DateFormat('dd-MM-yyyy').format(widget.order.date)} from",
                                                style: TextStyle(color: AppColors.system_gray),
                                              ),
                                              OutlinedButton(
                                                style: ShapeRules(bg_color: AppColors.background, side_color: AppColors.background)
                                                    .outlined_button_style_no_padding(),
                                                onPressed: () {
                                                  pushNewScreen(context, screen: SellerPage(seller: seller));
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
                                                      style: TextStyle(decoration: TextDecoration.underline, color: AppColors.body_text),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Size: ${widget.order.size}",
                                            style: TextStyle(color: AppColors.system_gray),
                                          ),
                                          Text(
                                            "Quantity: ${widget.order.quantity}",
                                            style: TextStyle(color: AppColors.system_gray),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Please choose a reason from below",
                                            style: TextStyle(color: AppColors.system_gray),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: reasons.length,
                                            itemBuilder: (context, i) {
                                              String reason = reasons[i];
                                              return Card(
                                                child: ListTile(
                                                  leading: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedReason = reason;
                                                      });
                                                    },
                                                    icon: selectedReason == null || selectedReason != reason
                                                        ? Icon(
                                                            Icons.check_box_outline_blank,
                                                            color: AppColors.deactive_icon,
                                                          )
                                                        : Icon(
                                                            Icons.check_box,
                                                            color: AppColors.active_icon,
                                                          ),
                                                  ),
                                                  title: Text(
                                                    reason,
                                                    style: TextStyle(color: AppColors.title_text),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "${widget.order.price.toStringAsFixed(2)}₺",
                            style: TextStyle(fontSize: 25, color: AppColors.title_text),
                          ),
                          trailing: OutlinedButton.icon(
                            style: ShapeRules(
                                    bg_color: selectedReason == null ? AppColors.system_gray : AppColors.filled_button,
                                    side_color: selectedReason == null ? AppColors.system_gray : AppColors.filled_button)
                                .outlined_button_style(),
                            onPressed: () {
                              if (selectedReason != null) {
                                ReturnRequest request = ReturnRequest(
                                  id: DatabaseService(id: "", ids: []).randID(),
                                  productID: product.id,
                                  sellerID: seller.id,
                                  customerID: customer.id,
                                  orderID: widget.order.id,
                                  date: DateTime.now(),
                                  approved: false,
                                  cause: selectedReason!,
                                  price: widget.order.price,
                                );
                                DatabaseService(id: "", ids: []).createReturnRequest(request, customer, seller);
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.arrow_uturn_left_square,
                              color: AppColors.filled_button_text,
                            ),
                            label: Text("Request Return", style: TextStyle(color: AppColors.filled_button_text)),
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          } else {
            return Animations().scaffoldLoadingScreen_without_appbar();
          }
        });
  }
}
