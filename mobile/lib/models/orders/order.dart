class Order {
  final String id;
  final String customerID;
  final String sellerID;
  final String productID;
  final String address;
  final String status;
  final String size;
  final double price;
  final int quantity;
  final DateTime date;
  final bool rated;
  final String returnID;

  Order(
      {required this.id,
      required this.customerID,
      required this.sellerID,
      required this.productID,
      required this.address,
      required this.status,
      required this.size,
      required this.price,
      required this.quantity,
      required this.date,
      required this.rated,
      required this.returnID});
}
