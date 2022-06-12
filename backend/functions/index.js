
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.onRequestUpdate = functions.firestore
    .document("returnRequests/{requestID}")
    .onUpdate((change, context) => {
      const previousValues = change.before.data();
      const newValues = change.after.data();

      try {
        if (newValues.approved != previousValues.approved) {
          const updatePromises = [];
          const price = newValues.price;

          //  order related info
          const orderID = newValues.orderID;
          let size = "";
          let quantity = 0;
          db.collection("orders")
              .where("id", "==", orderID).get().then((orderSnapshot) => {
                orderSnapshot.forEach((doc) => {
                  size = doc.get("size");
                  quantity = doc.get("quantity");
                  updatePromises.push(db.collection("orders")
                      .doc(doc.id)
                      .update({status: "returnapproved"}));
                });
              });


          //  product related info .then(() => {})
          const productID = newValues.productID;
          db.collection("products")
              .where("id", "==", productID).get().then((productSnapshot) => {
                productSnapshot.forEach((doc) => {
                  const retrievedSizesMap = doc.get("sizesMap");
                  const prevAmount = retrievedSizesMap[size];
                  retrievedSizesMap[size] = quantity + prevAmount;
                  updatePromises.push(db.collection("products")
                      .doc(doc.id).update({sizesMap: retrievedSizesMap}));
                });
              });


          //  customer related info
          const customerID = newValues.customerID;
          let retrievedWallet = "";
          db.collection("customers")
              .where("id", "==", customerID).get().then((customerSnapshot) => {
                customerSnapshot.forEach((doc) => {
                  retrievedWallet = doc.get("wallet");
                  const walletFloat = parseFloat(retrievedWallet);
                  const priceFloat = parseFloat(price);
                  const sumFloat = walletFloat + priceFloat;
                  const sum = sumFloat.toString();
                  updatePromises.push(db.collection("customers")
                      .doc(doc.id).update({wallet: sum}));
                });
              });

          return Promise.all(updatePromises);
        }
        if (newValues.rejected != previousValues.rejected) {
          const updatePromises = [];

          //  order related info
          const orderID = newValues.orderID;
          db.collection("orders")
              .where("id", "==", orderID).get().then((orderSnapshot) => {
                orderSnapshot.forEach((doc) => {
                  updatePromises.push(db.collection("orders")
                      .doc(doc.id).update({status: "returnrejected"}));
                });
              });
          return Promise.all(updatePromises);
        }
      } catch (err) {
        return db.collection("logs").doc().set({error: err});
      }
    });

exports.onNewDiscountApplied = functions.firestore
    .document("products/{productID}")
    .onUpdate((change, context) => {
      const previousValues = change.before.data();
      const newValues = change.after.data();

      try {
        if (newValues.discount_rate != previousValues.discount_rate &&
            newValues.discount_rate != 0 &&
            newValues.discount_rate > previousValues.discount_rate) {
          const updatePromises = [];
          const tos = [];
          const oldDiscount = previousValues.discount_rate;
          const newDiscount = newValues.discount_rate;
          const productID = newValues.id;
          const productName = newValues.name;
          const productModel = newValues.model;
          const productPicture = newValues.photos[0];
          const oldPrice = (parseFloat(previousValues.price) *
                            ((100 - oldDiscount) / 100)).toFixed(2);
          const newPrice = (parseFloat(newValues.price) *
                            ((100 - newDiscount) / 100)).toFixed(2);

          let email = "";
          let favList = [];
          db.collection("customers")
              .get().then((customerSnapshot) => {
                customerSnapshot.forEach((doc) => {
                  email = doc.get("email");
                  favList = doc.get("fav_products");
                  if (email != "No Email" &&
                    favList.length != 0 &&
                    favList.includes(productID)) {
                    tos.push(email);
                  }
                });
              });
          const htmlMessage = '<h1>Time to check your ShoeShop wishlist!</h1>' +
                              '<p>Apparently we have new discounts for you. ' +
                              'Check it out.</p>' +
                              '<p style="text-align: center;">' +
                              '<img src=' + productPicture +
                              'alt="productPictiure"' +
                              'width="240" height="300" /></p>' +
                              '<h2 style="text-align: center;">' +
                              productName + ' ' + productModel + ' is now ' +
                              newDiscount.toString()+'% off</h2>' +
                              '<h2 style="text-align: center;">' +
                              newPrice+'₺</h2>'+
                              '<h3 style="text-align: center;">' +
                              'instead of '+oldPrice+'₺</h3>';

          if (tos.length != 0) {
            updatePromises.push(db.collection("mail").doc().set({
              message: {
                html: htmlMessage,
                subject: "New Discount Deal on ShoeShop",
                text: "",
              },
              to: tos,
            }));
          }

          return Promise.all(updatePromises);
        }
      } catch (err) {
        return db.collection("logs").doc().set({error: err});
      }
    });
