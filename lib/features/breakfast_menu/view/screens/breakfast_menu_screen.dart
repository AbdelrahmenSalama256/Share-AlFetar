import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:cozy/features/breakfast_menu/view/cubit/breakfast_menu_cubit.dart';
import 'package:cozy/features/breakfast_menu/view/cubit/breakfast_menu_state.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/actions_row.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/breakfast_card.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/breakfast_filter_row.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/breakfast_header.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/host_overlay.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/menu_empty_state.dart';
import 'package:cozy/features/mode/data/repo/mode_repo.dart';
import 'package:cozy/features/mode/view/cubit/mode_cubit.dart';
import 'package:cozy/features/mode/view/cubit/mode_state.dart';
import 'package:cozy/features/order/view/cubit/order_cubit.dart';
import 'package:cozy/features/order/view/cubit/order_state.dart';
import 'package:cozy/features/order/view/screens/orders_log_screen.dart';
import 'package:cozy/features/order/view/screens/sharing_guide_screen.dart';
import 'package:cozy/features/overlay/view/cubit/popup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../order/data/model/breakfast_request_model.dart';
import '../widgets/add_edit_sheet.dart';

class BreakfastMenuScreen extends StatefulWidget {
  const BreakfastMenuScreen({super.key});

  @override
  State<BreakfastMenuScreen> createState() => _BreakfastMenuScreenState();
}

class _BreakfastMenuScreenState extends State<BreakfastMenuScreen> {
  Future<void> _handleImport(BuildContext context) async {
    await context
        .read<BreakfastMenuCubit>()
        .importFromFile('/sdcard/Download/share_al_fetaar_pack.json');
    if (!mounted) return;
    _showSuccessSnack(context, 'import_success'.tr(context));
  }

  Future<void> _handleExport(BuildContext context) async {
    await context
        .read<BreakfastMenuCubit>()
        .exportToFile('/sdcard/Download/share_al_fetaar_pack.json');
    if (!mounted) return;
    _showSuccessSnack(context, 'export_success'.tr(context));
  }

