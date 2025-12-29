import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_button.dart';
import '../data/models/payment_method_model.dart';

//! AddPaymentMethodScreen
class AddPaymentMethodScreen extends StatefulWidget {
  final PaymentMethodModel? paymentMethod;

  const AddPaymentMethodScreen({super.key, this.paymentMethod});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

//! _AddPaymentMethodScreenState
class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _emailController = TextEditingController();

  PaymentMethodType _selectedType = PaymentMethodType.card;
  bool _isDefault = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod != null) {
      _isEditing = true;
      _selectedType = widget.paymentMethod!.type;
      _cardNumberController.text = widget.paymentMethod!.cardNumber ?? '';
      _cardHolderController.text = widget.paymentMethod!.cardHolderName ?? '';
      _expiryController.text = widget.paymentMethod!.expiryDate ?? '';
      _emailController.text = widget.paymentMethod!.email ?? '';
      _isDefault = widget.paymentMethod!.isDefault;
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing
              ? 'edit_payment_method'.tr(context)
              : 'add_payment_method'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'payment_method_type'.tr(context),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildPaymentTypeOption(PaymentMethodType.card,
                        'Credit/Debit Card', Icons.credit_card),
                    _buildPaymentTypeOption(PaymentMethodType.paypal, 'PayPal',
                        Icons.account_balance_wallet),
                    _buildPaymentTypeOption(PaymentMethodType.applePay,
                        'Apple Pay', Icons.phone_iphone),
                    _buildPaymentTypeOption(PaymentMethodType.googlePay,
                        'Google Pay', Icons.android),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              if (_selectedType == PaymentMethodType.card) ...[
                Text(
                  'card_details'.tr(context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  labelText: 'card_number'.tr(context),
                  hintText: '1234 5678 9012 3456',
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty
                      ? 'card_number_required'.tr(context)
                      : null,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  labelText: 'card_holder_name'.tr(context),
                  hintText: 'Enter cardholder name',
                  controller: _cardHolderController,
                  validator: (value) => value!.isEmpty
                      ? 'card_holder_required'.tr(context)
                      : null,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        labelText: 'expiry_date'.tr(context),
                        hintText: 'MM/YY',
                        controller: _expiryController,
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.isEmpty
                            ? 'expiry_required'.tr(context)
                            : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AppTextField(
                        labelText: 'cvv'.tr(context),
                        hintText: '123',
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (value) =>
                            value!.isEmpty ? 'cvv_required'.tr(context) : null,
                      ),
                    ),
                  ],
                ),
              ] else if (_selectedType == PaymentMethodType.paypal) ...[
                Text(
                  'paypal_details'.tr(context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  labelText: 'paypal_email'.tr(context),
                  hintText: 'Enter PayPal email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'email_required'.tr(context);
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getPaymentMethodIcon(_selectedType),
                        size: 60.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'setup_${_selectedType.toString().split('.').last}'
                            .tr(context),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'You will be redirected to complete the setup',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'set_as_default'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'use_as_default_payment'.tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: AppButton(
                  onPressed: _savePaymentMethod,
                  height: 50.h,
                  isLoading: _isEditing,
                  text: _isEditing
                      ? 'update_payment_method'.tr(context)
                      : 'save_payment_method'.tr(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTypeOption(
      PaymentMethodType type, String title, IconData icon) {
    final isSelected = _selectedType == type;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textGrey,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.textBlack,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.card:
        return Icons.credit_card;
      case PaymentMethodType.paypal:
        return Icons.account_balance_wallet;
      case PaymentMethodType.applePay:
        return Icons.phone_iphone;
      case PaymentMethodType.googlePay:
        return Icons.android;
      case PaymentMethodType.bankTransfer:
        return Icons.account_balance;
    }
  }

  void _savePaymentMethod() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_isEditing
              ? 'payment_method_updated'.tr(context)
              : 'payment_method_saved'.tr(context)),
          content: Text(_isEditing
              ? 'Your payment method has been updated successfully.'
              : 'Your payment method has been saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
