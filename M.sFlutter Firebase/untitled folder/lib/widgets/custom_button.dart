import 'package:flutter/material.dart';

customButton(context, { @required String title, icon, @required Function onPressed }) {
  return Container(
    width: MediaQuery.of(context).size.width * (315 / 375),
    height: MediaQuery.of(context).size.height * (60 / 812),
    child: RaisedButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
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