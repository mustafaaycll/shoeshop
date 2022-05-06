import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mobile/models/products/product.dart';
import 'package:mobile/models/users/customer.dart';
import 'package:mobile/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;

  CustomRow(this.itemName, this.itemPrice, this.amount, this.total);
}

class CustomCol {
  final CustomRow r1;
  final CustomRow r2;

  CustomCol({required this.r1, required this.r2});
}

class PdfInvoiceService {
  Future<Uint8List> createInvoice(Customer customer, Map<Product, dynamic> basket, String? address) async {
    final pdf = pw.Document();

    List<CustomRow> elements = [
      CustomRow("Item Name", "Item Price", "Amount", "Total"),
      for (var item in basket.keys.toList())
        CustomRow(
          item.name + " " + item.model,
          item.price.toStringAsFixed(2) + " TL",
          basket[item][0].toString(),
          (item.price * basket[item][0]).toStringAsFixed(2),
        ),
      CustomRow(
        "",
        "",
        "",
        "",
      ),
      CustomRow(
        "Total",
        "",
        "",
        "${getTotal(basket)} TL",
      ),
    ];

    final image = (await rootBundle.load("assets/mainlogo.png")).buffer.asUint8List();
    String printedAddress = "";
    List listAddress = address!.split(", ");
    for (var i = 0; i < listAddress.length; i++) {
      printedAddress += listAddress[i];
      if (i != listAddress.length - 1) {
        printedAddress += "\n";
      }
    }
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Image(pw.MemoryImage(image), width: 150, height: 699, fit: pw.BoxFit.contain),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(customer.fullname, style: pw.TextStyle(color: PdfColor.fromHex('98989c'), fontSize: 10)),
                    pw.Text(customer.email, style: pw.TextStyle(color: PdfColor.fromHex('98989c'), fontSize: 10)),
                    pw.Text(printedAddress, style: pw.TextStyle(color: PdfColor.fromHex('98989c'), fontSize: 10)),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text("ShoeShop Company", style: pw.TextStyle(color: PdfColor.fromHex('98989c'))),
                    pw.Text("Sisli", style: pw.TextStyle(color: PdfColor.fromHex('98989c'))),
                    pw.Text("Istanbul", style: pw.TextStyle(color: PdfColor.fromHex('98989c'))),
                  ],
                )
              ],
            ),
            pw.SizedBox(height: 50),
            pw.Text("Dear ${customer.fullname}, thanks for buying at ShoeShop, feel free to see the list of items below."),
            pw.SizedBox(height: 25),
            itemColumn(elements),
            pw.SizedBox(height: 25),
          ]);
        },
      ),
    );

    return pdf.save();
  }

  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            if (element.itemName == "Item Name")
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text(element.itemName,
                          textAlign: pw.TextAlign.left, style: pw.TextStyle(color: PdfColor.fromHex('98989c'), fontSize: 10))),
                  pw.Expanded(
                      child: pw.Text(element.itemPrice,
                          textAlign: pw.TextAlign.right, style: pw.TextStyle(color: PdfColor.fromHex('98989c'), fontSize: 10))),
                  pw.Expanded(
                      child: pw.Text(element.amount,
                          textAlign: pw.TextAlign.right, style: pw.TextStyle(color: PdfColor.fromHex('98989c'), fontSize: 10))),
                  pw.Expanded(
                      child: pw.Text(element.total,
                          textAlign: pw.TextAlign.right, style: pw.TextStyle(color: PdfColor.fromHex('98989c'), fontSize: 10))),
                ],
              )
            else
              pw.Column(children: [
                pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text(element.itemName, textAlign: pw.TextAlign.left)),
                    pw.Expanded(child: pw.Text(element.itemPrice, textAlign: pw.TextAlign.right)),
                    pw.Expanded(child: pw.Text(element.amount, textAlign: pw.TextAlign.right)),
                    pw.Expanded(child: pw.Text(element.total, textAlign: pw.TextAlign.right)),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text(" ", textAlign: pw.TextAlign.left)),
                    pw.Expanded(child: pw.Text(" ", textAlign: pw.TextAlign.right)),
                    pw.Expanded(child: pw.Text(" ", textAlign: pw.TextAlign.right)),
                    pw.Expanded(child: pw.Text(" ", textAlign: pw.TextAlign.right)),
                  ],
                )
              ])
        ],
      ),
    );
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);

    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('invoices/$fileName');

    try {
      await firebaseStorageRef.putFile(file);
    } on FirebaseException catch (e) {
      print("${e.message}");
    } catch (e) {
      print("err2");
    }
  }

  String getTotal(Map<Product, dynamic> basket) {
    double subTotal = 0;

    for (var i = 0; i < basket.keys.toList().length; i++) {
      Product product = basket.keys.toList()[i];
      dynamic amount = basket[product][0];
      subTotal += product.price * amount;
    }

    return subTotal.toStringAsFixed(2);
  }
}
