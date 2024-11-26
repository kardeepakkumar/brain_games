import 'package:flutter/material.dart';

Color getTileColor(int value) {
  switch (value) {
    case 2:
      return Colors.lightBlue[100]!;
    case 4:
      return Colors.lightBlue[200]!;
    case 8:
      return Colors.orange[300]!;
    case 16:
      return Colors.orange[400]!;
    case 32:
      return Colors.deepOrange[300]!;
    case 64:
      return Colors.deepOrange[400]!;
    case 128:
      return Colors.yellow[300]!;
    case 256:
      return Colors.yellow[400]!;
    case 512:
      return Colors.green[300]!;
    case 1024:
      return Colors.green[400]!;
    case 2048:
      return Colors.purple[300]!;
    default:
      return Colors.grey[300]!;
  }
}
