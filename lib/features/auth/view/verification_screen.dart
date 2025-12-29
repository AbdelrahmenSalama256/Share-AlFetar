import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_header.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../core/component/custom_toast.dart';
import 'widgets/create_new_password_bottom_sheet.dart';

//! VerificationScreen
class VerificationScreen extends StatelessWidget {
  final String emailOrPhoneForOtp;
  const VerificationScreen({super.key, required this.emailOrPhoneForOtp});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final formKey = GlobalKey<FormState>();

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: TextStyle(
          fontSize: 22.sp,
          color: AppColors.textBlack,
          fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: AppColors.inputFieldBackground,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryLight, width: 2),
      borderRadius: BorderRadius.circular(8.r),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpVerificationSuccess) {
            showToast(
              context,
              message: state.message.tr(context),
              state: ToastStates.success,
              duration: const Duration(seconds: 3),
            );
            Navigator.pop(context); // Dismiss the current OTP bottom sheet
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: authCubit,
                  child: const CreateNewPasswordBottomSheet(),
                ),
              );
            });
          } else if (state is AuthFailure) {
            showToast(
              context,
              message: state.error.tr(context),
              state: ToastStates.error,
              duration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: "auth_verification_title".tr(context),
                  titleStyle: TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600),
                  showBackButton: true,
                  centerTitle: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Icon(Icons.mark_email_unread_outlined,
                              size: 80.sp, color: AppColors.primaryLight),
                          SizedBox(height: 20.h),
                          Text(
                            "auth_verification_code_label".tr(context),
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "We have sent the code verification to".tr(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textGrey,
                                height: 1.5.h),
                          ),
                          Text(
                            emailOrPhoneForOtp,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.w600,
                                height: 1.5.h),
                          ),
                          SizedBox(height: 30.h),
                          Pinput(
                            controller: authCubit.otpController,
                            length: 4,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            validator: (value) =>
                                Validators.validateOtp(value, context),
                          ),
                          SizedBox(height: 40.h),
                          AppButton(
                            text: "auth_submit_button".tr(context),
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                authCubit.verifyOtpForAccountCreation();
                              }
                            },
                            backgroundColor: AppColors.primary,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("auth_didnt_receive_code".tr(context),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textGrey)),
                              TextButton(
                                onPressed: () {
                                  authCubit.sendForgotPasswordCode();
                                },
                                child: Text(
                                  "auth_resend_code".tr(context),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
