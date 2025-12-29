import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/category/view/category_details_screen.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/category_card_widget.dart';

//! CategoriesScreen
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider(
        create: (context) => HomeCubit()..fetchCategories(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      children: [
                        Text(
                          'categories'.tr(context),
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  state is HomeLoading
                      ? const Expanded(child: CustomLoadingIndicator())
                      : state is HomeError
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  state.error.tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.58,
                                ),
                                itemCount: cubit.categories.length,
                                itemBuilder: (context, index) {
                                  final category = cubit.categories[index];
                                  return CategoryCard(
                                    imageUrl: category.imageUrl,
                                    name: category.name,
                                    productCount: cubit.categories.length,
                                    onTap: () async {
                                      cubit.selectCategory(index);

                                      navigateTo(
                                        context,
                                        CategoryDetailsScreen(
                                          categoryId: category.id ?? 0,
                                          categoryName: category.name,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                  SizedBox(height: 15.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
