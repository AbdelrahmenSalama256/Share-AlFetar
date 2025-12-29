import 'package:cached_network_image/cached_network_image.dart';
import 'package:cozy/core/constants/widgets/custom_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! CustomCachedImage
class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.h,
    this.w,
    this.borderRadius,
    this.fit,
  });

  final String? imageUrl;
  final double? h, w, borderRadius;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h ?? 100.h,
      width: w ?? 100.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 15),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? "",
          placeholder: (context, url) => CustomShimmer(
            h: h,
            w: w,
          ),
          errorWidget: (context, url, error) => Container(
              height: h ?? 100.h,
              width: w ?? 100.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
              ),
              child:
                  Icon(CupertinoIcons.person, size: 40.r, color: Colors.grey)),
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }
}
