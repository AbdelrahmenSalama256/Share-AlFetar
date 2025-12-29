import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';

//! Validators
class Validators {
  static String? validateEmailOrPhone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'email_or_phone_required'.tr(context);
    }


    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');

    if (!emailRegExp.hasMatch(value) && !phoneRegExp.hasMatch(value)) {
      return 'invalid_email_or_phone'.tr(context);
    }

    return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr(context);
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'invalid_email'.tr(context);
    }

    return null;
  }

  static String? validatePassword(String? value, BuildContext context,
      {bool isStrong = false}) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr(context);
    }
    if (value.length < 8) {
      return 'password_too_short'.tr(context);
    }
    if (isStrong) {
      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)) {
        return 'password_weak'.tr(context);
      }
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? value, String password, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_required'.tr(context);
    }

    if (value != password) {
      return 'passwords_not_match'.tr(context);
    }

    return null;
  }

  static String? validateRequired(
      String? value, String fieldName, BuildContext context) {
    if (value == null || value.isEmpty) {
      return '$fieldName ${"is_required".tr(context)}';
    }

    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'phone_required'.tr(context);
    }

    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'invalid_phone'.tr(context);
    }

    return null;
  }

  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'name_required'.tr(context);
    }

    if (value.length < 2) {
      return 'name_length'.tr(context);
    }

    return null;
  }

  static String? validateOtp(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'otp_required'.tr(context);
    }

    if (value.length != 4) {
      return 'invalid_otp'.tr(context);
    }

    return null;
  }
}
