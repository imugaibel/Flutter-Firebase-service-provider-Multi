import 'package:flutter/material.dart';
import 'package:maintenance/utils/app_localization.dart';

alertSheet(context, { String title = "", List<String> items, Function onTap(value) }) {

  List<Widget> actions = [];

  items.forEach((value) => {
    actions.add(
      Align(
        alignment: Alignment.center,
        child: FlatButton(
          child: Text(value,
            style:
            TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
          ),
          onPressed: () {
            onTap(value);
            Navigator.of(context).pop();
          },
        ),
      ),
    ),
  });

  actions.add(Align(
    alignment: Alignment.center,
    child: FlatButton(
      minWidth: MediaQuery.of(context).size.width,
      child: Text(AppLocalization.of(context).translate('Cancel'),
        style:
        TextStyle(color: Theme.of(context).accentColor, fontSize: 18),),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  ));

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title, style: TextStyle(color: Theme.of(context).primaryColor), textAlign: TextAlign.center,),
      actions: actions,
    ),
  );
}