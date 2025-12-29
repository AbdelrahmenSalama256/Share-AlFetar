import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/component/widgets/app_title.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/create_account_screen.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:cozy/features/auth/view/widgets/custom_bottom_sheet.dart';
import 'package:cozy/features/auth/view/widgets/forgot_password_bottom_sheet.dart';
import 'package:cozy/features/base/view/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_toast.dart';

//! LoginScreen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              showToast(
                context,
                message: state.message.tr(context),
                state: ToastStates.success,
                duration: const Duration(seconds: 3),
              );
              context.read<GlobalCubit>().getProfile(forceRefresh: true);
              context.read<GlobalCubit>().changeBottomNavIndex(0);
              navigateAndFinish(context, const BaseScreen());
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
            final authCubit = context.read<AuthCubit>();
            final formKey = GlobalKey<FormState>();

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 20.h),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SectionHeader(
                              titleKey: "auth_login_title".tr(context),
                              subtitleKey: "auth_login_subtitle".tr(context),
                            ),
                            SizedBox(height: 30.h),
                            AppTextField(
                              controller: authCubit.loginEmailController,
                              enabled: state is AuthLoading ? false : true,
                              labelText: "auth_email_phone_label".tr(context),
                              hintText: "auth_email_phone_hint".tr(context),
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              keyboardType: TextInputType.name,
                              validator: (value) =>
                                  Validators.validateName(value, context),
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              controller: authCubit.loginPasswordController,
                              enabled: state is AuthLoading ? false : true,
                              labelText: "auth_password_label".tr(context),
                              hintText: "auth_password_hint".tr(context),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              obscureText: authCubit.isLoginPasswordObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authCubit.isLoginPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textGrey,
                                ),
                                onPressed: () {
                                  authCubit.togglePasswordVisibility('login');
                                },
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  CustomBottomSheet.show(
                                    context: context,
                                    child: BlocProvider.value(
                                      value: authCubit,
                                      child: const ForgotPasswordBottomSheet(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "auth_forgot_password_link".tr(context),
                                  style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            AppButton(
                              text: "auth_sign_in_button".tr(context),
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                authCubit.attemptLogin(formKey);
                              },
                            ),
                            SizedBox(height: 12.h),
                            AppButton(
                              text: 'continue_as_guest'.tr(context),
                              type: AppButtonType.secondary,
                              onPressed: () {
                                // Ensure we are in guest mode (no token) and go to app
                                context.read<GlobalCubit>().changeBottomNavIndex(0);
                                navigateAndFinish(context, const BaseScreen());
                              },
                            ),
                            SizedBox(height: 30.h),






















                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("auth_dont_have_account".tr(context),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textGrey)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                                value: authCubit,
                                                child:
                                                    const CreateAccountScreen())));
                                  },
                                  child: Text(
                                      "onboarding_create_account".tr(context),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.primaryLight,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            )
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
      ),
    );
  }
}
