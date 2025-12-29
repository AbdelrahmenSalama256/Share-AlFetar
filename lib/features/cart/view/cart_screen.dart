import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/error_message_handler.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/core/utils/currency_formatter.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/cart/data/repo/cart_repo.dart';
import 'package:cozy/features/cart/view/cubit/cart_cubit.dart';
import 'package:cozy/features/cart/view/widgets/cart_item_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../checkout/view/checkout_screen.dart';
import 'cubit/cart_state.dart';

//! CartScreen
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final global = context.read<GlobalCubit>();

    if (!global.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline,
                      size: 100.sp, color: AppColors.textGrey),
                  SizedBox(height: 24.h),
                  Text(
                    'login_required'.tr(context),
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'login_required_message'.tr(context),
                    style:
                        TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: 'login'.tr(context),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    type: AppButtonType.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => CartCubit(sl<CartRepo>())..fetchCart(),
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: SafeArea(
          child: BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartItemRemovedError) {
                ErrorMessageHandler.showErrorToast(
                    context, state.error.tr(context));
              }
              if (state is CartItemQuantityUpdateError) {
                ErrorMessageHandler.showErrorToast(context, state.error);
              }
              // 
              if (state is CartItemRemovedSuccess) {
                showToast(context,
                    message: state.message.tr(context),
                    state: ToastStates.success);
                context.read<CartCubit>().fetchCart();
              }
              if (state is ClearCartError) {
                ErrorMessageHandler.showErrorToast(
                    context, state.error.tr(context));
              }
              if (state is ClearCartSuccess) {
                showToast(context,
                    message: state.message.tr(context),
                    state: ToastStates.success);
                context.read<CartCubit>().fetchCart();
              }
            },
            child: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
              final cubit = context.read<CartCubit>();
              if (state is GetCartLoading || state is CartItemRemovedLoading) {
                return const Center(child: CustomLoadingIndicator());
              }
              return Stack(
                children: [
                  _buildCartContent(context, cubit),
                  _buildShippingSheet(context, cubit),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartCubit cubit) {
    if (cubit.cart == null) {
      // No cart loaded yet
      return const Center(child: CustomLoadingIndicator());
    }

    if (cubit.cart!.items.isEmpty) {
      return _buildEmptyCart(context);
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Text(
                'cart'.tr(context),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const Spacer(),
              cubit.cart!.items.length > 1
                  ? GestureDetector(
                      onTap: () {
                        cubit.clearCart();
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.red.withOpacity(
                            0.2,
                          ),
                        ),
                        child: cubit.state is ClearCartLoading
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  color: AppColors.red,
                                ),
                              )
                            : Icon(
                                CupertinoIcons.trash,
                                color: AppColors.red,
                                size: 25.sp,
                              ),
                      ),
                    )
                  : Text(
                      '${cubit.cart?.items.length} ${'items'.tr(context)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            itemCount: cubit.cart?.items.length,
            itemBuilder: (context, index) {
              final cartItem = cubit.cart?.items[index];
              return CartItemCard(
                key: ValueKey(cartItem?.id),
                cartItem: cartItem!,
                ontap: () {
                  navigateTo(
                      context,
                      ProductDetailsScreen(
                          productId: cartItem.product?.id ?? 9));
                },
                onQuantityChanged: (newQuantity) {
                  cubit.updateCartItemQuantity(cartItem.id!, newQuantity);
                },
                onRemove: () {
                  cubit.removeFromCart(cartItem.id!);
                },
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                  context, 'subtotal'.tr(context), cubit.cart?.cartTotal ?? 0),
              GestureDetector(
                onTap: () => _showShippingSheet(context, cubit),
                child: _buildSummaryRow(
                    context, 'shipping'.tr(context), cubit.cart?.shipping ?? 0,
                    isInteractive: true),
              ),
              _buildSummaryRow(
                  context, 'tax'.tr(context), cubit.cart?.tax ?? 0),
              Divider(height: 20.h),
              _buildSummaryRow(
                  context, 'total'.tr(context), cubit.cart?.finalTotal ?? 0,
                  isTotal: true),
              SizedBox(height: 20.h),
              AppButton(
                text: 'checkout'.tr(context),
                onPressed: () {
                  final global = context.read<GlobalCubit>();
                  if (!global.isAuthenticated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                    return;
                  }
                  navigateTo(context, CheckoutScreen(cart: cubit.cart!));
                },
                type: AppButtonType.primary,
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100.sp,
              color: AppColors.textGrey,
            ),
            SizedBox(height: 24.h),
            Text(
              'empty_cart'.tr(context),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'empty_cart_message'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            AppButton(
              text: 'start_shopping'.tr(context),
              onPressed: () {
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
              type: AppButtonType.primary,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double amount,
      {bool isTotal = false, bool isInteractive = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: GestureDetector(
        onTap: isInteractive
            ? () => _showShippingSheet(context, context.read<CartCubit>())
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 18.sp : 16.sp,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isInteractive ? AppColors.primary : AppColors.textBlack,
              ),
            ),
            Text(
              formatCurrency(context, amount),
              style: TextStyle(
                fontSize: isTotal ? 18.sp : 16.sp,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal
                    ? AppColors.primary
                    : (isInteractive ? AppColors.primary : AppColors.textBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShippingSheet(BuildContext context, CartCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'shipping_information'.tr(context),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Cost: ${formatCurrency(context, (cubit.cart?.shipping ?? 0))}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Estimated Delivery: 3-5 business days',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Shipping Method: Standard Shipping',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingSheet(BuildContext context, CartCubit cubit) {
    return DraggableScrollableSheet(
      initialChildSize: 0.0,
      minChildSize: 0.0,
      maxChildSize: 0.8,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.textGrey,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'shipping_information'.tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Cost: ${formatCurrency(context, (cubit.cart?.shipping ?? 0))}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Estimated Delivery: 3-5 business days',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Shipping Method: Standard Shipping',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
