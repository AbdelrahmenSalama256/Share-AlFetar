import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:cozy/features/profile/data/repo/orders_repo.dart';
import 'package:cozy/features/profile/view/order_details_screen.dart';
import 'package:cozy/features/profile/view/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_loading_indicator.dart';
import '../../../core/component/custom_toast.dart';
import '../data/models/order_status.dart';
import 'cubit/orders_cubit.dart';
import 'cubit/orders_state.dart';
import 'tracking_orders_screen.dart';

//! MyOrdersScreen
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

//! _MyOrdersScreenState
class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'my_orders'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'all'.tr(context)),
            Tab(text: 'pending'.tr(context)),
            Tab(text: 'processing'.tr(context)),
            Tab(text: 'shipped'.tr(context)),
            Tab(text: 'delivered'.tr(context)),
            Tab(text: 'cancelled'.tr(context)),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => OrdersCubit(sl<OrderRepo>())..getOrders(),
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrderError) {
              showToast(
                context,
                message: state.error,
                state: ToastStates.error,
                duration: const Duration(seconds: 3),
              );
            } else if (state is OrderSuccess) {
              showToast(
                context,
                message: state.message,
                state: ToastStates.success,
                duration: const Duration(seconds: 3),
              );
            }
          },
          builder: (context, state) {
            final ordersCubit = context.read<OrdersCubit>();
            if (state is OrderLoading) {
              return const Center(child: CustomLoadingIndicator());
            }

            if (state is OrderError) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80.sp,
                        color: AppColors.textGrey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.error,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      AppButton(
                        onPressed: () => ordersCubit.getOrders(),
                        text: 'retry'.tr(context),
                      ),
                    ],
                  ),
                ),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(ordersCubit.orders),
                _buildOrdersList(ordersCubit.filterOrders(OrderStatus.pending)),
                _buildOrdersList(ordersCubit.filterOrders(OrderStatus.orderd)),
                _buildOrdersList(ordersCubit.filterOrders(OrderStatus.shipped)),
                _buildOrdersList(
                    ordersCubit.filterOrders(OrderStatus.delivered)),
                _buildOrdersList(
                    ordersCubit.filterOrders(OrderStatus.cancelled)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80.sp,
              color: AppColors.textGrey,
            ),
            SizedBox(height: 16.h),
            Text(
              'no_orders_found'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () {
            final ordersCubit = context.read<OrdersCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return OrderDetailsScreen(orderId: order.id);
                },
              ),
            ).whenComplete(() {
              ordersCubit.getOrders();
            });
          },
          onTrackTap: order.shippingStatus != null
              ? () {
                  navigateTo(
                      context,
                      OrderTrackingDetailsScreen(
                        orderId: order.id,
                      ));
                }
              : null,
          onCancelTap: order.status == OrderStatus.pending ||
                  order.status == OrderStatus.orderd
              ? () {
                  context.read<OrdersCubit>().cancelOrder(order.id);
                }
              : null,
        );
      },
    );
  }
}
