import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/utils/currency_formatter.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/product_details_model.dart';

//! PriceDisplay
class PriceDisplay extends StatelessWidget {
  final ProductDetailsModel product;
  final bool hasVariations;

  const PriceDisplay({super.key, required this.product, required this.hasVariations});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final selectedVariation = hasVariations
        ? product.variations?.firstWhere(
            (v) => v.id?.toString() == selectedVariationId,
            orElse: () => product.variations!.first,
          )
        : null;

    final displayPrice = selectedVariation?.price ?? product.price ?? 0.0;

    return Row(
      children: [
        Text(
          formatCurrency(context, displayPrice),
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        if (product.oldPrice != null) ...[
          SizedBox(width: 12.w),
          Text(
            formatCurrency(context, product.oldPrice!),
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.textGrey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}

