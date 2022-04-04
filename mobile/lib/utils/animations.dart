import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'colors.dart';

class Animations {
  Widget scaffoldLoadingScreen(String appbarname) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          appbarname,
          style: TextStyle(color: AppColors.title_text, fontSize: 30),
        ),
      ),
      body: Center(
        child: SpinKitFadingCircle(color: AppColors.spinner, size: 50.0),
      ),
    );
  }

  Widget loading() {
    return SpinKitFadingCircle(color: AppColors.spinner, size: 50.0);
  }

  Widget scaffoldLoadingScreen_opposite_case(String appbarname) {
    return Scaffold(
      backgroundColor: AppColors.opposite_case_background,
      appBar: AppBar(
        backgroundColor: AppColors.opposite_case_background,
        elevation: 0,
        title: Text(
          appbarname,
          style: TextStyle(
              color: AppColors.opposite_case_title_text, fontSize: 30),
        ),
      ),
      body: Center(
        child: SpinKitFadingCircle(
            color: AppColors.opposite_case_spinner, size: 50.0),
      ),
    );
  }

  Widget scaffoldLoadingScreen_opposite_case_without_appbar() {
    return Scaffold(
      backgroundColor: AppColors.opposite_case_background,
      body: Center(
        child: SpinKitFadingCircle(
            color: AppColors.opposite_case_spinner, size: 50.0),
      ),
    );
  }
}
