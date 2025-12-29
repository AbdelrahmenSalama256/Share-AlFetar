
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cart/data/model/cart_model.dart';
import 'order_item.dart';
import 'section_container.dart';

//! OrderSummarySection
class OrderSummarySection extends StatelessWidget {
  final Cart cart;

  const OrderSummarySection({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'order_summary'.tr(context),
      actionText: '${cart.totalItems} ${'items'.tr(context)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          ...cart.items.take(2).map((item) => OrderItem(item: item)),

          if (cart.items.length > 2)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                '+${cart.items.length - 2} ${'more_items'.tr(context)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
