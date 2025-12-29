import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:cozy/features/auth/view/widgets/create_new_password_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/component/custom_toast.dart';
import 'custom_bottom_sheet.dart';

//! OtpBottomSheetForReset
class OtpBottomSheetForReset extends StatefulWidget {
  final String emailOrPhoneForOtp;
  const OtpBottomSheetForReset({super.key, required this.emailOrPhoneForOtp});

  @override
  State<OtpBottomSheetForReset> createState() => _OtpBottomSheetForResetState();
}

//! _OtpBottomSheetForResetState
class _OtpBottomSheetForResetState extends State<OtpBottomSheetForReset> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthOtpVerificationSuccess) {
              showToast(
                context,
                message: state.message.tr(context),
                state: ToastStates.success,
                duration: const Duration(seconds: 3),
              );
              Navigator.pop(context); // Dismiss the OTP bottom sheet
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CustomBottomSheet.show(
                  context: context,
                  child: BlocProvider.value(
                    value: authCubit,
                    child: const CreateNewPasswordBottomSheet(),
                  ),
                );
              });
            } else if (state is AuthFailure) {
              Navigator.pop(context); // Dismiss the OTP bottom sheet
              showToast(
                context,
                message: state.error.tr(context),
                state: ToastStates.error,
                duration: const Duration(seconds: 3),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "auth_verification_code_label".tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "auth_verification_message".tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textGrey,
                          ),
                        ),
                        TextSpan(
                          text: widget.emailOrPhoneForOtp,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Pinput(
                    controller: authCubit.otpController,
                    length: 4,
                    defaultPinTheme: PinTheme(
                      width: 56.w,
                      height: 60.h,
                      textStyle: TextStyle(
                        fontSize: 22.sp,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFieldBackground,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: Colors.transparent),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56.w,
                      height: 60.h,
                      textStyle: TextStyle(
                        fontSize: 22.sp,
                        color: AppColors.textBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFieldBackground,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: AppColors.primaryLight,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) =>
                        Validators.validateOtp(value, context),
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: "auth_submit_button".tr(context),
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        authCubit.verifyResetOtpAndShowCreateNewPassword();
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () {
                      authCubit.sendForgotPasswordCode();
                    },
                    child: Text(
                      "auth_resend_code".tr(context),
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
