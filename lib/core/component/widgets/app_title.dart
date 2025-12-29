import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! SectionHeader
class SectionHeader extends StatelessWidget {
  final String titleKey;
  final String? subtitleKey;
  final bool showSeeAll;
  final String? seeAllTextKey;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.titleKey,
    this.subtitleKey,
    this.showSeeAll = true, // Default to true if onSeeAllTap is provided
    this.seeAllTextKey, // Defaults to 'see_all_button' if null and showSeeAll is true
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleKey,
                style: TextStyle(
                  fontSize: 18.sp, // Slightly larger for section titles
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              if (subtitleKey != null && subtitleKey!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  subtitleKey!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showSeeAll && onSeeAllTap != null)
          TextButton(
            onPressed: onSeeAllTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(50.w, 30.h), // Ensure tap target is reasonable
              alignment: Alignment.centerRight,
            ),
            child: Text(
              seeAllTextKey ?? 'see_all_button'.tr(context),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryLight,
              ),
            ),
          ),
      ],
    );
  }
}
