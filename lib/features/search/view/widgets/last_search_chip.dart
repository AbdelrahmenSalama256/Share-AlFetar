import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! LastSearchChip
class LastSearchChip extends StatelessWidget {
  final String
      queryKey; // This can be the direct string or a key for localization
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const LastSearchChip({
    super.key,
    required this.queryKey,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {


    bool isLocalizationKey =
        queryKey.contains('_key') || queryKey.startsWith('search_recent_');
    String displayText = isLocalizationKey ? queryKey.tr(context) : queryKey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.inputFieldBackground,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayText,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Icon(
                Icons.close,
                size: 16.sp,
                color: AppColors.textGrey.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
