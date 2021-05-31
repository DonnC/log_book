// app global color
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

final ThemeData colorTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: bgColor,
  scaffoldBackgroundColor: bgColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'NunitoSans',
  canvasColor: secondaryColor,
);

const priColor = Colors.white;
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

final textColor = Colors.white.withOpacity(0.6);

final whiteColor = Colors.white.withOpacity(0.9);
const mainColor = Colors.grey;

const defaultPadding = 16.0;

const borderColor = mainColor;

final buttonColors = WindowButtonColors(
  iconNormal: priColor,
  mouseOver: secondaryColor,
  mouseDown: secondaryColor,
  iconMouseOver: Colors.white,
  iconMouseDown: secondaryColor,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: Color(0xFFD32F2F),
  mouseDown: Color(0xFFB71C1C),
  iconNormal: priColor,
  iconMouseOver: Colors.white,
);
