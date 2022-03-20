import 'package:flutter/material.dart';

OutlineInputBorder customBorderInput = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

InputDecoration customInputForm = InputDecoration(
  border: customBorderInput,
  focusedBorder: customBorderInput,
  enabledBorder: customBorderInput,
  filled: true,
  fillColor: const Color(0xFFF0F4F8),
  hintStyle: const TextStyle(
    fontSize: 18,
    color: Colors.grey,
  ),
);