import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashString(String value) {
  const key = 'starlight moonlight';
  final before = '$key$value';

  final bytes = utf8.encode(before.replaceAll(RegExp(r'\s'), ''));
  return sha512.convert(bytes).toString();
}
