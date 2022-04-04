import 'package:flutter/material.dart';

class ShapeRules {
  final Color bg_color;
  final Color side_color;

  ShapeRules({required this.bg_color, required this.side_color});

  ButtonStyle outlined_button_style() {
    return OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      backgroundColor: bg_color,
      side: BorderSide(color: side_color),
    );
  }

  ButtonStyle outlined_button_style_no_padding() {
    return OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: bg_color,
        side: BorderSide(color: side_color),
        padding: EdgeInsets.all(0));
  }
}

class Dimen {
  static const double parentMargin = 16.0;
  static const double regularMargin = 8.0;
  static const double largeMargin = 20.0;

  static get regularPadding => EdgeInsets.all(parentMargin);

  static get largePadding => EdgeInsets.all(largeMargin);
}
