import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Screens/test.dart';
import 'package:mobile/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../utils/shapes_dimensions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'HOME',
          style: TextStyle(color: AppColors.title_text, fontSize: 30),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                style: ShapeRules(
                        bg_color: AppColors.empty_button,
                        side_color: AppColors.empty_button_border)
                    .outlined_button_style(),
                onPressed: () async {
                  pushNewScreen(context, screen: Test());
                },
                child: Text(
                  "Test Push/Pop",
                  style: TextStyle(color: AppColors.empty_button_text),
                )),
            OutlinedButton(
                style: ShapeRules(
                  bg_color: AppColors.filled_button,
                  side_color: AppColors.filled_button_border,
                ).outlined_button_style(),
                onPressed: () async {},
                child: Text(
                  "Add to Cart",
                  style: TextStyle(color: AppColors.filled_button_text),
                )),
            OutlinedButton(
                style: ShapeRules(
                  bg_color: AppColors.positive_button,
                  side_color: AppColors.positive_button_border,
                ).outlined_button_style(),
                onPressed: () async {},
                child: Text(
                  "Checkout",
                  style: TextStyle(color: AppColors.filled_button_text),
                )),
            OutlinedButton(
                style: ShapeRules(
                  bg_color: AppColors.negative_button,
                  side_color: AppColors.negative_button_border,
                ).outlined_button_style(),
                onPressed: () async {},
                child: Text(
                  "Log Out",
                  style: TextStyle(color: AppColors.filled_button_text),
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.heart,
                  color: AppColors.deactive_icon,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.heart_fill,
                  color: AppColors.fav_icon,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.cart_badge_plus,
                  color: AppColors.deactive_icon,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.cart_fill,
                  color: AppColors.active_icon,
                )),
            SizedBox(
              height: 10,
            ),
            Icon(
              CupertinoIcons.book_fill,
              color: AppColors.nonclickable_icon,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Our shoes are not like other shoes which are shoes that get old and become old shoes in shoe-rt time. We shoe-rly recommend you to buy our shoes for looking more sump-shoe-s",
                style: TextStyle(color: AppColors.body_text),
              ),
            )
          ],
        ),
      ),
    );
  }
}
