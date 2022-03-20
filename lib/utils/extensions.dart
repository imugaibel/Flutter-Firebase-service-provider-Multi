import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {

  bool isValidEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);

  bool isValidPassword() => length >= 6 && length <= 15;

  bool isURL() => Uri.parse(this).isAbsolute;

  Color toHexa() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String changeDateFormat({String format = 'yyyy-MM-dd'}) {
    String newData = "";
    DateTime dt = DateTime.parse(this);
    DateFormat formatter = DateFormat(format);
    newData = formatter.format(dt);
    return newData;
  }

}

extension TextEditingControllerExtensions on TextEditingController {

  isEmptyValue() => text.trim().isNotEmpty && text.trim() != '';

}

extension ScaffoldStateExtensions on GlobalKey<ScaffoldState> {

  showTosta({ @required message, isError = false }) {

    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      backgroundColor: isError ? Colors.red : Colors.green,
    );

    try {
      currentState!.showSnackBar(snackBar);
    } catch(e) {

    }

  }

}
