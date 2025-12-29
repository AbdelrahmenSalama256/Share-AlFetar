import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/search/data/model/popular_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! PopularSearchItemCard
class PopularSearchItemCard extends StatelessWidget {
  final PopularSearchModel popularSearch;
  final VoidCallback onTap;

  const PopularSearchItemCard({
    super.key,
    required this.popularSearch,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Icon(Icons.trending_up, color: AppColors.primaryLight, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    popularSearch.queryKey.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        'search_results_count'.tr(context),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        popularSearch.resultCount.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16.sp, color: AppColors.textGrey.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}
