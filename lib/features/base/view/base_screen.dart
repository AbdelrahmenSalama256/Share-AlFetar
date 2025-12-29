import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/cubit/global_state.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/cart/view/cart_screen.dart';
import 'package:cozy/features/category/view/categories_screen.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/home_screen.dart';
import 'package:cozy/features/profile/view/profile_screen.dart';
import 'package:cozy/features/wishlist/view/wishlist_screen.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! BaseScreen
class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

//! _BaseScreenState
class _BaseScreenState extends State<BaseScreen> {
  final List<Widget> _screens = [
    BlocProvider(
      create: (context) => HomeCubit()..initialize(),
      child: const HomeScreen(),
    ),
    const CategoriesScreen(),
    const CartScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = context.read<GlobalCubit>();
        return BlocListener<GlobalCubit, GlobalState>(
          listener: (context, state) {
            if (state is LanguageChangedState) {
              setState(() {});
            }
          },
          child: WillPopScope(
            onWillPop: () {
              if (cubit.currentNavIndex == 0) {
                return Future.value(false);
              } else {
                cubit.changeBottomNavIndex(0);
                return Future.value(false);
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              extendBody: true,
              extendBodyBehindAppBar: true,
              body: SafeArea(
                  bottom: true, child: _screens[cubit.currentNavIndex]),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(15, 0, 0, 0),
                      blurRadius: 10.r,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: CurvedNavigationBar(
                  index: cubit.currentNavIndex,
                  items: [
                    CurvedNavigationBarItem(
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: cubit.currentNavIndex == 0
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      child: Icon(
                        cubit.currentNavIndex == 0
                            ? Icons.home
                            : Icons.home_outlined,
                        size: 24.sp,
                        color: cubit.currentNavIndex == 0
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      label: 'home'.tr(context),
                    ),
                    CurvedNavigationBarItem(
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: cubit.currentNavIndex == 1
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      child: Icon(
                        cubit.currentNavIndex == 1
                            ? Icons.grid_view
                            : Icons.grid_view_outlined,
                        size: 24.sp,
                        color: cubit.currentNavIndex == 1
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      label: 'categories'.tr(context),
                    ),
                    CurvedNavigationBarItem(
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: cubit.currentNavIndex == 2
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: cubit.currentNavIndex == 2
                              ? AppColors.primary.withOpacity(0.2)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cubit.currentNavIndex == 2
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                          size: 24.sp,
                          color: cubit.currentNavIndex == 2
                              ? AppColors.primary
                              : const Color(0xff9DB2CE),
                        ),
                      ),
                      label: 'cart'.tr(context),
                    ),
                    CurvedNavigationBarItem(
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: cubit.currentNavIndex == 3
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      child: Icon(
                        cubit.currentNavIndex == 3
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        size: 24.sp,
                        color: cubit.currentNavIndex == 3
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      label: 'favorites'.tr(context),
                    ),
                    CurvedNavigationBarItem(
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        color: cubit.currentNavIndex == 4
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      child: Icon(
                        cubit.currentNavIndex == 4
                            ? Icons.person
                            : Icons.person_outline,
                        size: 24.sp,
                        color: cubit.currentNavIndex == 4
                            ? AppColors.primary
                            : const Color(0xff9DB2CE),
                      ),
                      label: 'profile'.tr(context),
                    ),
                  ],
                  color: Colors.white,
                  buttonBackgroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 500),
                  height: 90.h,
                  onTap: (index) {
                    cubit.changeBottomNavIndex(index);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
