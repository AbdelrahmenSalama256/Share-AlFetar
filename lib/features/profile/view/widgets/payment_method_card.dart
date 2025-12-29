import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! PaymentMethodCard
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: paymentMethod.isDefault
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: _getPaymentMethodColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  _getPaymentMethodIcon(),
                  color: _getPaymentMethodColor(),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod.displayName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      paymentMethod.displayInfo,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              if (paymentMethod.isDefault)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'default'.tr(context),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              SizedBox(width: 8.w),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                    case 'default':
                      onSetDefault();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 16.sp),
                        SizedBox(width: 8.w),
                        Text('edit'.tr(context)),
                      ],
                    ),
                  ),
                  if (!paymentMethod.isDefault)
                    PopupMenuItem(
                      value: 'default',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 16.sp),
                          SizedBox(width: 8.w),
                          Text('set_default'.tr(context)),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 16.sp, color: AppColors.error),
                        SizedBox(width: 8.w),
                        Text('delete'.tr(context),
                            style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: AppColors.textGrey,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          if (paymentMethod.type == PaymentMethodType.card &&
              paymentMethod.expiryDate != null) ...[
            SizedBox(height: 8.h),
            Text(
              '${'expires'.tr(context)}: ${paymentMethod.expiryDate}',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon() {
    switch (paymentMethod.type) {
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

  Color _getPaymentMethodColor() {
    switch (paymentMethod.type) {
      case PaymentMethodType.card:
        return AppColors.primary;
      case PaymentMethodType.paypal:
        return Colors.blue;
      case PaymentMethodType.applePay:
        return Colors.black;
      case PaymentMethodType.googlePay:
        return Colors.green;
      case PaymentMethodType.bankTransfer:
        return Colors.purple;
    }
  }
}
