import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_text_field.dart';
import 'cubit/customer_service_cubit.dart';
import 'cubit/customer_service_state.dart';

//! GeneralInquiryScreen
class GeneralInquiryScreen extends StatefulWidget {
  const GeneralInquiryScreen({super.key});

  @override
  State<GeneralInquiryScreen> createState() => _GeneralInquiryScreenState();
}

//! _GeneralInquiryScreenState
class _GeneralInquiryScreenState extends State<GeneralInquiryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) => CustomerServiceCubit()..initializeWithUserData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Text(
            'general_inquiry'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocConsumer<CustomerServiceCubit, CustomerServiceState>(
          listener: (context, state) {
            if (state is CustomerServiceSuccess) {
              _showSuccessDialog(context, state.message);
            } else if (state is CustomerServiceError) {
              showToast(context,
                  message: state.message, state: ToastStates.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<CustomerServiceCubit>();

            return Form(
              key: cubit.formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 24.h),
                    _buildNameField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildEmailField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildPhoneField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildCategoryDropdown(context, cubit),
                    SizedBox(height: 16.h),
                    _buildSubjectField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildMessageField(context, cubit),
                    SizedBox(height: 24.h),
                    _buildSubmitButton(
                        context, cubit, state is CustomerServiceLoading),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ask_us_anything'.tr(context),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'response_time'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      controller: cubit.nameController,
      labelText: 'full_name'.tr(context),
      hintText: 'enter_full_name'.tr(context),
      validator: (value) =>
          value!.isEmpty ? 'please_enter_name'.tr(context) : null,
    );
  }

  Widget _buildEmailField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      controller: cubit.emailController,
      labelText: 'email_address'.tr(context),
      hintText: 'enter_email'.tr(context),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) return 'please_enter_email'.tr(context);
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'enter_valid_email'.tr(context);
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      controller: cubit.phoneController,
      labelText: 'phone_number'.tr(context),
      hintText: 'enter_phone'.tr(context),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildCategoryDropdown(
      BuildContext context, CustomerServiceCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'category'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: cubit.selectedCategory,
              isExpanded: true,
              items: cubit.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category.tr(context)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                cubit.updateSelectedCategory(newValue!);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      controller: cubit.subjectController,
      labelText: 'subject'.tr(context),
      hintText: 'subject_hint'.tr(context),
      validator: (value) =>
          value!.isEmpty ? 'please_enter_subject'.tr(context) : null,
    );
  }

  Widget _buildMessageField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      controller: cubit.messageController,
      labelText: 'message'.tr(context),
      hintText: 'message_hint'.tr(context),
      maxLines: 5,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_message'.tr(context) : null,
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    CustomerServiceCubit cubit,
    bool isLoading,
  ) {
    return AppButton(
      onPressed: isLoading ? null : () => _submitForm(context, cubit),
      text: 'submit_inquiry'.tr(context),
      type: AppButtonType.primary,
    );
  }

  void _submitForm(BuildContext context, CustomerServiceCubit cubit) {
    if (cubit.formKey.currentState!.validate()) {
      cubit.submitTicket(type: 'inquiry');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('inquiry_success'.tr(context)),
        content: Text(message),
        actions: [
          AppButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            text: 'ok'.tr(context),
            type: AppButtonType.secondary,
            height: 36.h,
            borderRadius: BorderRadius.circular(8.r),
            borderColor: AppColors.textGrey,
            textStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
