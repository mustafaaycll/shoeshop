class Comment {
  final String id;
  final String customerID;
  final String productID;
  final String sellerID;
  final String comment;
  final int rating;
  final bool approved;
  final DateTime date;

  Comment({
    required this.id,
    required this.customerID,
    required this.productID,
    required this.sellerID,
    required this.comment,
    required this.rating,
    required this.approved,
    required this.date,
  });
}
