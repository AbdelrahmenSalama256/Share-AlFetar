import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/search/view/cubit/search_cubit.dart';
import 'package:cozy/features/search/view/cubit/search_state.dart';
import 'package:cozy/features/search/view/widgets/filter_chip_widget.dart';
import 'package:cozy/features/search/view/widgets/last_search_chip.dart';
import 'package:cozy/features/search/view/widgets/popular_search_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_loading_indicator.dart';

//! SearchScreen
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

//! _SearchScreenState
class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().loadInitialData();
    _searchController.addListener(() {
      context.read<SearchCubit>().onSearchQueryChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildInitialSearchView(BuildContext context, SearchState state) {
    final cubit = context.read<SearchCubit>();
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("search_last_search".tr(context),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack)),
                if (state.recentSearches.isNotEmpty)
                  GestureDetector(
                    onTap: () => cubit.clearRecentSearches(),
                    child: Text("search_clear_all".tr(context),
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w500)),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          if (state.recentSearches.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Text("search_no_recent_searches".tr(context),
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14.sp)),
            )
          else
            SizedBox(
              height: 35.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: state.recentSearches.length,
                itemBuilder: (context, index) {
                  final query = state.recentSearches[index];
                  return LastSearchChip(
                    queryKey: query,
                    onTap: () {
                      _searchController.text = query;
                      cubit.performSearch(query);
                    },
                    onRemove: () => cubit.removeRecentSearch(query),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
              ),
            ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text("search_popular_search".tr(context),
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack)),
          ),
          SizedBox(height: 12.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.popularSearches.length,
            itemBuilder: (context, index) {
              final popularSearch = state.popularSearches[index];
              return PopularSearchItemCard(
                popularSearch: popularSearch,
                onTap: () {
                  _searchController.text = popularSearch.queryKey.tr(context);
                  cubit.performSearch(popularSearch.queryKey.tr(context));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsView(BuildContext context, SearchState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: state.isLoading
              ? const Center(child: CustomLoadingIndicator())
              : state.searchResults.isEmpty
                  ? Center(
                      child: Text(
                        "search_no_results".tr(context),
                        style: TextStyle(
                            fontSize: 16.sp, color: AppColors.textGrey),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(24.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        final product = state.searchResults[index];
                        return ProductCard(
                          imageUrl: product.imagePath,
                          name: product.nameKey,
                          storeName: product.storeNameKey,
                          rating: product.rating,
                          reviewCount: product.reviewCount,
                          price: product.price,
                          oldPrice: product.oldPrice,
                          isFavorite: product.isFavourited,
                          onTap: () {},
                          onFavoriteTap: () {
                            final global = context.read<GlobalCubit>();
                            if (!global.isAuthenticated) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                              return;
                            }
                            context
                                .read<GlobalCubit>()
                                .addtowishlist(productId: product.id);
                          },
                          removeFromWishlist: () {
                            final global = context.read<GlobalCubit>();
                            if (!global.isAuthenticated) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                              return;
                            }
                            context
                                .read<GlobalCubit>()
                                .removeProductFromWishlistByProductId(
                                    product.id);
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("search_filter_options".tr(context),
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack)),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: context
                    .read<SearchCubit>()
                    .state
                    .filterOptions
                    .map((filter) {
                  return FilterChipWidget(
                    labelKey: filter,
                    onTap: () =>
                        context.read<SearchCubit>().selectFilter(filter),
                    isSelected:
                        context.read<SearchCubit>().state.selectedFilter ==
                            filter,
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),
              AppButton(
                onPressed: () => Navigator.pop(context),
                text: "search_apply_filters".tr(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: AppColors.textBlack, size: 20.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(fontSize: 16.sp, color: AppColors.textBlack),
          decoration: InputDecoration(
            hintText: "search_hint_text".tr(context),
            hintStyle: TextStyle(
                fontSize: 16.sp, color: AppColors.textGrey.withOpacity(0.7)),
            border: InputBorder.none,
            prefixIcon:
                Icon(Icons.search, color: AppColors.textGrey, size: 22.sp),
          ),
          onSubmitted: (query) {
            context.read<SearchCubit>().performSearch(query);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_outlined,
                color: AppColors.textBlack, size: 24.sp),
            onPressed: _showFilterOptions,
          ),
          SizedBox(width: 8.w),
        ],
        elevation: 1,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final content = state.searchQuery.isEmpty && !state.hasSearched
              ? _buildInitialSearchView(context, state)
              : _buildSearchResultsView(context, state);
          return RefreshIndicator(
            onRefresh: () async {
              final cubit = context.read<SearchCubit>();
              if (state.hasSearched && state.searchQuery.isNotEmpty) {
                cubit.performSearch(state.searchQuery);
              } else {
                cubit.loadInitialData();
              }
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: content,
          );
        },
      ),
    );
  }
}
