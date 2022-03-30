import 'package:flutter/material.dart';

customButton(context, { required String title, icon,   onPressed }) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * (315 / 375),
    height: MediaQuery.of(context).size.height * (60 / 812),
    child: RaisedButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(36))),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}