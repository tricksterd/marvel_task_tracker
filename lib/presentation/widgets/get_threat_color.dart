import 'package:flutter/material.dart';

Color getThreatColor(String threatLevel) {
  switch (threatLevel) {
    case 'Low':
      return Colors.green;
    case 'Medium':
      return Colors.orange;
    case 'High':
      return Colors.red;
    case 'World-Ending':
      return Colors.black;
    default:
      return Colors.black; // Колір за замовчуванням
  }
}
