import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/models/users/seller.dart';

import '../models/products/product.dart';

class DatabaseService {
  final String id;
  final List<dynamic> ids;

  DatabaseService({required this.id, required this.ids});

  final CollectionReference customerCollection = FirebaseFirestore.instance.collection('customers');
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');
  final CollectionReference sellerCollection = FirebaseFirestore.instance.collection('sellers');

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
}
