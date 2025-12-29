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

//! ReturnRequestScreen
class ReturnRequestScreen extends StatefulWidget {
  const ReturnRequestScreen({super.key});

  @override
  State<ReturnRequestScreen> createState() => _ReturnRequestScreenState();
}

//! _ReturnRequestScreenState
class _ReturnRequestScreenState extends State<ReturnRequestScreen>
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
            'return_refund'.tr(context),
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
                    _buildOrderNumberField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildEmailField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildRequestTypeDropdown(context, cubit),
                    SizedBox(height: 16.h),
                    _buildReasonDropdown(context, cubit),
                    SizedBox(height: 16.h),
                    _buildDescriptionField(context, cubit),
                    SizedBox(height: 24.h),
                    _buildReturnPolicyNote(context),
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
          'return_request'.tr(context),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'provide_order_details'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderNumberField(
      BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      labelText: 'order_number'.tr(context),
      hintText: 'enter_order_number'.tr(context),
      controller: cubit.orderNumberController,
      validator: (value) =>
          value!.isEmpty ? 'please_enter_order'.tr(context) : null,
    );
  }

  Widget _buildEmailField(BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      labelText: 'email_address'.tr(context),
      hintText: 'order_email'.tr(context),
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

  Widget _buildRequestTypeDropdown(
      BuildContext context, CustomerServiceCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'request_type'.tr(context),
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
              value: cubit.requestType,
              isExpanded: true,
              items: cubit.requestTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type.tr(context)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                cubit.updateRequestType(newValue!);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonDropdown(
      BuildContext context, CustomerServiceCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'reason'.tr(context),
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
              value: cubit.returnReason,
              isExpanded: true,
              items: cubit.returnReasons.map((String reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(reason.tr(context)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                cubit.updateReturnReason(newValue!);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(
      BuildContext context, CustomerServiceCubit cubit) {
    return AppTextField(
      labelText: 'additional_details'.tr(context),
      hintText: 'request_details'.tr(context),
      controller: cubit.descriptionController,
      maxLines: 4,
      validator: (value) =>
          value!.isEmpty ? 'please_provide_details'.tr(context) : null,
    );
  }

  Widget _buildReturnPolicyNote(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.black),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.black,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'return_policy_note'.tr(context),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, CustomerServiceCubit cubit, bool isLoading) {
    return AppButton(
      onPressed: isLoading ? null : () => _submitForm(context, cubit),
      text: 'submit_request'.tr(context),
      isLoading: isLoading,
      type: AppButtonType.primary,
      backgroundColor: AppColors.warning,
    );
  }

  void _submitForm(BuildContext context, CustomerServiceCubit cubit) {
    if (cubit.formKey.currentState!.validate()) {
      cubit.submitTicket(
        type: cubit.requestType,
        orderNumber: cubit.orderNumberController.text.isEmpty
            ? null
            : cubit.orderNumberController.text,
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('request_submitted'.tr(context)),
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
