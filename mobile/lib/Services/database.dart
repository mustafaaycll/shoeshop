import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';

import '../models/products/product.dart';

class DatabaseService {
  final String id;
  final List<dynamic> ids;

  DatabaseService({required this.id, required this.ids});

  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customers');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference sellerCollection =
      FirebaseFirestore.instance.collection('sellers');

  /*--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--*/
  Customer _customerDataFromSnapshot(DocumentSnapshot snapshot) {
    return Customer(
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

  Stream<Customer> get customerData {
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

  Future addToCart(
      List<dynamic> oldAmounts, List<dynamic> oldCart, String newItem) async {
    bool exists = false;
    int index = -1;
    List<dynamic> newAmounts = [];
    List<dynamic> newCart = [];

    for (var i = 0; i < oldCart.length; i++) {
      newCart.add(oldCart[i]);
      newAmounts.add(oldAmounts[i]);

      if (oldCart[i] == newItem) {
        index = i;
        exists = true;
      }
    }
    if (exists) {
      newAmounts[index] += 1;
    } else {
      newAmounts.add(1);
      newCart.add(newItem);
    }

    await customerCollection
        .doc(id)
        .update({'basket': newCart, 'amounts': newAmounts});
  }

  Future removeFromCart(List<dynamic> oldAmounts, List<dynamic> oldCart,
      String IDtoBeRemoved) async {
    List<dynamic> newAmounts = [];
    List<dynamic> newCart = [];

    for (var i = 0; i < oldCart.length; i++) {
      if (oldCart[i] != IDtoBeRemoved) {
        newAmounts.add(oldAmounts[i]);
        newCart.add(oldCart[i]);
      }
    }

    await customerCollection
        .doc(id)
        .update({'basket': newCart, 'amounts': newAmounts});
  }

  Future increaseAmount(List<dynamic> oldAmounts, List<dynamic> oldCart,
      String IDtoBeIncreased) async {
    List<dynamic> newAmounts = [];
    List<dynamic> newCart = [];
    for (var i = 0; i < oldCart.length; i++) {
      if (oldCart[i] != IDtoBeIncreased) {
        newAmounts.add(oldAmounts[i]);
      } else {
        newAmounts.add(oldAmounts[i] + 1);
      }
      newCart.add(oldCart[i]);
    }

    await customerCollection
        .doc(id)
        .update({'basket': newCart, 'amounts': newAmounts});
  }

  Future decreaseAmount(List<dynamic> oldAmounts, List<dynamic> oldCart,
      String IDtoBeDecreased) async {
    List<dynamic> newAmounts = [];
    List<dynamic> newCart = [];
    for (var i = 0; i < oldCart.length; i++) {
      if (oldCart[i] != IDtoBeDecreased) {
        newAmounts.add(oldAmounts[i]);
        newCart.add(oldCart[i]);
      } else {
        if (oldAmounts[i] != 1) {
          newAmounts.add(oldAmounts[i] - 1);
          newCart.add(oldCart[i]);
        }
      }
    }

    await customerCollection
        .doc(id)
        .update({'basket': newCart, 'amounts': newAmounts});
  }
  /*--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--CUSTOMER--*/

  /*--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--*/
  Product _productDataFromSnapshot(DocumentSnapshot snapshot) {
    return Product(
        id: id,
        name: snapshot.get("name"),
        model: snapshot.get("model"),
        category: snapshot.get("category"),
        color: snapshot.get("color"),
        description: snapshot.get("description"),
        sex: snapshot.get("sex"),
        price: double.parse(snapshot.get("price")) -
            (snapshot.get("discount_rate") *
                double.parse(snapshot.get("price")) /
                100),
        quantity: snapshot.get("quantity"),
        discount_rate: snapshot.get("discount_rate"),
        warranty: snapshot.get("warranty"),
        comments: snapshot.get("comments"),
        sizes: snapshot.get("sizes"),
        photos: snapshot.get("photos"));
  }

  List<Product> _productListFromSnapshot_specified(QuerySnapshot snapshot) {
    return List<Product>.from(snapshot.docs
        .map((doc) {
          if (ids.contains(doc.id)) {
            return Product(
                id: doc.id,
                name: doc.get("name"),
                model: doc.get("model"),
                category: doc.get("category"),
                color: doc.get("color"),
                description: doc.get("description"),
                sex: doc.get("sex"),
                price: double.parse(doc.get("price")) -
                    (doc.get("discount_rate") *
                        double.parse(doc.get("price")) /
                        100),
                quantity: doc.get("quantity"),
                discount_rate: doc.get("discount_rate"),
                warranty: doc.get("warranty"),
                comments: doc.get("comments"),
                sizes: doc.get("sizes"),
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
          name: doc.get("name"),
          model: doc.get("model"),
          category: doc.get("category"),
          color: doc.get("color"),
          description: doc.get("description"),
          sex: doc.get("sex"),
          price: double.parse(doc.get("price")) -
              (doc.get("discount_rate") * double.parse(doc.get("price")) / 100),
          quantity: doc.get("quantity"),
          discount_rate: doc.get("discount_rate"),
          warranty: doc.get("warranty"),
          comments: doc.get("comments"),
          sizes: doc.get("sizes"),
          photos: doc.get("photos"));
    }).toList();
  }

  List<Product> _discountedProductListFromSnapshot(QuerySnapshot snapshot) {
    return List<Product>.from(snapshot.docs
        .map((doc) {
          return Product(
              id: doc.id,
              name: doc.get("name"),
              model: doc.get("model"),
              category: doc.get("category"),
              color: doc.get("color"),
              description: doc.get("description"),
              sex: doc.get("sex"),
              price: double.parse(doc.get("price")) -
                  (doc.get("discount_rate") *
                      double.parse(doc.get("price")) /
                      100),
              quantity: doc.get("quantity"),
              discount_rate: doc.get("discount_rate"),
              warranty: doc.get("warranty"),
              comments: doc.get("comments"),
              sizes: doc.get("sizes"),
              photos: doc.get("photos"));
        })
        .toList()
        .where((element) => element.discount_rate != 0));
  }

  Stream<Product> get productData {
    return productCollection.doc(id).snapshots().map(_productDataFromSnapshot);
  }

  Stream<List<Product>> get specifiedProducts {
    return productCollection
        .snapshots()
        .map(_productListFromSnapshot_specified);
  }

  Stream<List<Product>> get allProducts {
    return productCollection.snapshots().map(_productListFromSnapshot);
  }

  Stream<List<Product>> get discountedProducts {
    return productCollection
        .snapshots()
        .map(_discountedProductListFromSnapshot);
  }
  /*--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--PRODUCT--*/

  /*--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--SELLER--*/
  Seller _sellerDataFromSnapshot(DocumentSnapshot snapshot) {
    return Seller(
        id: id,
        logo: snapshot.get("logo"),
        name: snapshot.get("name"),
        products: snapshot.get("products"),
        ratings: snapshot.get("ratings"));
  }

  List<Seller> _sellerListFromSnapshot_specified(QuerySnapshot snapshot) {
    return List<Seller>.from(snapshot.docs
        .map((doc) {
          if (ids.contains(doc.id)) {
            return Seller(
                id: doc.get("id"),
                logo: doc.get("logo"),
                name: doc.get("name"),
                products: doc.get("products"),
                ratings: doc.get("ratings"));
          }
        })
        .toList()
        .where((element) => element != null));
  }

  List<Seller> _sellerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Seller(
          id: doc.get("id"),
          logo: doc.get("logo"),
          name: doc.get("name"),
          products: doc.get("products"),
          ratings: doc.get("ratings"));
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
}
