class customer {
  final String id;
  final String fullname;
  final String email;
  final String method;
  final List<dynamic> fav_products;
  final List<dynamic> addresses;
  final List<dynamic> amounts;
  final List<dynamic> basket;
  final List<dynamic> prev_orders;
  final List<dynamic> tax_id;
  final List<dynamic> credit_cards;

  customer(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.method,
      required this.fav_products,
      required this.addresses,
      required this.amounts,
      required this.basket,
      required this.prev_orders,
      required this.tax_id,
      required this.credit_cards});
}
