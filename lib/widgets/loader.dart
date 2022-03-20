import 'package:flutter/material.dart';

void showLoaderDialog(context, { bool isShowLoader = true }) {

  if (isShowLoader) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Align(
              alignment: Alignment.center,
              child: loader(context),
            ),
          ),
        );
      },
    );
  } else {
    Navigator.of(context).pop();
  }

}

loader(context) {
  return Container(
      width: MediaQuery.of(context).size.width * (100 / 375),
      height: MediaQuery.of(context).size.width * (100 / 375),
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const CircularProgressIndicator()
  );
}