import 'package:cozy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! SocialLoginButton
class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconAssetPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconAssetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton.icon(
        icon: Image.asset(iconAssetPath, height: 24.h, width: 24.w),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
              color: AppColors.textGrey.withOpacity(0.3), width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}
