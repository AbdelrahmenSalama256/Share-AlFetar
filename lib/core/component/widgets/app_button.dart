import 'package:cozy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppButtonType { primary, secondary, text }

//! AppButton
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final Color? backgroundColor; // New parameter for background color
  final Color? borderColor; // New parameter for border color

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 60,
    this.width,
    this.padding,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.backgroundColor, // Add to constructor
    this.borderColor, // Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    switch (type) {
      case AppButtonType.primary:
        return _buildPrimaryButton(context, isDisabled);
      case AppButtonType.secondary:
        return _buildSecondaryButton(context, isDisabled);
      case AppButtonType.text:
        return _buildTextButton(context, isDisabled);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDisabled) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width?.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ??
              AppColors.primary, // Use provided color or default
          disabledBackgroundColor: (backgroundColor ?? AppColors.primary)

              .withOpacity(0.5),
          foregroundColor: Colors.white,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(4.r),
          ),
          elevation: 0, // Remove shadow
        ),
        child: _buildButtonContent(context, Colors.white),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isDisabled) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width?.w,
      height: height.h,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: isDisabled
                ? Colors.grey
                : borderColor ??
                    const Color(
                      0xFF1565C0,
                    ), // Use provided border color or default
            width: 1.0,
          ),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(4.r),
          ),
          backgroundColor:
              backgroundColor ?? Colors.white, // Use provided color or default
        ),
        child: _buildButtonContent(context, AppColors.primary),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDisabled) {
    return SizedBox(
      width: isFullWidth ? double.infinity : width?.w,
      height: height.h,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(20.r),
          ),
          backgroundColor:
              backgroundColor, // Use provided color or none (TextButton default)
        ),
        child: _buildButtonContent(context, AppColors.primary),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8.w)],
        Text(
          text,
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
        ),
        if (suffixIcon != null) ...[SizedBox(width: 8.w), suffixIcon!],
      ],
    );
  }
}
