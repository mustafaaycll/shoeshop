// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/orders/order.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:mobile/utils/objects.dart';
import 'package:mobile/utils/shapes_dimensions.dart';
import 'package:provider/provider.dart';

class PrevOrdersPage extends StatefulWidget {
  const PrevOrdersPage({Key? key}) : super(key: key);

  @override
  State<PrevOrdersPage> createState() => _PrevOrdersPageState();
}

class _PrevOrdersPageState extends State<PrevOrdersPage> {
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      List<dynamic> orderIDs = customer.prev_orders;
      List<String> separatedIDs = separateEachIDs(orderIDs);
      return StreamBuilder<List<Order>>(
        stream: DatabaseService(id: "", ids: separatedIDs).specifiedOrders,
        builder: (context, snapshot) {
          List<Order>? separatedOrders = snapshot.data;
          if (separatedOrders != null) {
            Map<dynamic, List<Order>> orderMap = uniteIDs(orderIDs, separatedOrders);
            var sortedKeys = orderMap.keys.toList(growable: false)..sort((k1, k2) => orderMap[k2]![0].date.compareTo(orderMap[k1]![0].date));
            Map<dynamic, List<Order>?> orderMapSorted = Map<dynamic, List<Order>?>.fromIterable(sortedKeys, key: (k) => k, value: (k) => orderMap[k]);

            return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: AppColors.title_text,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: orderMapSorted.keys.toList().length,
                    itemBuilder: (context, i) {
                      dynamic key = orderMapSorted.keys.toList()[i];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: OutlinedButton(
                            onPressed: () {},
                            style: ShapeRules(bg_color: AppColors.empty_button, side_color: AppColors.empty_button_border)
                                .outlined_button_style_no_padding(),
                            child: QuickObjects().prevOrderItem(context, orderMapSorted[key], MediaQuery.of(context).size.width - 12, customer)),
                      );
                    },
                  ),
                ));
          } else {
            return Animations().scaffoldLoadingScreen_without_appbar();
          }
        },
      );
    } else {
      return Animations().scaffoldLoadingScreen_without_appbar();
    }
  }
}

List<String> separateEachIDs(List<dynamic> orderIDs) {
  List<String> separated = [];
  for (var i = 0; i < orderIDs.length; i++) {
    List<String> splitted = orderIDs[i].split('-');
    for (var item in splitted) {
      separated.add(item);
    }
  }
  return separated;
}

Map<dynamic, List<Order>> uniteIDs(List<dynamic> orderIDs, List<Order> separatedOrders) {
  Map<dynamic, List<Order>> unitedIDs = {};
  for (var unitedID in orderIDs) {
    List<String> idsInOrder = unitedID.split('-');
    List<Order> correspondingOrders = [];
    for (var id in idsInOrder) {
      for (var order in separatedOrders) {
        if (order.id == id) {
          correspondingOrders.add(order);
        }
      }
    }
    unitedIDs[unitedID] = correspondingOrders;
  }

  return unitedIDs;
}
