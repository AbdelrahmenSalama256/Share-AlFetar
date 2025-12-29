import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cozy/core/utils/currency_formatter.dart';

import '../../../../core/constants/app_colors.dart';
import 'section_container.dart';

//! DeliveryOptionsSection
class DeliveryOptionsSection extends StatelessWidget {
  const DeliveryOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'delivery_options'.tr(context),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          _buildDeliveryOption(
            context,
            'Standard Delivery',
            '5-7 business days',
            'Free',
            true,
          ),
          SizedBox(height: 12.h),
          _buildDeliveryOption(
            context,
            'Express Delivery',
            '2-3 business days',
            formatCurrency(context, 15),
            false,
          ),
          SizedBox(height: 12.h),
          _buildDeliveryOption(
            context,
            'Next Day Delivery',
            'Next business day',
            formatCurrency(context, 25),
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption(
    BuildContext context,
    String title,
    String subtitle,
    String price,
    bool isSelected,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (value) {

            },
            activeColor: AppColors.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
