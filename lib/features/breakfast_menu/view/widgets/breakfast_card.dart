import 'dart:io';

import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/item_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../order/view/cubit/order_cubit.dart';
import '../cubit/breakfast_menu_cubit.dart';
import 'add_edit_sheet.dart';

class BreakfastCard extends StatelessWidget {
  const BreakfastCard({
    super.key,
    required this.item,
    required this.isRequester,
    required this.requesterName,
  });

  final BreakfastItemModel item;
  final bool isRequester;
  final String requesterName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 25,
            offset: const Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItemIcon(context),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: _buildItemDetails(context),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                if (isRequester) _buildOrderButton(context),
              ],
            ),
          ),
          if (!isRequester)
            PositionedDirectional(
              top: 16.w,
              end: 16.w,
              child: _buildHostActions(context),
            ),
          if (item.isHot) _buildHotBadge(context),
        ],
      ),
    );
  }

  Widget _buildItemIcon(BuildContext context) {
    final hasImage = item.image != null && item.image!.isNotEmpty;
    return Stack(
      children: [
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.12),
                AppColors.secondary.withOpacity(0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            image: hasImage && File(item.image!).existsSync()
                ? DecorationImage(
                    image: FileImage(File(item.image!)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: !hasImage
              ? Center(
                  child: Icon(
                    _iconForType(item.type),
                    color: AppColors.primary.withOpacity(0.8),
                    size: 32.sp,
                  ),
                )
              : null,
        ),
        // Type indicator
        Positioned(
          bottom: -6.h,
          right: -6.w,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              _iconForType(item.type),
              size: 14.sp,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  if (item.createdAt != null)
                    Text(
                      _formatDate(context, item.createdAt!),
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          item.description.isNotEmpty
              ? item.description
              : 'no_description'.tr(context),
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13.5.sp,
            height: 1.5,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: [
            ItemTag(
              label: item.type.label.tr(context),
              icon: _iconForType(item.type),
              color: AppColors.primary,
              size: 'small',
            ),
            if (item.isHot)
              ItemTag(
                label: 'hot_label'.tr(context),
                icon: Iconsax.flash,
                color: AppColors.secondary,
                size: 'small',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 46.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        onPressed: () => _showOrderSheet(context, item),
        icon: Icon(
          Iconsax.shopping_cart,
          size: 18.sp,
          color: Colors.white,
        ),
        label: Text(
          'order_button'.tr(context),
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHostActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => openAddEditSheetModal(context, existingItem: item),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColors.border.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Icon(
                  Iconsax.edit_2,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          // Delete Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showDeleteDialog(context, item),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              child: Container(
                padding: EdgeInsets.all(10.w),
                child: Icon(
                  Iconsax.trash,
                  size: 18.sp,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotBadge(BuildContext context) {
    return PositionedDirectional(
      top: 12.h,
      start: 12.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondary,
              AppColors.secondary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.flash,
              size: 12.sp,
              color: Colors.white,
            ),
            SizedBox(width: 4.w),
            Text(
              'hot_label'.tr(context),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'time_minutes_ago'
          .tr(context)
          .replaceAll('{0}', '${difference.inMinutes}');
    } else if (difference.inHours < 24) {
      return 'time_hours_ago'
          .tr(context)
          .replaceAll('{0}', '${difference.inHours}');
    } else if (difference.inDays < 7) {
      return 'time_days_ago'
          .tr(context)
          .replaceAll('{0}', '${difference.inDays}');
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showDeleteDialog(BuildContext context, BreakfastItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.warning_2,
                color: AppColors.error,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'delete_title'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        content: Text(
          'delete_item_confirm'.tr(context).replaceAll('{0}', item.name),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'cancel'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<BreakfastMenuCubit>().deleteItem(item.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    elevation: 0,
                  ),
                  child: Text(
                    'delete'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOrderSheet(BuildContext context, BreakfastItemModel item) {
    final quantity = ValueNotifier<int>(1);
    final noteController = TextEditingController();

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
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.8,
                builder: (_, scrollController) {
                  return ValueListenableBuilder<int>(
                    valueListenable: quantity,
                    builder: (context, qty, _) {
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
                              // Drag Handle
                              Container(
                                margin: EdgeInsets.only(top: 12.h, bottom: 4.h),
                                width: 48.w,
                                height: 4.h,
                                decoration: BoxDecoration(
                                  color: AppColors.border.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 16.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: AppColors.primary
                                                .withOpacity(0.1),
                                            radius: 20.r,
                                            child: Icon(
                                              _iconForType(item.type),
                                              color: AppColors.primary,
                                              size: 20.sp,
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Text(
                                              item.name,
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textBlack,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      if (item.description.isNotEmpty)
                                        Text(
                                          item.description,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      SizedBox(height: 24.h),
                                      // Quantity Selector
                                      _buildQuantitySelector(
                                        sheetContext,
                                        qty,
                                        onDecrement: () {
                                          if (qty > 1) quantity.value = qty - 1;
                                        },
                                        onIncrement: () =>
                                            quantity.value = qty + 1,
                                      ),
                                      SizedBox(height: 20.h),
                                      // Notes
                                      _buildOrderNotes(
                                          sheetContext, noteController),
                                      SizedBox(height: 32.h),
                                      // Action Buttons
                                      _buildOrderActions(
                                        context,
                                        sheetContext,
                                        item,
                                        qty,
                                        noteController,
                                      ),
                                      SizedBox(height: 20.h),
                                    ],
                                  ),
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

  Widget _buildQuantitySelector(
    BuildContext context,
    int quantity, {
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quantity_label'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: Icon(
                  Iconsax.minus,
                  size: 28.sp,
                  color: quantity > 1 ? AppColors.primary : AppColors.border,
                ),
              ),
              Text(
                '$quantity',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBlack,
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: Icon(
                  Iconsax.add_circle,
                  size: 28.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderNotes(
      BuildContext context, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.note_text,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              'order_notes_label'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'order_notes_hint'.tr(context),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderActions(
    BuildContext context,
    BuildContext sheetContext,
    BreakfastItemModel item,
    int quantity,
    TextEditingController noteController,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(sheetContext),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'cancel'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(sheetContext);
              context.read<OrderCubit>().placeQuickRequest(
                    item,
                    note: noteController.text.trim().isEmpty
                        ? null
                        : noteController.text.trim(),
                    quantity: quantity,
                    requesterName: requesterName,
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              elevation: 0,
            ),
            icon: Icon(
              Iconsax.send_2,
              size: 20.sp,
            ),
            label: Text(
              'send_order'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _iconForType(BreakfastType type) {
    switch (type) {
      case BreakfastType.drink:
        return Iconsax.coffee;
      case BreakfastType.snack:
        return Iconsax.cake;
      case BreakfastType.sandwich:
        return Icons.lunch_dining;
    }
  }
}