  void _openOrdersLog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrdersLogScreen()),
    );
  }

  Future<void> _openMultiOrder(BuildContext context) async {
    final menuCubit = context.read<BreakfastMenuCubit>();
    final modeState = context.read<ModeCubit>().state;
    final items = menuCubit.state is BreakfastMenuLoaded
        ? (menuCubit.state as BreakfastMenuLoaded).items
        : menuCubit.filteredItems;

    if (items.isEmpty) {
      _showErrorSnack(context, 'no_items_to_order'.tr(context));
      return;
    }

    final itemMap = {for (final item in items) item.id: item};
    final selections = ValueNotifier<Map<String, int>>({});
    final noteController = TextEditingController();
    final deliveryController = TextEditingController(text: '0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return GestureDetector(
          onTap: () => Navigator.pop(sheetContext),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: GestureDetector(
              onTap: () {},
              child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                builder: (_, scrollController) {
                  return ValueListenableBuilder<Map<String, int>>(
                    valueListenable: selections,
                    builder: (context, selected, _) {
                      final subtotal = selected.entries.fold<double>(
                        0.0,
                        (sum, entry) {
                          final item = itemMap[entry.key];
                          if (item == null) return sum;
                          final qty = entry.value <= 0 ? 1 : entry.value;
                          return sum + (item.price * qty);
                        },
                      );
                      final itemDelivery = selected.entries.fold<double>(
                        0.0,
                        (sum, entry) {
                          final item = itemMap[entry.key];
                          if (item == null) return sum;
                          final qty = entry.value <= 0 ? 1 : entry.value;
                          return sum + (item.deliveryFee * qty);
                        },
                      );
                      final manualDelivery =
                          double.tryParse(deliveryController.text) ?? 0.0;
                      final total = subtotal + itemDelivery + manualDelivery;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(28.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(sheetContext).viewInsets.bottom,
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                                width: 48.w,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  color: AppColors.border.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 8.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.shopping_bag,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'multi_order'.tr(context),
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  controller: scrollController,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 8.h),
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 10.h),
                                  itemBuilder: (context, index) {
                                    final item = items[index];
                                    final qty = selected[item.id] ?? 0;
                                    return Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.border),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        color: qty > 0
                                            ? AppColors.primary
                                                .withOpacity(0.04)
                                            : Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.textBlack,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  '${item.classification.toUpperCase()} · ${item.type.label.tr(context)}',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  'Price: ${item.price.toStringAsFixed(2)} / Delivery: ${item.deliveryFee.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: AppColors
                                                        .textSecondary
                                                        .withOpacity(0.9),
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  final next =
                                                      Map<String, int>.from(
                                                          selected);
                                                  final current =
                                                      next[item.id] ?? 0;
                                                  if (current <= 0) return;
                                                  if (current == 1) {
                                                    next.remove(item.id);
                                                  } else {
                                                    next[item.id] = current - 1;
                                                  }
                                                  selections.value = next;
                                                },
                                                icon: Icon(
                                                  Iconsax.minus,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              Text(
                                                '$qty',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  final next =
                                                      Map<String, int>.from(
                                                          selected);
                                                  final current =
                                                      next[item.id] ?? 0;
                                                  next[item.id] = current + 1;
                                                  selections.value = next;
                                                },
                                                icon: Icon(
                                                  Iconsax.add_circle,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'order_notes_label'.tr(context),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border:
                                            Border.all(color: AppColors.border),
                                      ),
                                      child: TextField(
                                        controller: noteController,
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          hintText:
                                              'order_notes_hint'.tr(context),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(12.w),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'delivery_fee'.tr(context),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBlack,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border:
                                            Border.all(color: AppColors.border),
                                      ),
                                      child: TextField(
                                        controller: deliveryController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: '0',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 14.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'items_total'.tr(context),
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        Text(
                                          subtotal.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'delivery_total'.tr(context),
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        Text(
                                          (itemDelivery + manualDelivery)
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'total'.tr(context),
                                          style: TextStyle(
                                            color: AppColors.textBlack,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          total.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 17.sp,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                Navigator.pop(sheetContext),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: AppColors.border),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.r),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14.h),
                                            ),
                                            child: Text(
                                              'cancel'.tr(context),
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              final entries = selections
                                                  .value.entries
                                                  .where((e) => (e.value) > 0)
                                                  .toList();
                                              if (entries.isEmpty) {
                                                _showErrorSnack(
                                                  context,
                                                  'select_at_least_one'
                                                      .tr(context),
                                                );
                                                return;
                                              }
                                              final selectedItems = entries
                                                  .map(
                                                    (e) => SelectedOrderItem(
                                                      item: itemMap[e.key]!,
                                                      quantity: e.value,
                                                    ),
                                                  )
                                                  .toList();
                                              final parsedDelivery =
                                                  double.tryParse(
                                                          deliveryController
                                                              .text) ??
                                                      0.0;
                                              Navigator.pop(sheetContext);
                                              context
                                                  .read<OrderCubit>()
                                                  .placeMultiRequest(
                                                    selectedItems,
                                                    note: noteController.text
                                                            .trim()
                                                            .isEmpty
                                                        ? null
                                                        : noteController.text
                                                            .trim(),
                                                    requesterName:
                                                        modeState.displayName,
                                                    deliveryFee: parsedDelivery,
                                                  );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14.r),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14.h),
                                              elevation: 0,
                                            ),
                                            icon: Icon(
                                              Iconsax.send_2,
                                              size: 18.sp,
                                            ),
                                            label: Text(
                                              'send_order'.tr(context),
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
      },
    );
  }

  Future<void> _handleShare(BuildContext context) async {
    final error = await context.read<OrderCubit>().shareActiveRequest();
    if (!mounted) return;
    if (error != null) {
      _showErrorSnack(context, 'share_error_no_request'.tr(context));
    } else {
      _showSuccessSnack(context, 'share_success_broadcast'.tr(context));
    }
  }

  void _openShareGuide(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SharingGuideScreen()),
    );
  }

  int _pendingCount(OrderState state) {
    if (state is OrderPlaced && state.request.status == RequestStatus.pending) {
      return 1;
    }
    if (state is OrderRestored &&
        state.request.status == RequestStatus.pending) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: _onOrderState,
      child: Scaffold(
        backgroundColor: AppColors.white,
        floatingActionButton: BlocBuilder<ModeCubit, ModeState>(
          builder: (context, modeState) {
            if (modeState.mode == UserMode.host) {
              return _buildHostFAB(context);
            }
            return const SizedBox.shrink();
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              const BreakfastHeader(),
              SizedBox(height: 16.h),
              BlocBuilder<ModeCubit, ModeState>(
                builder: (context, modeState) {
                  return BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, orderState) {
                      final pending = modeState.mode == UserMode.host
                          ? _pendingCount(orderState)
                          : 0;
                      return ActionsRow(
                        onImport: () => _handleImport(context),
                        onExport: () => _handleExport(context),
                        onOrdersLog: () => _openOrdersLog(context),
                        onShare: () => _handleShare(context),
                        onGuide: () => _openShareGuide(context),
                        pendingCount: pending,
                        showMultiOrder: modeState.mode == UserMode.requester,
                        onMultiOrder: () => _openMultiOrder(context),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 12.h),
              const BreakfastFilterRow(),
              SizedBox(height: 16.h),
              Expanded(
                child: Stack(
                  children: [
                    _buildBackgroundGradient(),
                    Positioned.fill(
                      child: _buildMenuContent(),
                    ),
                    const HostOverlay(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHostFAB(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      onPressed: () => openAddEditSheetModal(context),
      icon: Icon(
        Iconsax.add,
        size: 22.sp,
        color: AppColors.white,
      ),
      label: Text(
        'add_item'.tr(context),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    return BlocBuilder<BreakfastMenuCubit, BreakfastMenuState>(
      builder: (context, state) {
        if (state is BreakfastMenuLoading) {
          return _buildLoadingState();
        }

        if (state is BreakfastMenuError) {
          return Padding(
            padding: EdgeInsets.all(12.w),
            child: _buildErrorState(context, state.message),
          );
        }

        final items = state is BreakfastMenuLoaded
            ? state.items
            : context.read<BreakfastMenuCubit>().filteredItems;

        if (items.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildMenuList(context, items);
      },
    );
  }

  Widget _buildLoadingState() {
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
            'loading_menu'.tr(context),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 48.sp,
            color: AppColors.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'error_generic'.tr(context),
            style: TextStyle(
              color: AppColors.error,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message.tr(context),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.read<BreakfastMenuCubit>().loadMenu(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text('reload_menu'.tr(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: MenuEmptyState(
        onImport: () async {
          await context
              .read<BreakfastMenuCubit>()
              .importFromFile('/sdcard/Download/share_al_fetaar_pack.json');
        },
        onManualAdd: () => openAddEditSheetModal(context),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, List<BreakfastItemModel> items) {
    final mode = context.watch<ModeCubit>().state.mode;
    final requesterName = context.watch<ModeCubit>().state.displayName;
    final isRequester = mode == UserMode.requester;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(bottom: 100.h, top: 8.h),
          sliver: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = items[index];
              return BreakfastCard(
                item: item,
                isRequester: isRequester,
                requesterName: requesterName,
              );
            },
          ),
        ),
      ],
    );
  }

  void _showSuccessSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.tick_circle, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _showErrorSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.close_circle, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  void _onOrderState(BuildContext context, OrderState state) {
    if (state is OrderPlaced) {
      context.read<PopupCubit>().show(state.request);
      _showSuccessSnack(context, 'order_sent_toast'.tr(context));
    } else if (state is OrderRestored) {
      context.read<PopupCubit>().show(state.request);
    } else if (state is OrderStatusChanged) {
      context.read<PopupCubit>().clear();
      final accepted = state.request.status == RequestStatus.accepted
          ? 'order_status_accepted'.tr(context)
          : 'order_status_rejected'.tr(context);
      _showSuccessSnack(context, accepted);
    } else if (state is OrderError) {
      _showErrorSnack(context, state.message);
    }
  }
}
