import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/product_details_model.dart';

//! QuantitySelector
class QuantitySelector extends StatelessWidget {
  final bool hasVariations;
  final ProductDetailsModel product;

  const QuantitySelector({super.key, required this.hasVariations, required this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final selectedVariation = hasVariations
        ? product.variations?.firstWhere(
            (v) => v.id?.toString() == selectedVariationId,
            orElse: () => product.variations!.first,
          )
        : null;

    final availableQuantity = hasVariations
        ? (selectedVariation?.quantity ?? 0)
        : cubit.currentSelectedStock;
    final quantity = cubit.quantity;
    final isOutOfStock = availableQuantity <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('quantity'.tr(context),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: isOutOfStock || quantity <= 1
                      ? null
                      : () {
                          cubit.updateQuantity(quantity - 1);
                        },
                ),
                Text('$quantity', style: TextStyle(fontSize: 16.sp)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: isOutOfStock || quantity >= availableQuantity
                      ? null
                      : () {
                          cubit.updateQuantity(quantity + 1);
                        },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          isOutOfStock
              ? 'out_of_stock'.tr(context)
              : '${'available'.tr(context)}: $availableQuantity',
          style: TextStyle(
            fontSize: 14.sp,
            color: isOutOfStock ? AppColors.error : AppColors.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
