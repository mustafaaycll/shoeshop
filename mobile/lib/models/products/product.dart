import 'package:flutter/material.dart';

class Product {
  final String id;
  final String distributor_information;
  final String name;
  final String model;
  final String category;
  final String color;
  final String description;
  final String sex;
  final double price;
  final int quantity;
  final int discount_rate;
  final bool warranty;
  final List<dynamic> comments;
  final Map<dynamic, dynamic> sizesMap;
  final List<dynamic> photos;
  final List<dynamic> ratings;
  final double averageRate;

  Product({
    required this.id,
    required this.distributor_information,
    required this.name,
    required this.model,
    required this.category,
    required this.color,
    required this.description,
    required this.sex,
    required this.price,
    required this.quantity,
    required this.discount_rate,
    required this.warranty,
    required this.comments,
    required this.sizesMap,
    required this.photos,
    required this.ratings,
    required this.averageRate,
  });
}
