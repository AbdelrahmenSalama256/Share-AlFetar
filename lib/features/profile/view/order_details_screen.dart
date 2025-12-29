import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:cozy/features/profile/view/cubit/orders_cubit.dart';
import 'package:cozy/features/profile/view/cubit/orders_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_loading_indicator.dart';
import '../data/repo/orders_repo.dart';
import 'widgets/order_details_widgets.dart';

//! OrderDetailsScreen
class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: BlocProvider(
        create: (context) =>
            OrdersCubit(sl<OrderRepo>())..getOrderDetails(orderId),
        child: BlocConsumer<OrdersCubit, OrdersState>(
          listener: _orderDetailsListener,
          builder: (context, state) => _buildBodyContent(context, state),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,
            color: AppColors.textBlack, size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '${'order_details'.tr(context)} #$orderId',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  void _orderDetailsListener(BuildContext context, OrdersState state) {
    if (state is OrderDetailsError) {
      _showErrorToast(context, state.error);
    } else if (state is OrderSuccess) {
      _showSuccessToast(context, state.message);
      Navigator.of(context)
        ..pop()
        ..pop();
    } else if (state is OrderError) {
      _showErrorToast(context, state.error);
      Navigator.pop(context);
    }
  }

  void _showErrorToast(BuildContext context, String message) {
    showToast(
      context,
      message: message,
      state: ToastStates.error,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessToast(BuildContext context, String message) {
    showToast(
      context,
      message: message,
      state: ToastStates.success,
      duration: const Duration(seconds: 3),
    );
  }

  Widget _buildBodyContent(BuildContext context, OrdersState state) {
    if (state is OrderDetailsLoading) {
      return const Center(child: CustomLoadingIndicator());
    }

    if (state is OrderDetailsError) {
      return _buildErrorState(context, state);
    }

    if (state is OrderDetailsLoaded) {
      return _buildOrderDetailsContent(context, state.order);
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState(BuildContext context, OrderDetailsError state) {
    return Center(
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
            onPressed: () =>
                context.read<OrdersCubit>().getOrderDetails(orderId),
            text: 'retry'.tr(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsContent(BuildContext context, OrderModel order) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildOrderStatusCard(context, order),
          SizedBox(height: 16.h),
          buildOrderItemsList(context, order.items),
          SizedBox(height: 16.h),
          if (order.shippingAddress != null &&
              order.shippingAddress!.isNotEmpty)
            buildShippingAddressCard(context, order),
          SizedBox(height: 16.h),
          buildOrderSummaryCard(context, order),
          SizedBox(height: 16.h),
          buildActionButtons(order, context),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
