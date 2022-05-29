class ReturnRequest {
  final String id;
  final String productID;
  final String sellerID;
  final String customerID;
  final String orderID;
  final DateTime date;
  final bool approved;
  final bool rejected;
  final String cause;
  final double price;

  ReturnRequest(
      {required this.id,
      required this.productID,
      required this.sellerID,
      required this.customerID,
      required this.orderID,
      required this.date,
      required this.approved,
      required this.rejected,
      required this.cause,
      required this.price});
}
