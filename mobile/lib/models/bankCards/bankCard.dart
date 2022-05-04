class BankCard {
  final String id;
  final String holderID;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;

  BankCard({
    required this.id,
    required this.holderID,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
  });
}
