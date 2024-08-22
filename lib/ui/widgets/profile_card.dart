import 'package:flutter/material.dart';

Widget profileStat({required String title, required String value}) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    ],
  );
}
