import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/offline_share_service.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:cozy/features/mode/data/repo/mode_repo.dart';
import 'package:cozy/features/mode/view/cubit/mode_cubit.dart';
import 'package:cozy/features/order/data/model/breakfast_request_model.dart';
import 'package:cozy/features/order/data/repo/order_repo.dart';
import 'package:cozy/features/order/view/cubit/order_cubit.dart';
import 'package:cozy/features/overlay/view/cubit/popup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class OrdersLogScreen extends StatefulWidget {
  const OrdersLogScreen({super.key});

  @override
  State<OrdersLogScreen> createState() => _OrdersLogScreenState();
}

class _OrdersLogScreenState extends State<OrdersLogScreen> {
  Future<List<BreakfastRequestModel>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<BreakfastRequestModel>> _load() async {
    final result = await sl<OrderRepoLocal>().getLog();
    return result.fold((_) => <BreakfastRequestModel>[], (reqs) => reqs);
  }

  @override
  Widget build(BuildContext context) {
    final isHost = context.watch<ModeCubit>().state.mode == UserMode.host;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.03),
              AppColors.secondary.withOpacity(0.03),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: FutureBuilder<List<BreakfastRequestModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            }
            final initial = snapshot.data ?? <BreakfastRequestModel>[];
            return StreamBuilder<List<BreakfastRequestModel>>(
              stream: sl<OrderRepoLocal>().watchLog(),
              builder: (context, streamSnapshot) {
                final requests = List<BreakfastRequestModel>.from(
                  streamSnapshot.data ?? initial,
                )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (requests.isEmpty) {
                  return _buildEmptyState(context);
                }

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, requests.length),
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: requests.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final req = requests[index];
                            return _OrderCard(
                              request: req,
                              isHost: isHost,
                              onAccept: req.status == RequestStatus.pending
                                  ? () => _respond(req, RequestStatus.accepted)
                                  : null,
                              onReject: req.status == RequestStatus.pending
                                  ? () => _respond(req, RequestStatus.rejected)
                                  : null,
                              onSendReceipt: req.status == RequestStatus.accepted
                                  ? () => _sendReceipt(req)
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'orders_log'.tr(context),
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: Transform.rotate(
        angle: 3.14,
        child: IconButton(
          icon: Icon(
            Iconsax.arrow_left_1,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.receipt,
              size: 24.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'all_orders'.tr(context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$count requests shared over your local network',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.0,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading orders...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.receipt_search,
                size: 48.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'no_saved_orders'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'no_active_orders'.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _respond(BreakfastRequestModel req, RequestStatus status) async {
    context.read<PopupCubit>().clear();
    await context.read<OrderCubit>().respondToRequest(req.id, status);
  }

  Future<void> _sendReceipt(BreakfastRequestModel req) async {
    await OfflineShareService.sendReceipt(req);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt sent to network'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.request,
    required this.isHost,
    this.onAccept,
    this.onReject,
    this.onSendReceipt,
  });

  final BreakfastRequestModel request;
  final bool isHost;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onSendReceipt;

  Color _getStatusColor() {
    switch (request.status) {
      case RequestStatus.pending:
        return AppColors.warning;
      case RequestStatus.accepted:
        return AppColors.success;
      case RequestStatus.rejected:
        return AppColors.error;
    }
  }

  String _getStatusText(BuildContext context) {
    switch (request.status) {
      case RequestStatus.pending:
        return 'pending'.tr(context);
      case RequestStatus.accepted:
        return 'accepted'.tr(context);
      case RequestStatus.rejected:
        return 'rejected'.tr(context);
    }
  }

  List<_GroupedItem> _groupedItems() {
    final Map<String, _GroupedItem> groups = {};
    for (final item in request.items) {
      final existing = groups[item.id];
      if (existing != null) {
        existing.quantity++;
        existing.totalPrice += item.price;
        existing.totalDelivery += item.deliveryFee;
      } else {
        groups[item.id] = _GroupedItem(
          name: item.name,
          quantity: 1,
          type: item.type,
          classification: item.classification,
          unitPrice: item.price,
          totalPrice: item.price,
          totalDelivery: item.deliveryFee,
        );
      }
    }
    return groups.values.toList();
  }

  String _formatTimestamp(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${date.year}/${two(date.month)}/${two(date.day)} ${two(date.hour)}:${two(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedItems();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppColors.primary.withOpacity(0.12),
                  child: Text(
                    request.requesterName.isNotEmpty
                        ? request.requesterName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.requesterName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBlack,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _formatTimestamp(request.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: _getStatusColor().withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.info_circle,
                        size: 14.sp,
                        color: _getStatusColor(),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _getStatusText(context),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(color: AppColors.border),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Iconsax.box,
                    size: 20.sp,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'items'.tr(context),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ...grouped.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.name} x${item.quantity}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ),
                          Text(
                            '${item.classification.toUpperCase()} · ${item.type.label.tr(context)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.unitPrice.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          item.totalPrice.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if ((request.note ?? '').isNotEmpty) ...[
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  request.note!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _totalRow('items_total'.tr(context),
                      request.itemsTotal.toStringAsFixed(2)),
                  SizedBox(height: 6.h),
                  _totalRow(
                      'delivery_total'.tr(context),
                      request.totalDelivery > 0
                          ? request.totalDelivery.toStringAsFixed(2)
                          : '0.00'),
                  SizedBox(height: 8.h),
                  _totalRow(
                    'total'.tr(context),
                    request.grandTotal.toStringAsFixed(2),
                    highlight: true,
                  ),
                ],
              ),
            ),
            if (isHost && (onAccept != null || onReject != null)) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (onAccept != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 44.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(Iconsax.tick_circle, size: 18.sp),
                        label: Text('accept'.tr(context)),
                      ),
                    ),
                  if (onAccept != null && onReject != null)
                    SizedBox(width: 10.w),
                  if (onReject != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onReject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 44.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(Iconsax.close_circle, size: 18.sp),
                        label: Text('reject'.tr(context)),
                      ),
                    ),
                ],
              ),
            ],
            if (isHost &&
                onSendReceipt != null &&
                request.status == RequestStatus.accepted) ...[
              SizedBox(height: 10.h),
              OutlinedButton.icon(
                onPressed: onSendReceipt,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                icon: Icon(Iconsax.send_1, color: AppColors.primary),
                label: Text(
                  'send_receipt'.tr(context),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _totalRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: highlight ? AppColors.textBlack : AppColors.textSecondary,
            fontSize: highlight ? 15.sp : 13.sp,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? AppColors.primary : AppColors.textBlack,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w700,
            fontSize: highlight ? 16.sp : 14.sp,
          ),
        ),
      ],
    );
  }
}

class _GroupedItem {
  _GroupedItem({
    required this.name,
    required this.quantity,
    required this.type,
    required this.classification,
    required this.unitPrice,
    required this.totalPrice,
    required this.totalDelivery,
  });

  final String name;
  int quantity;
  final BreakfastType type;
  final String classification;
  final double unitPrice;
  double totalPrice;
  double totalDelivery;
}
