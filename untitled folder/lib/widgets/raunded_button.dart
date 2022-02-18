import 'package:flutter/material.dart';

raundedButton(context, { @required String title, icon, @required Function onPressed }) {
  return Container(
    width: MediaQuery.of(context).size.width * (315 / 375),
    height: MediaQuery.of(context).size.height * (60 / 812),
    child: RaisedButton(
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      color: Colors.white,
      onPressed: onPressed,
      textColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(36))),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}