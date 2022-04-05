class Product {
  final String id;
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
  final List<dynamic> sizes;
  final List<dynamic> photos;

  Product({
    required this.id,
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
    required this.sizes,
    required this.photos,
  });
}
