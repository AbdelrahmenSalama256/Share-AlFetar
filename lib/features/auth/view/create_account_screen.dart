import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/component/widgets/app_title.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/data/repo/register_repo.dart';
import 'package:cozy/features/auth/view/cubit/register_cubit.dart';
import 'package:cozy/features/auth/view/cubit/register_state.dart';
import 'package:cozy/features/auth/view/verification_screen.dart';
import 'package:cozy/features/base/view/base_screen.dart';
import '../../../core/constants/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/error_message_handler.dart';
import '../../../core/component/widgets/profile_image_picker.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/utils/password_strength_toggle.dart';

//! CreateAccountScreen
class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => RegisterCubit(sl<RegisterRepo>()),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterError) {
              ErrorMessageHandler.showErrorToast(context, state.message);
            } else if (state is RegisterSuccess) {
              showToast(
                context,
                message: state.message.tr(context),
                state: ToastStates.success,
                duration: const Duration(seconds: 3),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificationScreen(
                      emailOrPhoneForOtp: state.emailForVerification),
                ),
              );
            }
          },
          builder: (context, state) {
            final registerCubit = context.read<RegisterCubit>();
            final formKey = registerCubit.formKey;

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 20.h),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(
                              titleKey: "auth_create_account_title".tr(context),
                              subtitleKey:
                                  "auth_create_account_subtitle".tr(context),
                            ),
                            SizedBox(height: 30.h),
                            Center(
                              child: ProfileImagePicker(
                                profileImage: registerCubit.profileImage,
                                onImageSelected: registerCubit.setProfileImage,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            AppTextField(
                              enabled: state is RegisterLoading ? false : true,
                              controller: registerCubit.usernameController,
                              labelText: "auth_username_label".tr(context),
                              hintText: "auth_username_hint".tr(context),
                              prefixIcon: Icon(Icons.person_outline,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              validator: (value) =>
                                  Validators.validateName(value, context),
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              enabled: state is RegisterLoading ? false : true,
                              controller: registerCubit.nameController,
                              labelText: "auth_name_label".tr(context),
                              hintText: "auth_name_hint".tr(context),
                              prefixIcon: Icon(Icons.person_outline,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              validator: (value) =>
                                  Validators.validateName(value, context),
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              enabled: state is RegisterLoading ? false : true,
                              controller: registerCubit.mobileController,
                              labelText: "auth_mobile_label".tr(context),
                              hintText: "auth_mobile_hint".tr(context),
                              prefixIcon: Icon(Icons.phone,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  Validators.validatePhone(value, context),
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              controller: registerCubit.emailController,
                              enabled: state is RegisterLoading ? false : true,
                              labelText: "auth_email_phone_label".tr(context),
                              hintText: "auth_email_phone_hint".tr(context),
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  Validators.validateEmail(value, context),
                            ),
                            SizedBox(height: 20.h),
                            PasswordFieldWithToggle(
                              isEnabled:
                                  state is RegisterLoading ? false : true,
                              controller: registerCubit.passwordController,
                              labelText: "auth_password_label",
                              hintText: "auth_password_hint",
                              onChanged: (value) {
                                final form = Form.of(context);
                                form.validate();
                              },
                              isPasswordObscure:
                                  registerCubit.isPasswordObscure,
                              togglePasswordVisibility:
                                  registerCubit.togglePasswordVisibility,
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              controller:
                                  registerCubit.passwordConfirmationController,
                              enabled: state is RegisterLoading ? false : true,
                              labelText: "auth_password_confirmation_label"
                                  .tr(context),
                              hintText:
                                  "auth_password_confirmation_hint".tr(context),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              obscureText: registerCubit.isPasswordObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  registerCubit.isPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.primary,
                                ),
                                onPressed:
                                    registerCubit.togglePasswordVisibility,
                              ),
                              validator: (value) {
                                if (value !=
                                    registerCubit.passwordController.text) {
                                  return 'passwords_do_not_match'.tr(context);
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30.h),
                            AppButton(
                                text: "onboarding_create_account".tr(context),
                                isLoading: state is RegisterLoading,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    registerCubit.attemptAccountCreation();
                                  }
                                }),
                            SizedBox(height: 12.h),
                            AppButton(
                              text: 'continue_as_guest'.tr(context),
                              type: AppButtonType.secondary,
                              onPressed: () {
                                navigateAndFinish(context, const BaseScreen());
                              },
                            ),
                            SizedBox(height: 30.h),






















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
