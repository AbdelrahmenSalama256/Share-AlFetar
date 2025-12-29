import '../../data/models/order_status.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/currency_formatter.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:cozy/features/profile/view/cubit/orders_cubit.dart';
import 'package:cozy/features/profile/view/cubit/orders_state.dart';
import 'package:cozy/features/profile/view/tracking_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/order_details_item_model.dart';

import '../../../../core/component/custom_toast.dart';
import '../../../../core/constants/widgets/custom_cached_image.dart';
import '../../../../core/cubit/global_cubit.dart';
import '../../../product/view/product_details_screen.dart';
import '../../../customer_services/view/customer_service_screen.dart';

Widget buildOrderStatusCard(BuildContext context, OrderModel order) {
  final statusColor = _getStatusColor(order.status);

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w),
    padding: EdgeInsets.all(16.w),
    decoration: _buildCardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusBadge(context, order, statusColor),
            const Spacer(),
            _buildOrderDate(order),
          ],
        ),
        SizedBox(height: 8.h),
        _buildInvoiceNumber(context, order),
      ],
    ),
  );
}

Color _getStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
    case OrderStatus.orderd:
      return AppColors.warning;
    case OrderStatus.shipped:
      return AppColors.primary;
    case OrderStatus.delivered:
      return AppColors.success;
    case OrderStatus.cancelled:
      return AppColors.error;
    default:
      return AppColors.textGrey;
  }
}

BoxDecoration _buildCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

Widget _buildStatusBadge(
    BuildContext context, OrderModel order, Color statusColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: statusColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Text(
      order.statusText.tr(context),
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: statusColor,
      ),
    ),
  );
}

Widget _buildOrderDate(OrderModel order) {
  return Text(
    _formatDate(order.transactionDate),
    style: TextStyle(
      fontSize: 14.sp,
      color: AppColors.textGrey,
    ),
  );
}

Widget _buildInvoiceNumber(BuildContext context, OrderModel order) {
  return Text(
    '${'invoice_number'.tr(context)}: ${order.invoiceNo}',
    style: TextStyle(
      fontSize: 14.sp,
      color: AppColors.textGrey,
    ),
  );
}

Widget buildOrderItemsList(BuildContext context, List<OrderItem> items) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w),
    decoration: _buildCardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            'order_items'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(
            height: 1.h,
            color: AppColors.lightGrey,
            indent: 16.w,
            endIndent: 16.w,
          ),
          itemBuilder: (context, index) =>
              _buildOrderItem(context, items[index]),
        ),
      ],
    ),
  );
}

Widget _buildOrderItem(BuildContext context, OrderItem item) {
  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Row(
      children: [
        _buildProductImage(item),
        SizedBox(width: 12.w),
        _buildProductDetails(context, item),
      ],
    ),
  );
}

Widget _buildProductImage(OrderItem item) {
  final imageUrl = item.productImage ?? '';
  final hasImage = imageUrl.isNotEmpty && imageUrl != 'null';

  return Container(
    width: 60.w,
    height: 60.w,
    decoration: BoxDecoration(
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: hasImage
          ? CustomCachedImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              h: 60.w,
              w: 60.w,
            )
          : _buildPlaceholderIcon(),
    ),
  );
}

Widget _buildProductDetails(BuildContext context, OrderItem item) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductName(item),
        SizedBox(height: 4.h),
        if (item.variations != null && item.variations!.isNotEmpty)
          _buildVariations(context, item),
        SizedBox(height: 4.h),
        _buildQuantityAndPrice(context, item),
        SizedBox(height: 4.h),
        _buildTotalPrice(context, item),
      ],
    ),
  );
}

Widget _buildProductName(OrderItem item) {
  return Text(
    item.productName,
    style: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textBlack,
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}

Widget _buildVariations(BuildContext context, OrderItem item) {
  return Text(
    '${'variation'.tr(context)}: ${item.variations}',
    style: TextStyle(
      fontSize: 12.sp,
      color: AppColors.textGrey,
    ),
  );
}

Widget _buildQuantityAndPrice(BuildContext context, OrderItem item) {
  return Row(
    children: [
      Text(
        '${'quantity'.tr(context)}: ${item.quantity}',
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.textGrey,
        ),
      ),
      const Spacer(),
      Text(
        formatCurrency(context, item.unitPrice),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    ],
  );
}

Widget _buildTotalPrice(BuildContext context, OrderItem item) {
  return Text(
    '${'total'.tr(context)}: ${formatCurrency(context, item.lineTotal)}',
    style: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textBlack,
    ),
  );
}

Widget _buildPlaceholderIcon() {
  return Icon(
    Icons.shopping_bag,
    color: AppColors.textGrey,
    size: 30.sp,
  );
}

Widget buildShippingAddressCard(BuildContext context, OrderModel order) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w),
    padding: EdgeInsets.all(16.w),
    decoration: _buildCardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              'shipping_address'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          order.shippingAddress!,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}

