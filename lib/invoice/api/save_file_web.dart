import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({required String name, required Document pdf,}) async {
    final bytes = await pdf.save();
    js.context['pdfBytes'] = base64.encode(bytes);
    js.context['fileName'] = 'Output.pdf';
    Timer.run(() {
      js.context.callMethod('download');
    });
    final file = File('/$name');


    return file;
  }
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
