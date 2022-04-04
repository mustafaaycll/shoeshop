import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/test.dart';
import 'package:mobile/Services/authentication.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../models/users/customer.dart';
import '../utils/shapes_dimensions.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    Customer? customer = Provider.of<Customer?>(context);
    if (customer != null) {
      return StreamBuilder<List<Product>>(
        stream: null,
        builder: ((context, snapshot) {
          return StreamBuilder<List<Product>>(
              stream: DatabaseService(id: "", ids: []).allProducts,
              builder: (context, snapshot) {
                List<Product>? allProducts = snapshot.data;
                return Scaffold(
                    backgroundColor: AppColors.background,
                    appBar: AppBar(
                      backgroundColor: AppColors.background,
                      elevation: 0,
                      title: Text(
                        'HOME',
                        style: TextStyle(
                            color: AppColors.title_text, fontSize: 30),
                      ),
                    ),
                    body: Container(
                      color: AppColors.background,
                    ));
              });
        }),
      );
    } else {
      return Animations().scaffoldLoadingScreen('HOME');
    }
  }
}
