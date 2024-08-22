import 'package:flutter/material.dart';

BoxDecoration boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20.0),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 2.0),
    ],
  );
}
