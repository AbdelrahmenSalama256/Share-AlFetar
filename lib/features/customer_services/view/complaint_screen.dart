import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_toast.dart';
import 'cubit/customer_service_cubit.dart';
import 'cubit/customer_service_state.dart';

//! ComplaintScreen
class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

//! _ComplaintScreenState
class _ComplaintScreenState extends State<ComplaintScreen>
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
            'complaint_feedback'.tr(context),
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
                    _buildOrderNumberField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildComplaintTypeDropdown(context, cubit),
                    SizedBox(height: 16.h),
                    _buildPriorityLevelSlider(context, cubit),
                    SizedBox(height: 16.h),
                    _buildSubjectField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildDescriptionField(context, cubit),
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
          'share_feedback'.tr(context),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'help_us_improve'.tr(context),
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
      labelText: 'full_name'.tr(context),
      hintText: 'enter_full_name'.tr(context),
      controller: cubit.nameController,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_name'.tr(context) : null,
    );
  }

  Widget _buildEmailField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      labelText: 'email_address'.tr(context),
      hintText: 'enter_email'.tr(context),
      controller: cubit.emailController,
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

  Widget _buildOrderNumberField(
      BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      labelText: 'order_number_optional'.tr(context),
      hintText: 'enter_order_number'.tr(context),
      controller: cubit.orderNumberController,
    );
  }

  Widget _buildComplaintTypeDropdown(
      BuildContext context, CustomerServiceCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'complaint_type'.tr(context),
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
              value: cubit.complaintType,
              isExpanded: true,
              items: cubit.complaintTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type.tr(context)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                cubit.updateComplaintType(newValue!);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityLevelSlider(
      BuildContext context, CustomerServiceCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'priority_level'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'low'.tr(context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '1',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Slider(
                value: cubit.severityLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: cubit.severityLevel <= 2
                    ? Colors.green
                    : cubit.severityLevel <= 3
                        ? Colors.orange
                        : Colors.red,
                onChanged: (double value) {
                  cubit.updateSeverityLevel(value.round());
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'high'.tr(context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '5',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      labelText: 'subject'.tr(context),
      hintText: 'subject_hint'.tr(context),
      controller: cubit.subjectController,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_subject'.tr(context) : null,
    );
  }

  Widget _buildDescriptionField(
      BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      labelText: 'detailed_description'.tr(context),
      hintText: 'description_hint'.tr(context),
      controller: cubit.complaintController,
      maxLines: 5,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_description'.tr(context) : null,
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, CustomerServiceCubit cubit, bool isLoading) {
    return AppButton(
      onPressed: isLoading ? null : () => _submitForm(context, cubit),
      text: 'submit_complaint'.tr(context),
      type: AppButtonType.primary,
      backgroundColor: AppColors.warning,
    );
  }

  void _submitForm(BuildContext context, CustomerServiceCubit cubit) {
    if (cubit.formKey.currentState!.validate()) {
      cubit.submitTicket(
        type: 'complaints',
        orderNumber: cubit.orderNumberController.text.isEmpty
            ? null
            : cubit.orderNumberController.text,
        severity: cubit.severityLevel,
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('complaint_submitted'.tr(context)),
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
