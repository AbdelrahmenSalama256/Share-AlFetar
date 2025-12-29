import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/widgets/category_chip.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/navigation.dart';
import '../../../core/cubit/global_cubit.dart';
import '../../../core/cubit/global_state.dart';
import '../../customer_services/view/customer_service_screen.dart';
import '../../notifications/view/notification_screen.dart';
import 'cubit/home_state.dart';
import 'offers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: AppColors.white,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          if ((state is HomeLoading || state is HomeProductsLoading) &&
              cubit.products.isEmpty) {
            return const Center(child: CustomLoadingIndicator());
          }

          final categories = cubit.categories;
          final products = cubit.filteredProducts;
          final offers = cubit.offers;

          final content = SafeArea(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 200 &&
                    !cubit.isLoadingMore &&
                    cubit.hasMore) {
                  cubit.fetchProducts();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    context.read<HomeCubit>().fetchCategories(),
                    context.read<HomeCubit>().fetchOffers(),
                    context.read<HomeCubit>().fetchProducts(isRefresh: true),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'welcome_message'.tr(context),
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBlack,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'quality_furniture'.tr(context),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textGrey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            _SquareIconButton(
                              icon: Icons.notifications_outlined,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const NotificationsScreen()));
                              },
                            ),
                            SizedBox(width: 8.w),
                            _SquareIconButton(
                              icon: Icons.support_agent_outlined,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const CustomerServiceScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: AppTextField(
                          controller: cubit.searchController,
                          onChanged: cubit.setSearchQuery,
                          hintText: 'search_hint_text'.tr(context),
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          'explore_categories'.tr(context),
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      categories.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: Text(
                                  'no_categories'.tr(context),
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.textGrey),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 40.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: CategoryChip(
                                      label: category.name ?? 'Unknown',
                                      isSelected:
                                          index == cubit.selectedCategoryIndex,
                                      onTap: () => cubit.selectCategory(index),
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: 24.h),
                      if (offers.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: GestureDetector(
                            onTap: () {
                              navigateTo(
                                context,
                                OffersScreen(
                                  offerId: offers.first.id,
                                  offer: offers.first,
                                ),
                              );
                            },
                            child: Container(
                              height: 150.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: AlignmentDirectional.topStart,
                                  end: AlignmentDirectional.bottomEnd,
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryLight
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Stack(
                                children: [
                                  PositionedDirectional(
                                    start: 20.w,
                                    top: 20.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context
                                                      .read<GlobalCubit>()
                                                      .language ==
                                                  "en"
                                              ? offers.first.name
                                              : offers.first.nameAr,
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          'Up to 50% Off',
                                          style: TextStyle(
                                              fontSize: 32.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 8.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20.r)),
                                          child: Text(
                                            'see_all'.tr(context),
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (offers.first.imageUrl.isNotEmpty)
                                    PositionedDirectional(
                                      end: 20.w,
                                      bottom: 20.h,
                                      child: Container(
                                        width: 80.w,
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                offers.first.imageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    right: -20.w,
                                    bottom: -20.h,
                                    child: Container(
                                      width: 120.w,
                                      height: 120.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(60.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 24.h),
                      state is HomeProductsLoading
                          ? SizedBox(
                              height: 50.h,
                              child:
                                  const Center(child: CustomLoadingIndicator()))
                          : products.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Center(
                                    child: Text('no_products'.tr(context),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.textGrey)),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'popular_products'.tr(context),
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textBlack),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: MediaQuery.of(context)
                                                      .size
                                                      .width >=
                                                  700
                                              ? 3
                                              : 2,
                                          crossAxisSpacing: 15.w,
                                          mainAxisSpacing: 15.h,
                                          childAspectRatio: 0.75,
                                        ),
                                        itemCount: products.length +
                                            (cubit.hasMore &&
                                                    cubit.searchQuery.isEmpty
                                                ? 1
                                                : 0),
                                        itemBuilder: (context, index) {
                                          if (index >= products.length &&
                                              cubit.searchQuery.isEmpty) {
                                            return const Center(
                                                child:
                                                    CustomLoadingIndicator());
                                          }
                                          final product = products[index];
                                          return ProductCard(
                                            imageUrl: product.imagePath,
                                            name: product.nameKey,
                                            storeName: product.storeNameKey,
                                            rating: product.rating,
                                            reviewCount: product.reviewCount,
                                            price: product.price,
                                            oldPrice: product.oldPrice,
                                            isFavorite: product.isFavourited,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ProductDetailsScreen(
                                                          productId: int.parse(
                                                              product.id)),
                                                ),
                                              );
                                            },
                                            onFavoriteTap: () {
                                              final global =
                                                  context.read<GlobalCubit>();
                                              final home =
                                                  context.read<HomeCubit>();
                                              if (!global.isAuthenticated) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const LoginScreen()),
                                                );
                                                return;
                                              }
                                              if (product.isFavourited) {
                                                global
                                                    .removeProductFromWishlistByProductId(
                                                        product.id);
                                                home.setProductFavouriteById(
                                                    product.id, false);
                                              } else {
                                                global.addtowishlist(
                                                    productId: product.id);
                                                home.setProductFavouriteById(
                                                    product.id, true);
                                              }
                                            },
                                            removeFromWishlist: () {
                                              final global =
                                                  context.read<GlobalCubit>();
                                              final home =
                                                  context.read<HomeCubit>();
                                              if (!global.isAuthenticated) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const LoginScreen()),
                                                );
                                                return;
                                              }
                                              global
                                                  .removeProductFromWishlistByProductId(
                                                      product.id);
                                              home.setProductFavouriteById(
                                                  product.id, false);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                      if (cubit.isLoadingMore && cubit.hasMore)
                        const Center(child: CustomLoadingIndicator()),
                    ],
                  ),
                ),
              ),
            ),
          );

          return BlocListener<GlobalCubit, GlobalState>(
            listener: (context, gState) {
              final home = context.read<HomeCubit>();
              if (gState is WishlistStatusChanged) {
                home.setProductFavouriteById(
                    gState.productId, gState.isFavourite);
              }
            },
            child: content,
          );
        },
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}
