import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  Color confirmationButtonColor = Colors.red,
  String confirmText = "Confirm",
  String cancelText = "Cancel",
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? confirmationButtonColor : null,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText, style: TextStyle(color: Colors.white),),
        ),
      ],
    ),
  );
}
