
import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:cozy/features/profile/data/models/order_tracking_response.dart';
import 'package:cozy/features/profile/view/cubit/orders_cubit.dart';
import 'package:cozy/features/profile/view/cubit/orders_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cozy/core/utils/currency_formatter.dart';

import '../data/models/tracking_event_model.dart';
import '../data/repo/orders_repo.dart';

//! OrderTrackingDetailsScreen
class OrderTrackingDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingDetailsScreen> createState() =>
      _OrderTrackingDetailsScreenState();
}

//! _OrderTrackingDetailsScreenState
class _OrderTrackingDetailsScreenState
    extends State<OrderTrackingDetailsScreen> {


  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(sl<OrderRepo>())..getOrders(),
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrderTrackingError) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
              duration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.watch<OrdersCubit>();
          final order = cubit.getOrderById(widget.orderId);

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: AppColors.textBlack, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '${'order'.tr(context)} #${cubit.currentTrackResponse?.invoiceNo ?? order?.invoiceNo ?? widget.orderId}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              actions: [






              ],
            ),
            body: _buildBody(context, cubit, state, order),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, OrdersCubit cubit, OrdersState state,
      OrderModel? order) {
    if (state is OrderLoading || state is OrderTrackingLoading) {
      return const Center(child: CustomLoadingIndicator());
    }

    if (state is OrderError || state is OrderTrackingError) {
      return _buildError(context, cubit, state);
    }

    if (order == null) {
      return _buildError(context, cubit, OrderError('Order not found'));
    }

    if (cubit.currentTrackResponse == null) {
      return _buildNoTrackingData(context, cubit);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTrackingNumberCard(context, cubit.currentTrackResponse!),
            SizedBox(height: 16.h),
            _buildTrackingProgress(
                context, cubit.currentTrackResponse!.trackingEvents),
            SizedBox(height: 16.h),
            _buildOrderSummary(context, cubit.currentTrackResponse!, order),
            SizedBox(height: 16.h),

          ],
        ),
      ),
    );
  }

  Widget _buildNoTrackingData(BuildContext context, OrdersCubit cubit) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 60.sp, color: AppColors.textGrey),
            SizedBox(height: 16.h),
            Text(
              'no_tracking_data'.tr(context),
              style: TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),




          ],
        ),
      ),
    );
  }

  Widget _buildError(
      BuildContext context, OrdersCubit cubit, OrdersState state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60.sp, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              state is OrderError
                  ? state.error
                  : state is OrderTrackingError
                      ? state.error
                      : 'order_not_found'.tr(context),
              style: TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('go_back'.tr(context)),
                ),
                SizedBox(width: 16.w),









              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingNumberCard(
      BuildContext context, OrderTrackResponse trackingResponse) {
    final trackingNumber = trackingResponse.trackingNo.isNotEmpty
        ? trackingResponse.trackingNo
        : 'not_available'.tr(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping,
                    size: 20.sp, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  'tracking_number'.tr(context),
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    trackingNumber,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print('Copied tracking number: $trackingNumber');
                    }

                    showToast(
                      context,
                      message: 'copied_to_clipboard'.tr(context),
                      state: ToastStates.success,
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 14.sp, color: AppColors.primary),
                        SizedBox(width: 4.w),
                        Text(
                          'copy'.tr(context),
                          style: TextStyle(
                              fontSize: 12.sp, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingProgress(
      BuildContext context, List<TrackingEvent> trackingEvents) {

    final Map<String, Map<String, String>> stepMap = {
      'Order Placed': {
        'title': 'order_placed',
        'subtitle': 'order_placed_subtitle'
      },
      'Order Packed': {
        'title': 'order_packed',
        'subtitle': 'order_packed_subtitle'
      },
      'Order Shipped': {
        'title': 'order_shipped',
        'subtitle': 'order_shipped_subtitle'
      },
      'Order Delivered': {
        'title': 'order_delivered',
        'subtitle': 'order_delivered_subtitle'
      },
      'Order Cancelled': {
        'title': 'order_cancelled',
        'subtitle': 'order_cancelled_subtitle'
      },
    };


    final completedSteps = <String, TrackingEvent>{};
    for (final event in trackingEvents) {

      for (final stepKey in stepMap.keys) {
        if (event.title.toLowerCase().contains(stepKey.toLowerCase())) {
          completedSteps[stepKey] = event;
          break;
        }
      }
    }


    final orderedSteps = stepMap.entries.toList();

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'tracking_progress'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 16.h),
            ...orderedSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final stepKey = entry.value.key;
              final stepData = entry.value.value;
              final event = completedSteps[stepKey];
              final isCompleted = event != null;
              final hasNextStep = index < orderedSteps.length - 1;

              return _buildTrackingStep(
                stepKey,
                stepData['subtitle']!,
                isCompleted,
                hasNextStep,
                event?.createdAt,
                event?.text ?? '',
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStep(
    String title,
    String subtitle,
    bool isCompleted,
    bool hasNextStep,
    DateTime? eventDate,
    String eventText,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: hasNextStep ? 16.h : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.primary : AppColors.lightGrey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isCompleted ? AppColors.primary : AppColors.lightGrey,
                    width: 2.w,
                  ),
                ),
                child: isCompleted
                    ? Icon(Icons.check, size: 14.sp, color: AppColors.white)
                    : null,
              ),
              if (hasNextStep)
                Container(
                  width: 2.w,
                  height: 40.h,
                  color: isCompleted ? AppColors.primary : AppColors.lightGrey,
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title.tr(context),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppColors.textBlack
                              : AppColors.textGrey,
                        ),
                      ),
                    ),
                    if (eventDate != null)
                      Text(
                        _formatDate(eventDate),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                if (eventText.isNotEmpty)
                  Text(
                    eventText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                SizedBox(height: 2.h),
                Text(
                  subtitle.tr(context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context,
      OrderTrackResponse trackingResponse, OrderModel? order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.1),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_summary'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'order_date'.tr(context),
                style: TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
              ),
              const Spacer(),
              Text(
                trackingResponse.orderDate.isNotEmpty
                    ? trackingResponse.orderDate
                    : _formatDate(order?.transactionDate ?? DateTime.now()),
                style: TextStyle(fontSize: 14.sp, color: AppColors.textBlack),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'items'.tr(context),
                style: TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
              ),
              const Spacer(),
              Text(
                '${trackingResponse.items}',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textBlack),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.lightGrey),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'total'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const Spacer(),
              Text(
                trackingResponse.finalTotal.isNotEmpty
                    ? trackingResponse.finalTotal
                    : formatCurrency(context, order?.finalTotal ?? 0),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
