import 'package:flutter/material.dart';

import 'index.dart';

TextStyle kStyle({
  Color color,
  double size,
}) {
  return TextStyle(
    color: color ?? textColor,
    fontWeight: FontWeight.w500,
    fontSize: size ?? 15,
  );
}
