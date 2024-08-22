import 'package:flutter/material.dart';

Widget galleryImage({required String url}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: Image.network(
      url,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    ),
  );
}
