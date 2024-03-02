import 'dart:math';
import 'package:flutter/foundation.dart';

// Define a reusable function
String generateRandomString(int length) {
  final _random = Random();
  const _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
          (index) => _availableChars[_random.nextInt(_availableChars.length)])
      .join();

  return randomString;
}

String prettify(double d) =>
    // toStringAsFixed guarantees the specified number of fractional
// digits, so the regular expression is simpler than it would need to
// be for more general cases.
d.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');