
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cozy/core/utils/currency_formatter.dart';

import '../../../../core/component/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';

//! CheckoutBottomSection
class CheckoutBottomSection extends StatelessWidget {
  final double total;
  final bool isProcessing;
  final VoidCallback onPlaceOrder;

  const CheckoutBottomSection({
    super.key,
    required this.total,
    required this.isProcessing,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(context),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              Text(
                formatCurrency(context, total),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          AppButton(
            onPressed: isProcessing ? null : onPlaceOrder,
            text: 'place_order'.tr(context),
            isLoading: isProcessing,
          ),
        ],
      ),
    );
  }
}
