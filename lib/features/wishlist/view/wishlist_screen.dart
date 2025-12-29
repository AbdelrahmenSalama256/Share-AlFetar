import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:cozy/features/wishlist/view/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_loading_indicator.dart';
import '../../../core/component/custom_toast.dart';
import '../../../core/constants/navigation.dart';
import '../../../core/services/service_locator.dart';
import '../data/repo/wishlist_repo.dart';
import 'cubit/wishlist_state.dart';

//! WishlistScreen
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

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
      create: (context) => WishlistCubit(sl<WishlistRepo>()),
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: SafeArea(
          child: BlocListener<WishlistCubit, WishlistState>(
            listener: (context, state) {
              if (state is WishlistError) {
                showToast(context,
                    message: state.error.tr(context), state: ToastStates.error);
              }
              if (state is WishlistItemRemovedSuccess) {
                showToast(context,
                    message: state.message.tr(context),
                    state: ToastStates.success);
              }
              if (state is WishlistItemRemovedError) {
                showToast(context,
                    message: state.error.tr(context), state: ToastStates.error);
              }
            },
            child: BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, state) {
                final cubit = context.read<WishlistCubit>();
                if (state is WishlistLoading) {
                  return const Center(child: CustomLoadingIndicator());
                }

                return _buildFavoritesContent(context, cubit);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesContent(BuildContext context, WishlistCubit cubit) {
    if (cubit.wishlist?.items.isEmpty ?? true) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: _buildEmptyFavorites(context),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Text(
                'favorites'.tr(context),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const Spacer(),
              Text(
                '${cubit.wishlist?.wishlistCount ?? 0} ${'items'.tr(context)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<WishlistCubit>().fetchWishlist();
            },
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.w,
                mainAxisSpacing: 15.h,
                childAspectRatio: 0.70,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: cubit.wishlist?.items.length ?? 0,
              itemBuilder: (context, index) {
              final item = cubit.wishlist!.items[index];
              final product = item.product;
              return ProductCard(
                imageUrl: product.imageUrl,
                name: product.name,
                storeName: product.storeName,
                rating: product.rating,
                reviewCount: product.reviewCount,
                price: product.price,
                oldPrice: product.oldPrice,
                isFavorite: true,
                onTap: () {
                  navigateTo(
                    context,
                    ProductDetailsScreen(productId: product.id),
                  );
                },
                removeFromWishlist: () {
                  cubit.removeFromWishlist(item.id);
                },
              );
            },
          ),
        ),
        ),
      ],
    );
  }

  Widget _buildEmptyFavorites(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 100.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 24.h),
          Text(
            'empty_favorites'.tr(context),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'empty_favorites_message'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          AppButton(
            onPressed: () {
              context.read<GlobalCubit>().changeBottomNavIndex(0);
            },
            text: 'explore_products'.tr(context),
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }
}
