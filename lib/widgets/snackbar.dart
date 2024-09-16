import 'package:flutter/material.dart';

class KSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    required String label,
    String? actionLabel,
    VoidCallback? actionFunction,
    String? type,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

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
      elevation: 2,
      width: 400,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: actionFunction ?? () {},
            )
          : null,
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
