import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:mobile/Services/invoice.dart';
import 'package:mobile/models/bankCards/bankCard.dart';
import 'package:mobile/models/orders/order.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';

import '../models/products/product.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String id;
  final List<dynamic> ids;

  DatabaseService({required this.id, required this.ids});

  final CollectionReference customerCollection = FirebaseFirestore.instance.collection('customers');
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');
  final CollectionReference sellerCollection = FirebaseFirestore.instance.collection('sellers');
  final CollectionReference cardCollection = FirebaseFirestore.instance.collection('cards');
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('orders');

  final Reference firebaseStorageRef = FirebaseStorage.instance.ref();

  String randID() {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String randID = String.fromCharCodes(Iterable.generate(28, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return randID;
  }

  /*--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--*/
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
      id: id,
      fullname: snapshot.get('fullname'),
      email: snapshot.get('email'),
      method: snapshot.get('method'),
      fav_products: snapshot.get('fav_products'),
      addresses: snapshot.get('addresses'),
      basketMap: snapshot.get('basketMap'),
      prev_orders: snapshot.get('prev_orders'),
      tax_id: snapshot.get('tax_id'),
      credit_cards: snapshot.get('credit_cards'),
    );
  }

  Stream<Customer> get customerData {
    return customerCollection.doc(id).snapshots().map(_customerDataFromSnapshot);
  }

  Future addCustomer(String? fullname, String? email, String method) async {
    List<String> emptyList = [];
    Map<dynamic, dynamic> emptyMap = {};

    await customerCollection
        .doc(id)
        .set({
          'id': id,
          'fullname': fullname,
          'email': email,
          'method': method,
          'fav_products': emptyList,
          'addresses': emptyList,
          'basketMap': emptyMap,
          'prev_orders': emptyList,
          'tax_id': "",
          'credit_cards': emptyList,
        })
        .then((value) => print('Customer Added'))
        .catchError((error) => print('Adding customer failed ${error.toString()}'));
  }

  Future changeName(String fullname) async {
    await customerCollection.doc(id).update({'fullname': fullname});
  }

  Future removeFromFavs(List<dynamic> oldFavs, String idToBeRemoved) async {
    List<dynamic> newFavs = [];

    for (var i = 0; i < oldFavs.length; i++) {
      if (oldFavs[i] != idToBeRemoved) {
        newFavs.add(oldFavs[i]);
      }
    }
    await customerCollection.doc(id).update({'fav_products': newFavs});
  }

  Future addToFavs(List<dynamic> oldFavs, String newId) async {
    List<dynamic> newFavs = [];
    for (var i = 0; i < oldFavs.length; i++) {
      newFavs.add(oldFavs[i]);
    }
    newFavs.add(newId);
    await customerCollection.doc(id).update({'fav_products': newFavs});
  }

  Future addToCart(Map<dynamic, dynamic> oldCart, String idToBeInserted, dynamic size) async {
    Map<dynamic, dynamic> newCart = oldCart;
    bool exists = false;

    newCart.update(idToBeInserted, (value) => [oldCart[idToBeInserted][0] + 1, size], ifAbsent: () => [1, size]);

    await customerCollection.doc(id).update({'basketMap': newCart});
  }

  Future removeFromCart(Map<dynamic, dynamic> oldCart, String idToBeRemoved) async {
    Map<dynamic, dynamic> newCart = {};

    oldCart.forEach((key, value) {
      if (key != idToBeRemoved) {
        newCart[key] = value;
      }
    });

    await customerCollection.doc(id).update({'basketMap': newCart});
  }

  Future increaseAmount(Map<dynamic, dynamic> oldCart, String idToBeIncreased) async {
    Map<dynamic, dynamic> newCart = {};

    oldCart.forEach((key, value) {
      if (key == idToBeIncreased) {
        newCart[key] = [value[0] + 1, value[1]];
      } else {
        newCart[key] = [value[0], value[1]];
      }
    });
    await customerCollection.doc(id).update({'basketMap': newCart});
  }

  Future decreaseAmount(Map<dynamic, dynamic> oldCart, String idToBeDecreased) async {
    Map<dynamic, dynamic> newCart = {};
    oldCart.forEach((key, value) {
      if (key == idToBeDecreased) {
        newCart[key] = [value[0] - 1, value[1]];
      } else {
        newCart[key] = [value[0], value[1]];
      }
    });

    await customerCollection.doc(id).update({'basketMap': newCart});
  }

  Future appendNewPaymentOption(List<dynamic> oldOptions, String idToBeAppended) async {
    List<dynamic> newOptions = [];
    for (var i = 0; i < oldOptions.length; i++) {
      newOptions.add(oldOptions[i]);
    }

    newOptions.add(idToBeAppended);

    await customerCollection.doc(id).update({'credit_cards': newOptions});
  }

  Future removePaymentOption(List<dynamic> oldOptions, String idToBeRemoved) async {
    List<dynamic> newOptions = [];
    for (var i = 0; i < oldOptions.length; i++) {
      if (oldOptions[i] != idToBeRemoved) {
        newOptions.add(oldOptions[i]);
      }
    }

    await customerCollection.doc(id).update({'credit_cards': newOptions});
  }

  Future addAddressOption(List<dynamic> oldOptions, String addressToBeAdded) async {
    List<dynamic> newOptions = [];
    for (var i = 0; i < oldOptions.length; i++) {
      if (oldOptions[i] != addressToBeAdded) {
        newOptions.add(oldOptions[i]);
      }
    }

    newOptions.add(addressToBeAdded);

    await customerCollection.doc(id).update({'addresses': newOptions});
  }

  Future removeAddressOption(List<dynamic> oldOptions, String addressToBeAdded) async {
    List<dynamic> newOptions = [];
    for (var i = 0; i < oldOptions.length; i++) {
      if (oldOptions[i] != addressToBeAdded) {
        newOptions.add(oldOptions[i]);
      }
    }

    await customerCollection.doc(id).update({'addresses': newOptions});
  }

  Future addToPrevOrders(String orderString, List<dynamic> oldOrders) async {
    Map<dynamic, dynamic> newCart = {};
    List<dynamic> newOrders = oldOrders;
    newOrders.add(orderString);

    await customerCollection.doc(id).update({'prev_orders': newOrders, 'basketMap': newCart});
  }
  /*--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--*/

  /*--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--*/
  Product _productDataFromSnapshot(DocumentSnapshot snapshot) {
    return Product(
        id: id,
        distributor_information: snapshot.get("distributor_information"),
        name: snapshot.get("name"),
        model: snapshot.get("model"),
        category: snapshot.get("category"),
        color: snapshot.get("color"),
        description: snapshot.get("description"),
        sex: snapshot.get("sex"),
        price: double.parse(snapshot.get("price")) - (snapshot.get("discount_rate") * double.parse(snapshot.get("price")) / 100),
        quantity: getQuantity(snapshot.get("sizesMap")),
        discount_rate: snapshot.get("discount_rate"),
        warranty: snapshot.get("warranty"),
        comments: snapshot.get("comments"),
        sizesMap: snapshot.get("sizesMap"),
        photos: snapshot.get("photos"));
  }

  List<Product> _productListFromSnapshot_specified(QuerySnapshot snapshot) {
    return List<Product>.from(snapshot.docs
        .map((doc) {
          if (ids.contains(doc.id)) {
            return Product(
                id: doc.id,
                distributor_information: doc.get("distributor_information"),
                name: doc.get("name"),
                model: doc.get("model"),
                category: doc.get("category"),
                color: doc.get("color"),
                description: doc.get("description"),
                sex: doc.get("sex"),
                price: double.parse(doc.get("price")) - (doc.get("discount_rate") * double.parse(doc.get("price")) / 100),
                quantity: getQuantity(doc.get("sizesMap")),
                discount_rate: doc.get("discount_rate"),
                warranty: doc.get("warranty"),
                comments: doc.get("comments"),
                sizesMap: doc.get("sizesMap"),
                photos: doc.get("photos"));
          }
        })
        .toList()
        .where((element) => element != null));
  }

  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Product(
          id: doc.get("id"),
          distributor_information: doc.get("distributor_information"),
          name: doc.get("name"),
          model: doc.get("model"),
          category: doc.get("category"),
          color: doc.get("color"),
          description: doc.get("description"),
          sex: doc.get("sex"),
          price: double.parse(doc.get("price")) - (doc.get("discount_rate") * double.parse(doc.get("price")) / 100),
          quantity: getQuantity(doc.get("sizesMap")),
          discount_rate: doc.get("discount_rate"),
          warranty: doc.get("warranty"),
          comments: doc.get("comments"),
          sizesMap: doc.get("sizesMap"),
          photos: doc.get("photos"));
    }).toList();
  }

  List<Product> _discountedProductListFromSnapshot(QuerySnapshot snapshot) {
    return List<Product>.from(snapshot.docs
        .map((doc) {
          return Product(
              id: doc.id,
              distributor_information: doc.get("distributor_information"),
              name: doc.get("name"),
              model: doc.get("model"),
              category: doc.get("category"),
              color: doc.get("color"),
              description: doc.get("description"),
              sex: doc.get("sex"),
              price: double.parse(doc.get("price")) - (doc.get("discount_rate") * double.parse(doc.get("price")) / 100),
              quantity: getQuantity(doc.get("sizesMap")),
              discount_rate: doc.get("discount_rate"),
              warranty: doc.get("warranty"),
              comments: doc.get("comments"),
              sizesMap: doc.get("sizesMap"),
              photos: doc.get("photos"));
        })
        .toList()
        .where((element) => element.discount_rate != 0));
  }

  int getQuantity(dynamic dmap) {
    Map<dynamic, dynamic> map = dmap as Map<dynamic, dynamic>;
    dynamic dquantity = 0;
    map.forEach((key, value) {
      dquantity += value;
    });
    int quantity = dquantity as int;
    return quantity;
  }

  Stream<Product> get productData {
    return productCollection.doc(id).snapshots().map(_productDataFromSnapshot);
  }

  Stream<List<Product>> get specifiedProducts {
    return productCollection.snapshots().map(_productListFromSnapshot_specified);
  }

  Stream<List<Product>> get allProducts {
    return productCollection.snapshots().map(_productListFromSnapshot);
  }

  Stream<List<Product>> get discountedProducts {
    return productCollection.snapshots().map(_discountedProductListFromSnapshot);
  }

  Future decreaseAmountFromSpecifiedProducts(Map<Product, dynamic> basket) async {
    Map<String, Map<dynamic, dynamic>> changes = {};

    for (var i = 0; i < basket.keys.toList().length; i++) {
      Map<dynamic, dynamic> sizeMapChanges = basket.keys.toList()[i].sizesMap;
      sizeMapChanges[basket[basket.keys.toList()[i]][1]] -= basket[basket.keys.toList()[i]][0];
      changes[basket.keys.toList()[i].id] = sizeMapChanges;
    }

    for (var i = 0; i < changes.keys.toList().length; i++) {
      String productID = changes.keys.toList()[i];
      await productCollection.doc(productID).update({'sizesMap': changes[productID]});
    }
  }
  /*--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--*/

  /*--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--*/
  Seller _sellerDataFromSnapshot(DocumentSnapshot snapshot) {
    return Seller(
        id: id, logo: snapshot.get("logo"), name: snapshot.get("name"), products: snapshot.get("products"), ratings: snapshot.get("ratings"));
  }

  List<Seller> _sellerListFromSnapshot_specified(QuerySnapshot snapshot) {
    return List<Seller>.from(snapshot.docs
        .map((doc) {
          if (ids.contains(doc.id)) {
            return Seller(
                id: doc.get("id"), logo: doc.get("logo"), name: doc.get("name"), products: doc.get("products"), ratings: doc.get("ratings"));
          }
        })
        .toList()
        .where((element) => element != null));
  }

  List<Seller> _sellerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Seller(id: doc.get("id"), logo: doc.get("logo"), name: doc.get("name"), products: doc.get("products"), ratings: doc.get("ratings"));
    }).toList();
  }

  Stream<Seller> get sellerData {
    return sellerCollection.doc(id).snapshots().map(_sellerDataFromSnapshot);
  }

  Stream<List<Seller>> get specifiedSellers {
    return sellerCollection.snapshots().map(_sellerListFromSnapshot_specified);
  }

  Stream<List<Seller>> get allSellers {
    return sellerCollection.snapshots().map(_sellerListFromSnapshot);
  }

  /*--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--*/
  /*--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD*/
  BankCard _cardDataFromSnapshot(DocumentSnapshot snapshot) {
    return BankCard(
        id: id,
        holderID: snapshot.get('holderID'),
        cardNumber: snapshot.get('cardNumber'),
        expiryDate: snapshot.get('expiryDate'),
        cardHolderName: snapshot.get('cardHolderName'),
        cvvCode: snapshot.get('cvvCode'));
  }

  List<BankCard> _cardListFromSnapshot_specified(QuerySnapshot snapshot) {
    return List<BankCard>.from(snapshot.docs
        .map((doc) {
          if (ids.contains(doc.id)) {
            return BankCard(
                id: doc.id,
                holderID: doc.get('holderID'),
                cardNumber: doc.get('cardNumber'),
                expiryDate: doc.get('expiryDate'),
                cardHolderName: doc.get('cardHolderName'),
                cvvCode: doc.get('cvvCode'));
          }
        })
        .toList()
        .where((element) => element != null));
  }

  List<BankCard> _cardListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BankCard(
          id: doc.id,
          holderID: doc.get('holderID'),
          cardNumber: doc.get('cardNumber'),
          expiryDate: doc.get('expiryDate'),
          cardHolderName: doc.get('cardHolderName'),
          cvvCode: doc.get('cvvCode'));
    }).toList();
  }

  Stream<BankCard> get cardData {
    return cardCollection.doc(id).snapshots().map(_cardDataFromSnapshot);
  }

  Stream<List<BankCard>> get specifiedCards {
    return cardCollection.snapshots().map(_cardListFromSnapshot_specified);
  }

  Stream<List<BankCard>> get allCards {
    return cardCollection.snapshots().map(_cardListFromSnapshot);
  }

  List<dynamic> _existingIDs(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return doc.id;
    }).toList();
  }

  Future createNewPaymentMethod(String cvvCode, String expiryDate, String cardHolderName, String cardNumber, Customer customer) async {
    String randomID = randID();
    /*while (cardCollection.doc(randomID).get() != null) {
      randomID = randID();
    }*/

    await cardCollection.doc(randomID).set({
      'id': randomID,
      'holderID': customer.id,
      'cvvCode': cvvCode,
      'expiryDate': expiryDate,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
    });

    await appendNewPaymentOption(customer.credit_cards, randomID);
  }

  Future deleteExistingPaymentMethod(Customer customer, String idToBeRemoved) async {
    await removePaymentOption(customer.credit_cards, idToBeRemoved);

    await cardCollection.doc(idToBeRemoved).delete();
  }
  /*--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD--CARD*/
  /*--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER*/

  Future createNewOrder(List<Order> orderArr, Customer customer, Map<Product, dynamic> basket, String? address) async {
    List<dynamic> oldPrevOrder = customer.prev_orders;
    String orderString = "";
    for (var i = 0; i < orderArr.length; i++) {
      Order order = orderArr[i];
      await orderCollection.doc(order.id).set({
        'id': order.id,
        'customerID': order.customerID,
        'sellerID': order.sellerID,
        'productID': order.productID,
        'address': order.address,
        'status': order.status,
        'size': order.size,
        'price': order.price.toStringAsFixed(2),
        'quantity': order.quantity,
        'date': DateFormat("dd-MM-yyyy").format(order.date),
      });
      orderString = orderString + order.id;
      if (i != orderArr.length - 1) {
        orderString = orderString + "-";
      }
    }

    addToPrevOrders(orderString, oldPrevOrder);

    final data = await PdfInvoiceService().createInvoice(customer, basket, address);
    PdfInvoiceService().savePdfFile(orderString, data);
  }

  /*--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER--ORDER*/

}
