class Customer {
  final String id;
  final String fullname;
  final String email;
  final String method;
  final List<dynamic> fav_products;
  final List<dynamic> addresses;
  final List<dynamic> amounts;
  final List<dynamic> basket;
  final Map<dynamic, dynamic> basketMap;
  final List<dynamic> prev_orders;
  final String tax_id;
  final List<dynamic> credit_cards;

  Customer(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.method,
      required this.fav_products,
      required this.addresses,
      required this.amounts,
      required this.basket,
      required this.basketMap,
      required this.prev_orders,
      required this.tax_id,
      required this.credit_cards});
}
