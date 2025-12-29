import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/payment_method_model.dart';
import 'package:cozy/features/profile/view/widgets/payment_method_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'add_payment_method_screen.dart';

//! PaymentMethodsScreen
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

//! _PaymentMethodsScreenState
class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<PaymentMethodModel> paymentMethods = [
    PaymentMethodModel(
      id: '1',
      type: PaymentMethodType.card,
      cardNumber: '**** **** **** 1234',
      cardHolderName: 'John Doe',
      expiryDate: '12/25',
      cardType: 'Visa',
      isDefault: true,
    ),
    PaymentMethodModel(
      id: '2',
      type: PaymentMethodType.card,
      cardNumber: '**** **** **** 5678',
      cardHolderName: 'John Doe',
      expiryDate: '08/26',
      cardType: 'Mastercard',
      isDefault: false,
    ),
    PaymentMethodModel(
      id: '3',
      type: PaymentMethodType.paypal,
      email: 'john.doe@example.com',
      isDefault: false,
    ),
  ];

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
          'payment_methods'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPaymentMethodScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: paymentMethods.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                return PaymentMethodCard(
                  paymentMethod: paymentMethods[index],
                  onEdit: () => _editPaymentMethod(paymentMethods[index]),
                  onDelete: () =>
                      _deletePaymentMethod(paymentMethods[index].id),
                  onSetDefault: () =>
                      _setDefaultPaymentMethod(paymentMethods[index].id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPaymentMethodScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 80.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_payment_methods'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'add_payment_method_message'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          AppButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPaymentMethodScreen(),
                ),
              );
            },
            text: 'add_payment_method'.tr(context),
          ),
        ],
      ),
    );
  }

  void _editPaymentMethod(PaymentMethodModel paymentMethod) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddPaymentMethodScreen(paymentMethod: paymentMethod),
      ),
    );
  }

  void _deletePaymentMethod(String paymentMethodId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_payment_method'.tr(context)),
        content: Text('delete_payment_method_confirmation'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(context)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                paymentMethods
                    .removeWhere((method) => method.id == paymentMethodId);
              });
              Navigator.pop(context);
            },
            child: Text(
              'delete'.tr(context),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _setDefaultPaymentMethod(String paymentMethodId) {
    setState(() {
      for (var method in paymentMethods) {
        method.isDefault = method.id == paymentMethodId;
      }
    });
  }
}
