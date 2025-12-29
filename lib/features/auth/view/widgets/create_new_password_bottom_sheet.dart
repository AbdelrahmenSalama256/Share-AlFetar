import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/custom_toast.dart';

//! CreateNewPasswordBottomSheet
class CreateNewPasswordBottomSheet extends StatefulWidget {
  const CreateNewPasswordBottomSheet({super.key});

  @override
  State<CreateNewPasswordBottomSheet> createState() =>
      _CreateNewPasswordBottomSheetState();
}

//! _CreateNewPasswordBottomSheetState
class _CreateNewPasswordBottomSheetState
    extends State<CreateNewPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthResetPasswordSuccess) {
          Navigator.of(context).pop();
          showToast(
            context,
            message: state.message.tr(context),
            state: ToastStates.success,
            duration: const Duration(seconds: 3),
          );
        } else if (state is AuthFailure) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "auth_create_new_password_title".tr(context),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "auth_create_new_password_sheet_subtitle".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
              ),
              SizedBox(height: 24.h),
              _buildPasswordField(authCubit, 'new'),
              SizedBox(height: 20.h),
              _buildPasswordField(authCubit, 'confirm'),
              SizedBox(height: 24.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return AppButton(
                    text: "auth_change_password_button".tr(context),
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        authCubit.attemptResetPassword(_formKey);
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(AuthCubit authCubit, String type) {
    final isNew = type == 'new';
    return AppTextField(
      controller: isNew
          ? authCubit.newPasswordController
          : authCubit.confirmNewPasswordController,
      labelText: isNew
          ? "auth_new_password_label".tr(context)
          : "auth_confirm_password_label".tr(context),
      hintText: isNew
          ? "auth_password_hint".tr(context)
          : "auth_confirm_password_hint".tr(context),
      prefixIcon: Icon(
        Icons.lock_outline,
        color: AppColors.textGrey.withOpacity(0.7),
      ),
      obscureText: isNew
          ? authCubit.isNewPasswordObscure
          : authCubit.isConfirmNewPasswordObscure,
      suffixIcon: IconButton(
        icon: Icon(
          (isNew
                  ? authCubit.isNewPasswordObscure
                  : authCubit.isConfirmNewPasswordObscure)
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textGrey,
        ),
        onPressed: () => authCubit.togglePasswordVisibility(type),
      ),
      validator: isNew
          ? (value) =>
              Validators.validatePassword(value, context, isStrong: false)
          : (value) => Validators.validateConfirmPassword(
                value,
                authCubit.newPasswordController.text,
                context,
              ),
    );
  }
}
