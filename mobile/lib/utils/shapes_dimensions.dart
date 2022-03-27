import 'package:flutter/material.dart';

import 'colors.dart';

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
}
