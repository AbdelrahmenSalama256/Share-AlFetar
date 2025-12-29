import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class MenuEmptyState extends StatelessWidget {
  const MenuEmptyState({
    super.key,
    required this.onImport,
    required this.onManualAdd,
  });

  final Future<void> Function() onImport;
  final VoidCallback onManualAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Illustration
            Container(
              width: 160.w,
              height: 160.w,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer circle
                  Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.08),
                          AppColors.secondary.withOpacity(0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Middle circle
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  // Icon
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Iconsax.box,
                      size: 32.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Title
            Text(
              'empty_menu_title'.tr(context),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textBlack,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            // Subtitle
            Text(
              'empty_menu_subtitle'.tr(context),
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // Import Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await onImport();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    icon: Icon(
                      Iconsax.import,
                      size: 20.sp,
                    ),
                    label: Text(
                      'import_file'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // OR Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.border.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          'or'.tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.border.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Manual Add Button
                  OutlinedButton.icon(
                    onPressed: onManualAdd,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      minimumSize: Size(double.infinity, 52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      foregroundColor: AppColors.primary,
                    ),
                    icon: Icon(
                      Iconsax.add_circle,
                      size: 20.sp,
                    ),
                    label: Text(
                      'add_manual'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Help Text
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'import_tip'.tr(context),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative Minimal Design
class MinimalMenuEmptyState extends StatelessWidget {
  const MinimalMenuEmptyState({
    super.key,
    required this.onImport,
    required this.onManualAdd,
  });

  final Future<void> Function() onImport;
  final VoidCallback onManualAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.box,
                size: 48.sp,
                color: AppColors.primary,
              ),
            ),
            Text(
              'empty_menu_title'.tr(context),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'empty_menu_subtitle'.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Wrap(
              spacing: 16.w,
              runSpacing: 12.h,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await onImport();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  icon: Icon(Iconsax.import, size: 18.sp),
                  label: Text('import_file'.tr(context)),
                ),
                OutlinedButton.icon(
                  onPressed: onManualAdd,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    side: BorderSide(color: AppColors.primary),
                  ),
                  icon: Icon(Iconsax.add, size: 18.sp),
                  label: Text('add_manual'.tr(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
