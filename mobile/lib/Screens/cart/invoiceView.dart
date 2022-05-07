import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/utils/animations.dart';
import 'package:mobile/utils/colors.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class InvoiceView extends StatefulWidget {
  final String pdfName;
  final String url;
  const InvoiceView({Key? key, required this.pdfName, required this.url}) : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  String? pdfFlePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${widget.pdfName}.pdf');
    /*if (await file.exists()) {
      return file.path;
    }*/
    final response = await http.get(Uri.parse(widget.url));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  void loadPdf() async {
    print(widget.url);
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
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
      body: Center(
          child: pdfFlePath != null
              ? Expanded(
                  child: Container(
                    child: PdfView(path: pdfFlePath!),
                  ),
                )
              : Animations().loading()),
    );
  }
}
