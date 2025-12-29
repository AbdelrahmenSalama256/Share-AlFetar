
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/payment_method.dart';

//! PaymentCard
class PaymentCard extends StatelessWidget {
  final PaymentMethod payment;
  final bool isSelected;

  const PaymentCard({
    super.key,
    required this.payment,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4.r),
        border:
            isSelected ? Border.all(color: AppColors.primary, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(
            payment.icon,
            color: isSelected ? AppColors.primary : AppColors.textGrey,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.type,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  payment.details,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
