import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:mobile/models/users/customer.dart';

class DatabaseService {
  final String id;
  final List<dynamic> ids;

  DatabaseService({required this.id, required this.ids});

  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customers');

  customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    return customer(
      id: id,
      fullname: snapshot.get('fullname'),
      email: snapshot.get('email'),
      method: snapshot.get('method'),
      fav_products: snapshot.get('fav_products'),
      addresses: snapshot.get('addresses'),
      amounts: snapshot.get('amounts'),
      basket: snapshot.get('basket'),
      prev_orders: snapshot.get('prev_orders'),
      tax_id: snapshot.get('tax_id'),
      credit_cards: snapshot.get('credit_cards'),
    );
  }

  Stream<customer> get customerData {
    return customerCollection
        .doc(id)
        .snapshots()
        .map(_customerDataFromSnapshot);
  }

  Future addCustomer(String? fullname, String? email, String method) async {
    List<String> emptyList = [''];

    await customerCollection
        .doc(id)
        .set({
          'id': id,
          'fullname': fullname,
          'email': email,
          'method': method,
          'fav_products': emptyList,
          'addresses': emptyList,
          'amounts': [0],
          'basket': emptyList,
          'prev_orders': emptyList,
          'tax_id': "",
          'credit_cards': emptyList,
        })
        .then((value) => print('Customer Added'))
        .catchError(
            (error) => print('Adding customer failed ${error.toString()}'));
  }
}
