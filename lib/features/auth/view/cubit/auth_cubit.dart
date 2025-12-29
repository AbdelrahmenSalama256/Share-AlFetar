import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cozy/core/common/logs.dart';
import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/auth/data/repo/login_repo.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/widgets/print_util.dart';
import '../../../../core/cubit/global_cubit.dart';
import '../../../../core/network/local_network.dart';
import 'auth_state.dart';

//! AuthCubit
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    usernameController = TextEditingController();
    createAccountEmailController = TextEditingController();
    createAccountPasswordController = TextEditingController();
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    forgotPasswordEmailController = TextEditingController();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  late TextEditingController usernameController;
  late TextEditingController createAccountEmailController;
  late TextEditingController createAccountPasswordController;
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  late TextEditingController forgotPasswordEmailController;
  late TextEditingController otpController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isCreateAccountPasswordObscure = true;
  bool isLoginPasswordObscure = true;
  bool isNewPasswordObscure = true;
  bool isConfirmNewPasswordObscure = true;

  void togglePasswordVisibility(String fieldType) {
    if (fieldType == 'createAccount') {
      isCreateAccountPasswordObscure = !isCreateAccountPasswordObscure;
    } else if (fieldType == 'login') {
      isLoginPasswordObscure = !isLoginPasswordObscure;
    } else if (fieldType == 'new') {
      isNewPasswordObscure = !isNewPasswordObscure;
    } else if (fieldType == 'confirm') {
      isConfirmNewPasswordObscure = !isConfirmNewPasswordObscure;
    }
    emit(AuthPasswordVisibilityChanged(
        isObscure: _getObscurityStatus(fieldType), fieldType: fieldType));
  }

  bool _getObscurityStatus(String fieldType) {
    if (fieldType == 'createAccount') return isCreateAccountPasswordObscure;
    if (fieldType == 'login') return isLoginPasswordObscure;
    if (fieldType == 'new') return isNewPasswordObscure;
    if (fieldType == 'confirm') return isConfirmNewPasswordObscure;
    return true;
  }

  Future<void> attemptAccountCreation(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 1));
    emit(AuthCreateAccountSuccess(
        message: "auth_create_account_success",
        emailForVerification: createAccountEmailController.text));
  }

  Future<void> verifyOtpForAccountCreation() async {
    emit(AuthOtpVerificationLoading());
    await Future.delayed(Duration(seconds: 1));
    final otp = otpController.text;
    if (otp.length != 4) {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    if (otp == "0000") {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    otpController.clear();
    emit(AuthOtpVerificationSuccess(message: "auth_otp_verified_success"));
  }

  Future<void> attemptLogin(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    try {
      final loginRepo = sl<LoginRepo>();
      final response = await loginRepo.loginUser(
        username: loginEmailController.text,
        password: loginPasswordController.text,
      );

      response.fold(
        (error) {
          Print.error("Login failed: $error");
          emit(AuthFailure(error: error));
        },
        (contactResponse) async {

          if (contactResponse.data.token != null) {
            sl<CacheHelper>()
                .setData(AppConstants.token, contactResponse.data.token!);
          }


          await sl<CacheHelper>().setData(
              AppConstants.userProfile, jsonEncode(contactResponse.toJson()));

          PrintUtil.success(
              "Login successful for user: ${contactResponse.data.user.name}");


          sl<GlobalCubit>().contactResponse = contactResponse;

          emit(AuthLoginSuccess(message: 'auth_login_success'));
        },
      );
    } catch (e) {
      Print.error("Unexpected error during login: $e");
      emit(AuthFailure(error: "unexpected_error"));
    }
  }

  Future<void> sendForgotPasswordCode() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    final loginRepo = sl<LoginRepo>();
    final response = await loginRepo.sendForgotPasswordCode(
      forgotPasswordEmailController.text.trim(),
    );

    response.fold(
      (error) {
        Print.error("Failed to send forgot password code: $error");
        emit(AuthFailure(error: error));
      },
      (message) {
        Print.success("Forgot password OTP sent: $message");
        emit(AuthForgotPasswordOtpSent(
          message: message,
          emailOrPhone: forgotPasswordEmailController.text,
        ));
      },
    );
  }

  Future<void> verifyResetOtpAndShowCreateNewPassword() async {
    emit(AuthOtpVerificationLoading());
    await Future.delayed(Duration(seconds: 1));
    final otp = otpController.text;
    if (otp.length != 4) {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    if (otp == "0000") {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    otpController.clear();
    emit(AuthOtpVerificationSuccess(message: "auth_otp_verified_reset"));
  }

  Future<void> attemptResetPassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 1));
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    emit(AuthResetPasswordSuccess(message: "auth_password_reset_success"));
  }

  void disposeAllControllers() {
    usernameController.dispose();
    createAccountEmailController.dispose();
    createAccountPasswordController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }

  @override
  Future<void> close() {
    disposeAllControllers();
    return super.close();
  }
}
