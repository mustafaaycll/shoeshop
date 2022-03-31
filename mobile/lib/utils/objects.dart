import 'package:flutter/material.dart';
import 'package:mobile/utils/colors.dart';

class QuickObjects {
  String getInitials(String text) {
    List<String> words = text.split(" ");
    String strToReturn = "";

    for (var i = 0; i < words.length; i++) {
      strToReturn = strToReturn + words[i][0];
    }

    return strToReturn;
  }

  Widget profilePicture(String fullname, double h, double w) {
    return SizedBox(
      height: h,
      width: w,
      child: Card(
        color: AppColors.opposite_case_filled_button,
        elevation: 0,
        child: Center(
            child: Text(
          getInitials(fullname),
          style: TextStyle(
              color: AppColors.opposite_case_title_text, fontSize: h / 3),
        )),
      ),
    );
  }
}
