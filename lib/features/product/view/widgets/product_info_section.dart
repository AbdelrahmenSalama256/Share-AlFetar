import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/cubit/global_state.dart' as core_state;
import '../../data/model/product_details_model.dart';
import 'description_section.dart';
import 'price_display.dart';
import 'product_name_and_store.dart';
import 'quantity_selector.dart';
import 'specifications_section.dart';
import 'variations_section.dart';

//! ProductInfoSection
class ProductInfoSection extends StatelessWidget {
  final ProductDetailsModel product;
  final int productId;
  final bool hasVariations;
  final core_state.GlobalState globalState;

  const ProductInfoSection(
      {super.key,
      required this.product,
      required this.productId,
      required this.hasVariations,
      required this.globalState});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.watch<HomeCubit>();
    final isSelectionOutOfStock = homeCubit.isCurrentSelectionOutOfStock;
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductNameAndStore(product: product),
              SizedBox(height: 16.h),
              PriceDisplay(product: product, hasVariations: hasVariations),
              SizedBox(height: 24.h),
              if (isSelectionOutOfStock) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'out_of_stock'.tr(context),
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              if (hasVariations)
                VariationsSection(variations: product.variations!),
              QuantitySelector(hasVariations: hasVariations, product: product),
              SizedBox(height: 24.h),
              if (product.description?.isNotEmpty ?? false) ...[
                DescriptionSection(description: product.description!),
                SizedBox(height: 24.h),
              ],
              if (product.specifications?.isNotEmpty ?? false) ...[
                SpecificationsSection(specifications: product.specifications!),
                SizedBox(height: 24.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
