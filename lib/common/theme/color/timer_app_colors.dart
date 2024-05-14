import 'package:flutter/material.dart';

class AppColors {
  final Color iconButton;
  final Color iconButtonInactivate;
  final Color text;
  final MaterialColor seedColor;

  AppColors({
    required this.iconButton,
    required this.iconButtonInactivate,
    required this.text,
    required this.seedColor,
  });

  static AppColors of(BuildContext context) {
    return AppColors(
      iconButton: Colors.blue,
      iconButtonInactivate: Colors.grey,
      text: Colors.black,
      seedColor: Colors.blue,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get appColors => AppColors.of(this);
}