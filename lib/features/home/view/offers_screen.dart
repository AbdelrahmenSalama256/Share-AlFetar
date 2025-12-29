import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/home/data/model/offer_product_model.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cozy/core/component/widgets/unified_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/cubit/global_cubit.dart';
import '../data/model/offers_model.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

//! OffersScreen
class OffersScreen extends StatelessWidget {
  final int offerId;
  final OfferModel? offer;

  const OffersScreen({super.key, required this.offerId, this.offer});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchOfferProducts(offerId),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: UnifiedAppBar.inner(
          title: offer?.getName(context) ?? 'special_offers'.tr(context),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeOfferProductsLoading) {
              return Center(child: CustomLoadingIndicator());
            }

            if (state is HomeOfferProductsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              );
            }

            final cubit = context.read<HomeCubit>();
            final products = cubit.offerProducts;

            if (products.isEmpty) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeCubit>().fetchOfferProducts(offerId);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOfferHeader(context, products.length),
                    SizedBox(height: 24.h),
                    _buildProductsGrid(context, products),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOfferHeader(BuildContext context, int productCount) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer?.getName(context) ?? 'special_offers'.tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '$productCount ${'products_available'.tr(context)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          if (offer?.imageUrl.isNotEmpty ?? false)
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white.withOpacity(0.2),
                image: offer?.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(offer!.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(
      BuildContext context, List<OfferProductModel> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          imageUrl: product.imageUrl,
          name: product.getDisplayName(context),
          storeName: product.brand?.getDisplayName(context) ??
              product.category?.getDisplayName(context) ??
              '',
          rating: 4.5, // You might want to add rating to your model
          reviewCount: 120, // You might want to add review count to your model
          price: product.price,
          oldPrice: product.oldPrice,
          isFavorite: product.isFavourited,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  productId: product.id,
                ),
              ),
            );
          },
          onFavoriteTap: () {
            final global = context.read<GlobalCubit>();
            if (!global.isAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              return;
            }
            context
                .read<GlobalCubit>()
                .addtowishlist(productId: product.id.toString());
          },
          removeFromWishlist: () {
            final global = context.read<GlobalCubit>();
            if (!global.isAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              return;
            }
            context
                .read<GlobalCubit>()
                .removeProductFromWishlistByProductId(product.id.toString());
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 60.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_offer_products'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'check_back_products'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

