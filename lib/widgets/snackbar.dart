import 'package:flutter/material.dart';

class KSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    required String label,
    String? actionLabel,
    VoidCallback? actionFunction,
    String? type,
  }) {
    // closing any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Define the snackbar
    final snackBar = SnackBar(
      content: Text(label),
      duration: const Duration(seconds: 2),
      backgroundColor: type == 'error'
          ? Colors.red
          : type == 'success'
              ? Colors.green
              : Colors.black54,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      showCloseIcon: actionLabel == null,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: actionFunction ?? () {},
            )
          : null,
    );

    // Show the snackbar
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
