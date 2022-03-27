import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff5f3f5),
        elevation: 0,
        title: Text(
          'CART',
          style: TextStyle(color: Color(0xff1b264f), fontSize: 30),
        ),
      ),
      body: Container(color: Color(0xfff5f3f5)),
    );
  }
}
