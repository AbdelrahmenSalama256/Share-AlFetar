import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cozy/core/constants/app_colors.dart';

import 'package:shimmer/shimmer.dart';

//! CustomShimmer
class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
    this.w,
    this.h,
    this.borderRadius,
    this.bottomPadding,
    this.endPadding,
  });

  final double? w, h, borderRadius, bottomPadding, endPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: endPadding ?? 0,
        bottom: bottomPadding ?? 0,
      ),
      child: Shimmer.fromColors(

        baseColor: AppColors.lightGrey.withOpacity(0.4),
        highlightColor: AppColors.white,
        child: Container(
          width: w ?? 100.w,
          height: h ?? 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
            color: AppColors.lightGrey,
          ),
        ),
      ),
    );
  }
}
