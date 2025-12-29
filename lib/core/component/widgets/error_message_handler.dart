import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';

//! ErrorMessageHandler
class ErrorMessageHandler {
  static String processErrorMessage(
    BuildContext context,
    String errorMessage, {
    int maxLength = 100,
  }) {

    final displayMessage = errorMessage.length > maxLength ||
            errorMessage.contains('<html') ||
            errorMessage.contains('<!DOCTYPE')
        ? 'unexpected_error'.tr(context)
        : errorMessage.tr(context);

    return displayMessage;
  }

  static void showErrorToast(
    BuildContext context,
    String errorMessage, {
    int maxLength = 100,
    Duration duration = const Duration(seconds: 3),
  }) {
    final displayMessage =
        processErrorMessage(context, errorMessage, maxLength: maxLength);

    showToast(
      context,
      message: displayMessage,
      state: ToastStates.error,
      duration: duration,
    );
  }
}
