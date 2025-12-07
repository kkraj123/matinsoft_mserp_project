import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context, {
      required String message,
      Color backgroundColor = Colors.red,
      Duration duration = const Duration(seconds: 2),
      bool isFloating = true,
      IconData? icon,
    }) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
        ],
        Expanded(child: Text(message)),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    duration: duration,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: isFloating ? const EdgeInsets.all(16) : null,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
