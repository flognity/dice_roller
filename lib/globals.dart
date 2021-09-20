/* **********************
 * Global properties
 * ********************** */
import 'package:dice_roller/util/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class _TextStyles {
  TextStyle get caption => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  TextStyle get button => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );

  TextStyle get paragraph => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
}

class Globals with AppTheme {
  Globals._(); //This class is non-instantiable

  static AppTheme appTheme = AppTheme();
  static _TextStyles textStyles = _TextStyles();

  static const String appName = 'Dice Roller';
}
