import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/currency_formatter.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/product_details_model.dart';

//! VariationsSection
class VariationsSection extends StatelessWidget {
  final List<ProductVariation> variations;

  const VariationsSection({super.key, required this.variations});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final selectedVariation = variations.firstWhere(
      (v) => v.id?.toString() == selectedVariationId,
      orElse: () => variations.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('variations'.tr(context),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: variations.map((variation) {
            final isSelected = variation.id?.toString() == selectedVariationId;
            return GestureDetector(
              onTap: () => cubit.selectVariation(variation.id?.toString() ?? ''),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textGrey,
                  ),
                ),
                child: Text(
                  '${variation.name ?? 'Variation'} (${formatCurrency(context, variation.price ?? 0)})',
                  style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textBlack),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),
        Text(
          '${'available'.tr(context)}: ${selectedVariation.quantity ?? 0}',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

