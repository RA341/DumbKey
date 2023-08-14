import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isDebug = kDebugMode;

void displaySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

EdgeInsetsGeometry responsivePadding(BuildContext context,
    {double horizontalFactor = 0.05, double verticalFactor = 0.02}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final horizontalPadding = screenWidth * horizontalFactor;
  final verticalPadding = screenHeight * verticalFactor;

  return EdgeInsets.symmetric(
    horizontal: horizontalPadding,
    vertical: verticalPadding,
  );
}
