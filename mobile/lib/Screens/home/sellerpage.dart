import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/objects.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

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

class _SellerPageState extends State<SellerPage>
    with AfterLayoutMixin<SellerPage> {
  GlobalKey _keyGridView = GlobalKey();
  GlobalKey _keyRow1 = GlobalKey();
  GlobalKey _keyRow2 = GlobalKey();
  GlobalKey _keyCol = GlobalKey();

  Size gridSize = Size(0, 0);
  final StreamController _streamCtrl = StreamController.broadcast();
  Stream get onVariableChanged => _streamCtrl.stream;

  @override
  void afterFirstLayout(BuildContext context) {
    sleep(Duration(milliseconds: 100));
    updateUI();
  }

  Future<void> updateUI() async {
    RenderBox? renderBoxTotal =
        _keyCol.currentContext!.findRenderObject() as RenderBox;
    RenderBox? renderBoxR1 =
        _keyRow1.currentContext!.findRenderObject() as RenderBox;
    RenderBox? renderBoxR2 =
        _keyRow2.currentContext!.findRenderObject() as RenderBox;
    double colH = renderBoxTotal!.size.height -
        renderBoxR1!.size.height -
        renderBoxR2!.size.height;
    double colW = renderBoxTotal.size.width;
    _streamCtrl.sink.add(Size(colW, colH));
  }

  @override
  Widget build(BuildContext context) {
    Seller seller = widget.seller;
    Customer customer = Provider.of<Customer>(context);
    return StreamBuilder<List<Product>>(
        stream: DatabaseService(id: "", ids: seller.products).specifiedProducts,
        builder: (context, snapshot) {
          List<Product>? products = snapshot.data;
          if (products != null) {
            return StreamBuilder(
                stream: onVariableChanged,
                builder: (context, snapshot) {
                  return Scaffold(
                    backgroundColor: AppColors.opposite_case_background,
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
                          key: _keyCol,
                          children: [
                            Container(
                              color: Colors.red,
                              child: Row(
                                key: _keyRow1,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      leading: Image.network(seller.logo),
                                      title: Text(
                                        seller.name,
                                        style: TextStyle(
                                            fontSize: 35,
                                            color: AppColors.title_text),
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
                                            style: TextStyle(
                                                color: AppColors.system_gray),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.red,
                              child: Row(
                                key: _keyRow2,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /*Text(
                                  "Products from ${seller.name}",
                                  style: TextStyle(color: AppColors.system_gray),
                                ),*/
                                  Expanded(child: Container()),
                                  TextButton(
                                    onPressed: () {
                                      print(_getSizeOfWidget(_keyCol)
                                          .height
                                          .toString());
                                      updateUI();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                            CupertinoIcons
                                                .line_horizontal_3_decrease_circle,
                                            size: 18,
                                            color: AppColors.secondary_text),
                                        SizedBox(width: 2),
                                        Text(
                                          "Sort by",
                                          style: TextStyle(
                                              color: AppColors.secondary_text),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            !snapshot.hasData
                                ? Expanded(child: Container())
                                : Expanded(
                                    child: GridView.count(
                                        key: _keyGridView,
                                        crossAxisCount: 2,
                                        primary: true,
                                        childAspectRatio: 0.75,
                                        children: List.generate(products.length,
                                            (index) {
                                          //print(_getSizeOfWidget(_keyGridView).height);
                                          return OutlinedButton(
                                            style: ShapeRules(
                                                    bg_color:
                                                        AppColors.empty_button,
                                                    side_color: AppColors
                                                        .empty_button_border)
                                                .outlined_button_style_no_padding(),
                                            onPressed: () {},
                                            child: QuickObjects()
                                                .productTile_gridView(
                                                    products[index],
                                                    customer,
                                                    seller,
                                                    snapshot.data),
                                          );
                                        })))
                          ],
                        )),
                  );
                });
          } else {
            return Animations().scaffoldLoadingScreen_without_appbar();
          }
        });
  }
}
