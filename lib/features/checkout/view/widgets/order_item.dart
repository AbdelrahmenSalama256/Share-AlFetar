import 'package:flutter/material.dart';
import 'package:cozy/core/constants/widgets/custom_cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cozy/core/utils/currency_formatter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../cart/data/model/cart_model.dart';

//! OrderItem
class OrderItem extends StatelessWidget {
  final CartItem item;

  const OrderItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CustomCachedImage(
              imageUrl: item.product?.imagePath,
              w: 50.w,
              h: 50.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.product?.imagePath}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatCurrency(context, (item.product!.price! * item.quantity!)),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }
}
