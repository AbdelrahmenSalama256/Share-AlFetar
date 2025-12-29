import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthCreateAccountSuccess extends AuthState {
  final String message;
  final String emailForVerification;
  AuthCreateAccountSuccess(
      {required this.message, required this.emailForVerification});
}

final class AuthLoginSuccess extends AuthState {
  final String message;
  AuthLoginSuccess({required this.message});
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}

final class AuthPasswordVisibilityChanged extends AuthState {
  final bool isObscure;
  final String fieldType;
  AuthPasswordVisibilityChanged(
      {required this.isObscure, required this.fieldType});
}

final class AuthOtpVerificationLoading extends AuthState {}

final class AuthOtpVerificationSuccess extends AuthState {
  final String message;
  AuthOtpVerificationSuccess({required this.message});
}

final class AuthForgotPasswordOtpSent extends AuthState {
  final String message;
  final String emailOrPhone;
  AuthForgotPasswordOtpSent(
      {required this.message, required this.emailOrPhone});
}

final class AuthResetPasswordSuccess extends AuthState {
  final String message;
  AuthResetPasswordSuccess({required this.message});
}
