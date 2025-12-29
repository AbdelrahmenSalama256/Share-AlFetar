import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/cubit/global_state.dart' as core_state;
import '../../../auth/view/login_screen.dart';
import '../../data/model/product_details_model.dart';
import 'checkout_launcher.dart';

//! ActionButtons
class ActionButtons extends StatelessWidget {
  final int productId;
  final bool hasVariations;
  final core_state.GlobalState globalState;
  final ProductDetailsModel product;

  const ActionButtons({super.key, required this.productId, required this.hasVariations, required this.globalState, required this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final quantity = cubit.quantity;
    final isOutOfStock = cubit.isCurrentSelectionOutOfStock;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(top: BorderSide(color: AppColors.lightGrey, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'add_to_cart'.tr(context),
                    isLoading: globalState is core_state.CartLoading,
                    onPressed: isOutOfStock
                        ? null
                        : () {
                            if (selectedVariationId.isEmpty && hasVariations) {
                              showToast(
                                context,
                                message: "please_select_a_variations".tr(context),
                                state: ToastStates.warning,
                              );
                              return;
                            }
                            final variationId = selectedVariationId.isEmpty
                                ? productId.toString()
                                : selectedVariationId;
                            context.read<GlobalCubit>().addToCart(
                                  productId: productId.toString(),
                                  quantity: quantity,
                                  variation: int.tryParse(variationId) ?? productId,
                                );
                          },
                    type: AppButtonType.secondary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButton(
                    text: 'buy_now'.tr(context),
                    onPressed: isOutOfStock
                        ? null
                        : () {
                            if (selectedVariationId.isEmpty && hasVariations) {
                              showToast(
                                context,
                                message: "please_select_a_variations".tr(context),
                                state: ToastStates.warning,
                              );
                              return;
                            }
                            final global = context.read<GlobalCubit>();
                            if (!global.isAuthenticated) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                              return;
                            }
                            final variationId = selectedVariationId.isEmpty
                                ? productId.toString()
                                : selectedVariationId;
                            context.read<GlobalCubit>().addToCart(
                                  productId: productId.toString(),
                                  quantity: quantity,
                                  variation: int.tryParse(variationId) ?? productId,
                                );
                            navigateTo(context, const CheckoutLauncher());
                          },
                    type: AppButtonType.primary,
                  ),
                ),
              ],
            ),
            if (isOutOfStock) ...[
              SizedBox(height: 8.h),
              Text(
                'out_of_stock'.tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
