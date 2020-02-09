import 'package:flutter/material.dart';

Color getTextColor(Brightness brightness) {
  return brightness == Brightness.dark ? Colors.white : Colors.black;
}
