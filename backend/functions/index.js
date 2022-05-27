
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