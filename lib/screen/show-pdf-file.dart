import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maintenance/utils/generate_invoice.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Represents Homepage for Navigation
class ShowPDFFile extends StatefulWidget {
  const ShowPDFFile({Key? key}) : super(key: key);

  @override
  _ShowPDFFilePage createState() => _ShowPDFFilePage();
}

class _ShowPDFFilePage extends State<ShowPDFFile> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
      ),
      body: FutureBuilder<String>(
          future: generateInvoice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SfPdfViewer.file(
                File(snapshot.data!),
                key: _pdfViewerKey,
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
