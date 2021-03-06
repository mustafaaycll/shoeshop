// ignore_for_file: prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:mobile/Screens/Authentication/login.dart';
import 'package:mobile/Screens/account/account.dart';
import 'package:mobile/Screens/cart/cart.dart';
import 'package:mobile/Screens/home/home.dart';
import 'package:mobile/Screens/wishlist/wishlist.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/colors.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final SharedPreferences? prefs;
  const NavBar({Key? key, required this.prefs}) : super(key: key);
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  List<Widget> _buildScreens() {
    return [Home(analytics: analytics, observer: observer), Cart(prefs: widget.prefs), Wishlist(), Account()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: Color(0xff1b264f),
        inactiveColorPrimary: Color(0xff576ca8),
      ),
      PersistentBottomNavBarItem(
        icon: IconBadge(
          icon: Icon(CupertinoIcons.cart),
          itemCount: 0,
          badgeColor: AppColors.negative_button,
          itemColor: AppColors.opposite_case_title_text,
          hideZero: true,
        ),
        title: ("Cart"),
        activeColorPrimary: Color(0xff1b264f),
        inactiveColorPrimary: Color(0xff576ca8),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.heart),
        title: ("Wishlist"),
        activeColorPrimary: Color(0xff1b264f),
        inactiveColorPrimary: Color(0xff576ca8),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Account"),
        activeColorPrimary: Color(0xff1b264f),
        inactiveColorPrimary: Color(0xff576ca8),
      ),
    ];
  }

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user != null) {
      return StreamProvider<Customer?>.value(
          initialData: null,
          value: DatabaseService(id: user.uid, ids: []).customerData,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                systemNavigationBarColor: AppColors.background,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.transparent),
            child: PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Color(0xfff5f3f5),
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              hideNavigationBarWhenKeyboardShows: true,
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Color(0xfff5f3f5),
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style12,
            ),
          ));
    } else {
      return Login(prefs: widget.prefs);
    }
  }
}
