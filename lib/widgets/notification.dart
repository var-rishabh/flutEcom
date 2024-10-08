import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:flut_mart/utils/helper/responsive.dart';

class KNotification {
  static void show({
    required BuildContext context,
    required String label,
    String? actionLabel,
    VoidCallback? actionFunction,
    String? type,
  }) {
    if (Responsive.isMobile(context)) {
      mobileShow(
        context: context,
        label: label,
        actionLabel: actionLabel,
        actionFunction: actionFunction,
        type: type,
      );
    } else {
      desktopShow(
        context: context,
        label: label,
        type: type,
      );
    }
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mobileShow({
    required BuildContext context,
    required String label,
    String? actionLabel,
    VoidCallback? actionFunction,
    String? type,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      content: Text(
        label,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: type == 'error'
          ? Colors.red
          : Theme.of(context).scaffoldBackgroundColor,
      behavior: SnackBarBehavior.floating,
      closeIconColor: Theme.of(context).colorScheme.secondary,
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

  static void desktopShow({
    required BuildContext context,
    required String label,
    String? type,
  }) {
    toastification.dismissAll();

    toastification.show(
      title: Text(label),
      context: context,
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 2),
      dragToClose: true,
      style: ToastificationStyle.fillColored,
      boxShadow: highModeShadow,
      primaryColor: type == 'error'
          ? Colors.red
          : Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: type == 'error'
          ? Colors.white
          : Theme.of(context).colorScheme.secondary,
      progressBarTheme: ProgressIndicatorThemeData(
        linearTrackColor: type == 'error'
            ? Colors.red
            : Theme.of(context).scaffoldBackgroundColor,
        color: type == 'error'
            ? Colors.white
            : Theme.of(context).colorScheme.secondary,
      ),
      type: type == 'error'
          ? ToastificationType.error
          : ToastificationType.success,
      borderRadius: BorderRadius.circular(12),
      alignment: Alignment.topRight,
    );
  }
}