Widget buildOrderSummaryCard(BuildContext context, OrderModel order) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w),
    padding: EdgeInsets.all(16.w),
    decoration: _buildCardDecoration(),
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
        SizedBox(height: 16.h),
        _buildSummaryItems(context, order),
        SizedBox(height: 12.h),
        const Divider(color: AppColors.lightGrey),
        SizedBox(height: 12.h),
        _buildTotalRow(context, order.finalTotal),
      ],
    ),
  );
}

Widget _buildSummaryItems(BuildContext context, OrderModel order) {
  return Column(
    children: [
      _buildSummaryRow(context, 'subtotal'.tr(context), order.totalBeforeTax),
      SizedBox(height: 8.h),
      _buildSummaryRow(context, 'tax'.tr(context), order.taxAmount),
      if (order.shippingCharges > 0) ...[
        SizedBox(height: 8.h),
        _buildSummaryRow(
            context, 'shipping_charges'.tr(context), order.shippingCharges),
      ],
    ],
  );
}

Widget _buildSummaryRow(BuildContext context, String label, double amount) {
  return Row(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textGrey,
        ),
      ),
      const Spacer(),
      Text(
        formatCurrency(context, amount),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.textBlack,
        ),
      ),
    ],
  );
}

Widget _buildTotalRow(BuildContext context, double total) {
  return Row(
    children: [
      Text(
        'total'.tr(context),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
        ),
      ),
      const Spacer(),
      Text(
        formatCurrency(context, total),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    ],
  );
}

Widget buildActionButtons(OrderModel order, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.w),
    child: Column(
      children: [
        if (order.status == OrderStatus.pending ||
            order.status == OrderStatus.orderd)
          _buildCancelOrderButton(order, context),
        SizedBox(height: 12.h),
        _buildSupportAndReorderButtons(context, order),
        if (order.status == OrderStatus.shipped) ...[
          SizedBox(height: 12.h),
          _buildTrackOrderButton(context, order.id),
        ],
      ],
    ),
  );
}

Widget _buildCancelOrderButton(OrderModel order, BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: AppButton(
      text: 'cancel_order'.tr(context),
      onPressed: () => _showCancelOrderDialog(order, context),
      type: AppButtonType.secondary,
      height: 48.h,
      borderRadius: BorderRadius.circular(8.r),
      borderColor: Colors.red,
      textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.red,
      ),
    ),
  );
}

Widget _buildSupportAndReorderButtons(BuildContext context, OrderModel order) {
  return Row(
    children: [
      Expanded(
        child: AppButton(
          text: 'contact_support'.tr(context),
          onPressed: () => _contactSupport(context),
          type: AppButtonType.secondary,
          height: 48.h,
          borderRadius: BorderRadius.circular(8.r),
          borderColor: AppColors.primary,
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: AppButton(
          text: 'reorder'.tr(context),
          onPressed: () => _reorder(context, order),
          type: AppButtonType.primary,
          height: 48.h,
          borderRadius: BorderRadius.circular(8.r),
          backgroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

Widget _buildTrackOrderButton(BuildContext context, final String orderId) {
  return SizedBox(
    width: double.infinity,
    child: AppButton(
      text: 'track_order'.tr(context),
      onPressed: () {
        navigateTo(
            context,
            OrderTrackingDetailsScreen(
              orderId: orderId,
            ));
      },
      type: AppButtonType.primary,
      height: 48.h,
      borderRadius: BorderRadius.circular(8.r),
      backgroundColor: AppColors.primary,
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );
}

void _contactSupport(BuildContext context) {
  navigateTo(context, const CustomerServiceScreen());
}

void _reorder(BuildContext context, OrderModel order) {
  final global = context.read<GlobalCubit>();

  String? requiresVariationProductId;
  for (final item in order.items) {
    final hasVariation = (item.variations != null && item.variations!.isNotEmpty);
    if (!hasVariation) {
      global.addToCart(
        productId: item.productId,
        quantity: item.quantity,
        variation: 0,
      );
    } else {
      requiresVariationProductId ??= item.productId;
    }
  }

  if (requiresVariationProductId != null) {
    showToast(
      context,
      message: 'please_select_a_variations'.tr(context),
      state: ToastStates.warning,
    );
    navigateTo(
      context,
      ProductDetailsScreen(productId: int.tryParse(requiresVariationProductId) ?? 0),
    );
  }
}

void _showCancelOrderDialog(OrderModel order, BuildContext context) {
  final ordersCubit = context.read<OrdersCubit>();

  showDialog(
    
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        title: Text(
          'cancel_order'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        content: Text(
          'are_you_sure_cancel_order'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'no'.tr(context),
                  onPressed: () => Navigator.pop(dialogContext),
                  type: AppButtonType.secondary,
                  height: 36.h,
                  borderRadius: BorderRadius.circular(8.r),
                  borderColor: AppColors.textGrey,
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AppButton(
                  text: 'yes_cancel'.tr(context),
                  onPressed: () => ordersCubit.cancelOrder(order.id),
                  type: AppButtonType.primary,
                  height: 36.h,
                  isLoading: ordersCubit.state is OrderLoading,
                  borderRadius: BorderRadius.circular(8.r),
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}



