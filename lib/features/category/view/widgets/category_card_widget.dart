import 'package:cozy/core/constants/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

//! CategoryCard
class CategoryCard extends StatelessWidget {
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final double? iconSize;
  final String? imageUrl;
  final String? name;
  final int? productCount;
  final String? description;

  const CategoryCard({
    super.key,
    required this.onTap,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.primary,
    this.iconBackgroundColor,
    this.iconSize = 16,
    this.imageUrl,
    this.name,
    this.productCount,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius!.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(borderRadius!.r)),
                child: CustomCachedImage(
                  imageUrl: imageUrl,
                  w: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: borderRadius!.r,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? '',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlack,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${productCount ?? 0} items',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: iconBackgroundColor ??
                                iconColor!.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: iconColor,
                            size: iconSize!.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
