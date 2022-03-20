import 'package:flutter/material.dart';
import 'package:maintenance/utils/app_localization.dart';

showAlertDialog(BuildContext context, { String title = "", String message = "" , String titleBtnOne = "Ok", String titleBtnTwo = "Close",  actionBtnOne,  actionBtnTwo, bool showBtnOne = true, bool showBtnTwo = true}) {

  Widget btnOne = FlatButton(
    child: Text(AppLocalization.of(context)!.translate(titleBtnOne)),
    onPressed: actionBtnOne,
  );

  Widget btnTwo = FlatButton(
    child: Text(AppLocalization.of(context)!.translate(titleBtnTwo)),
    onPressed: actionBtnTwo,
  );

  AlertDialog alert = AlertDialog(
    title: Text(title, style: TextStyle(color: Theme.of(context).primaryColor),),
    content: Text(message),
    actions: [
      Visibility(visible: showBtnOne, child: btnOne),
      Visibility(visible: showBtnTwo, child: btnTwo),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}