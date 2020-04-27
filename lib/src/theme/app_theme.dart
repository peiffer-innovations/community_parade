import 'package:community_parade/src/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    buttonColor: AppColor.primaryColor,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    canvasColor: Colors.white,
    primaryColor: AppColor.primaryColor,
    primarySwatch: AppColor.primarySwatch,
    primaryColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey,
  );
}
