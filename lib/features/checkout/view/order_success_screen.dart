import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/repo/orders_repo.dart';
import 'package:cozy/features/profile/view/cubit/orders_cubit.dart';
import 'package:cozy/features/profile/view/tracking_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/cubit/global_state.dart';

//! OrderSuccessScreen
class OrderSuccessScreen extends StatelessWidget {
  final String orderNumber;
  final double total;
  final String orderId;

  const OrderSuccessScreen({
    super.key,
    required this.orderNumber,
    required this.total,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<GlobalCubit, GlobalState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h), // Added top padding
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 60.sp,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'order_placed_successfully'.tr(context),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'order_confirmation_message'.tr(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'order_number'.tr(context),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Text(
                              orderNumber,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'total_amount'.tr(context),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  AppButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<GlobalCubit>().changeBottomNavIndex(0);
                    },
                    text: 'continue_shopping'.tr(context),
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    onPressed: () {
                      navigateTo(
                        context,
                        BlocProvider(
                          create: (context) => OrdersCubit(sl<OrderRepo>())
                            ..getOrders()
                            ..trackOrder(orderId),
                          child: OrderTrackingDetailsScreen(
                            orderId: orderId,
                          ),
                        ),
                      );
                    },
                    type: AppButtonType.secondary,
                    text: 'track_order'.tr(context),
                  ),
                  SizedBox(height: 20.h), // Added bottom padding for safety
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
