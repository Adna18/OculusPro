import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Authorization {
  static String? username;
  static String? password;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image));
}

String formatNumber(dynamic value) {
  if (value == null) return "";

  final formatter = NumberFormat.currency(
    locale: 'bs_BA',
    symbol: 'KM',     
    decimalDigits: 2,
  );

  return formatter.format(value).trim();
}
