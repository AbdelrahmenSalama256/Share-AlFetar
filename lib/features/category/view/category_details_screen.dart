import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/component/widgets/error_message_handler.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/cubit/home_state.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/navigation.dart';
import '../../../core/cubit/global_state.dart';
import '../../auth/view/login_screen.dart';
import '../../home/data/model/category_model.dart';

//! CategoryDetailsScreen
class CategoryDetailsScreen extends StatelessWidget {
  final int? categoryId;
  final String? categoryName;

  const CategoryDetailsScreen(
      {super.key, required this.categoryId, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => HomeCubit()..fetchProducts(isRefresh: true),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final cubit = context.read<HomeCubit>();
              final products = cubit.products;
              final filtered = cubit.searchQuery.trim().isEmpty
                  ? products
                  : cubit.filteredProducts;

              final category = cubit.categories.firstWhere(
                (c) => c.id == categoryId,
                orElse: () => CategoryModel(
                  id: categoryId,
                  name: categoryName,
                ),
              );

              if (state is HomeProductsLoading && products.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              return BlocConsumer<GlobalCubit, GlobalState>(
                listener: (context, globalState) {
                  if (globalState is WishlistItemRemovedError) {
                    ErrorMessageHandler.showErrorToast(
                        context, globalState.error);
                  }
                  if (globalState is WishlistItemRemovedSuccess) {
                    showToast(context,
                        message: globalState.message,
                        state: ToastStates.success);
                  }
                },
                builder: (context, globalState) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 200 &&
                          !cubit.isLoadingMore &&
                          cubit.hasMore &&
                          cubit.searchQuery.isEmpty) {
                        cubit.fetchProducts();
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<HomeCubit>()
                            .fetchProducts(isRefresh: true);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name?.tr(context) ?? '',
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
                                  '${filtered.length} ${'items'.tr(context)}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                          SizedBox(height: 12.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: filtered.isEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.h),
                                    child: Center(
                                      child: Text(
                                        'no_products'.tr(context),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.textGrey),
                                      ),
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width >=
                                                  700
                                              ? 3
                                              : 2,
                                      crossAxisSpacing: 15.w,
                                      mainAxisSpacing: 15.h,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: filtered.length +
                                        (cubit.isLoadingMore &&
                                                cubit.searchQuery.isEmpty
                                            ? 1
                                            : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= filtered.length &&
                                          cubit.searchQuery.isEmpty) {
                                        return const Center(
                                            child: CustomLoadingIndicator());
                                      }
                                      final product = filtered[index];
                                      return ProductCard(
                                        imageUrl: product.imagePath,
                                        name: product.nameKey,
                                        storeName: product.storeNameKey,
                                        rating: product.rating.isFinite
                                            ? product.rating
                                            : 0.0,
                                        reviewCount: product.reviewCount,
                                        price: product.price.isFinite
                                            ? product.price
                                            : 0.0,
                                        oldPrice: product.oldPrice?.isFinite ==
                                                    true &&
                                                product.oldPrice! > 0
                                            ? product.oldPrice
                                            : null,
                                        isFavorite: product.isFavourited,
                                        onTap: () {
                                          navigateTo(
                                            context,
                                            ProductDetailsScreen(
                                              productId: int.parse(product.id),
                                            ),
                                          );
                                        },
                                        removeFromWishlist: () {
                                          final global =
                                              context.read<GlobalCubit>();
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
                                          context
                                              .read<HomeCubit>()
                                              .setProductFavouriteById(
                                                  product.id, false);
                                        },
                                        onFavoriteTap: () {
                                          final global =
                                              context.read<GlobalCubit>();
                                          if (!global.isAuthenticated) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const LoginScreen()),
                                            );
                                            return;
                                          }
                                          context
                                              .read<GlobalCubit>()
                                              .addtowishlist(
                                                  productId:
                                                      product.id.toString());
                                          context
                                              .read<HomeCubit>()
                                              .setProductFavouriteById(
                                                  product.id, true);
                                        },
                                      );
                                    },
                                  ),
                          ),
                          if (cubit.isLoadingMore &&
                              cubit.hasMore &&
                              cubit.searchQuery.isEmpty)
                            SizedBox(
                              height: 50.h,
                              child:
                                  const Center(child: CustomLoadingIndicator()),
                            ),
                          SizedBox(height: 15.h),
                        ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
