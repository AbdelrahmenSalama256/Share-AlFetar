import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! StoreInfoCard
class StoreInfoCard extends StatelessWidget {
  const StoreInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(8.r),

              image: const DecorationImage(
                image: NetworkImage(
                    "https://via.placeholder.com/150/771796/FFFFFF?Text=Logo"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Upbox Bag", // This would be dynamic
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.check_circle, color: Colors.blue, size: 16.sp),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      "104 ${"search_products_count_suffix".tr(context)}",
                      style:
                          TextStyle(fontSize: 12.sp, color: AppColors.textGrey),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: CircleAvatar(
                          radius: 2.r, backgroundColor: AppColors.textGrey),
                    ),
                    Text(
                      "1.3k ${"search_followers_count_suffix".tr(context)}",
                      style:
                          TextStyle(fontSize: 12.sp, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16.sp, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
