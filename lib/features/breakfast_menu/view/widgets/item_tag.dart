import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemTag extends StatelessWidget {
  const ItemTag({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.size = 'medium', // 'small', 'medium', 'large'
    this.withBorder = false,
    this.elevated = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String size;
  final bool withBorder;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding;
    final double verticalPadding;
    final double iconSize;
    final double fontSize;

    switch (size) {
      case 'small':
        horizontalPadding = 8.w;
        verticalPadding = 4.h;
        iconSize = 10.sp;
        fontSize = 10.sp;
        break;
      case 'large':
        horizontalPadding = 14.w;
        verticalPadding = 7.h;
        iconSize = 14.sp;
        fontSize = 13.sp;
        break;
      default: // medium
        horizontalPadding = 10.w;
        verticalPadding = 5.h;
        iconSize = 12.sp;
        fontSize = 11.sp;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size == 'small' ? 8.r : 12.r),
        border: withBorder
            ? Border.all(
                color: color.withOpacity(0.3),
                width: 0.8,
              )
            : null,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0.5,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: color,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: size == 'small' ? 0 : 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Gradient ItemTag
class GradientItemTag extends StatelessWidget {
  const GradientItemTag({
    super.key,
    required this.label,
    required this.icon,
    required this.gradient,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.size = 'medium',
  });

  final String label;
  final IconData icon;
  final Gradient gradient;
  final Color iconColor;
  final Color textColor;
  final String size;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding;
    final double verticalPadding;
    final double iconSize;
    final double fontSize;

    switch (size) {
      case 'small':
        horizontalPadding = 8.w;
        verticalPadding = 4.h;
        iconSize = 10.sp;
        fontSize = 10.sp;
        break;
      case 'large':
        horizontalPadding = 14.w;
        verticalPadding = 7.h;
        iconSize = 14.sp;
        fontSize = 13.sp;
        break;
      default: // medium
        horizontalPadding = 10.w;
        verticalPadding = 5.h;
        iconSize = 12.sp;
        fontSize = 11.sp;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(size == 'small' ? 8.r : 12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// Usage examples:
// Basic tag
// ItemTag(
//   label: 'Sandwich',
//   icon: Iconsax.bread,
//   color: AppColors.primary,
// )

// Small tag with border
// ItemTag(
//   label: 'Hot',
//   icon: Iconsax.flash,
//   color: AppColors.secondary,
//   size: 'small',
//   withBorder: true,
// )

// Large elevated tag
// ItemTag(
//   label: 'Drink',
//   icon: Iconsax.coffee,
//   color: AppColors.success,
//   size: 'large',
//   elevated: true,
// )

// Gradient tag
// GradientItemTag(
//   label: 'Special',
//   icon: Iconsax.star,
//   gradient: LinearGradient(
//     colors: [
//       AppColors.primary,
//       AppColors.secondary,
//     ],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   ),
// )
