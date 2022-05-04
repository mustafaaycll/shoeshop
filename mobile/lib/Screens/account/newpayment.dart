import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:mobile/Services/database.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/colors.dart';

class NewPaymentOption extends StatefulWidget {
  final Customer customer;
  const NewPaymentOption({Key? key, required this.customer}) : super(key: key);

  @override
  State<NewPaymentOption> createState() => _NewPaymentOptionState();
}

class _NewPaymentOptionState extends State<NewPaymentOption> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  OutlineInputBorder? border;
  final _formKeyCard = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(
            color: AppColors.title_text,
          ),
        ),
        body: Column(children: [
          CreditCardWidget(
            isChipVisible: false,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            cardBgColor: Colors.red,
            backgroundImage: 'assets/bg_card.jpg',
            isSwipeGestureEnabled: true,
            onCreditCardWidgetChange: (creditCardBrand) {},
            customCardTypeIcons: <CustomCardTypeIcon>[
              CustomCardTypeIcon(
                cardType: CardType.mastercard,
                cardImage: Image.asset(
                  'assets/mastercard.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: _formKeyCard,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    themeColor: Colors.blue,
                    textColor: AppColors.title_text,
                    cardNumberDecoration: InputDecoration(
                      labelText: 'Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                      hintStyle: TextStyle(color: AppColors.title_text),
                      labelStyle: TextStyle(color: AppColors.title_text),
                      focusedBorder: border,
                      enabledBorder: border,
                    ),
                    expiryDateDecoration: InputDecoration(
                      hintStyle: TextStyle(color: AppColors.title_text),
                      labelStyle: TextStyle(color: AppColors.title_text),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: 'Expired Date',
                      hintText: 'XX/XX',
                    ),
                    cvvCodeDecoration: InputDecoration(
                      hintStyle: TextStyle(color: AppColors.title_text),
                      labelStyle: TextStyle(color: AppColors.title_text),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: InputDecoration(
                      hintStyle: TextStyle(color: AppColors.title_text),
                      labelStyle: TextStyle(color: AppColors.title_text),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: 'Card Holder',
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      primary: AppColors.filled_button,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: Text(
                        'Add New Card',
                        style: TextStyle(
                          color: AppColors.filled_button_text,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKeyCard.currentState!.validate()) {
                        Navigator.pop(context);
                        DatabaseService(id: widget.customer.id, ids: [])
                            .createNewPaymentMethod(cvvCode, expiryDate, cardHolderName, cardNumber, widget.customer);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
