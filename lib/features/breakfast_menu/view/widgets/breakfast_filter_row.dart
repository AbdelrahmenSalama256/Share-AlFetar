import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:cozy/features/breakfast_menu/view/cubit/breakfast_menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class BreakfastFilterRow extends StatelessWidget {
  const BreakfastFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BreakfastMenuCubit>();
    final filter = cubit.filter;
    final itemCount = cubit.filteredItems.length;
    final totalCount = cubit.menuItems.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'filter_all'.tr(context),
                  selected: filter == null,
                  onTap: () => cubit.setFilter(null),
                  count: totalCount,
                ),
                SizedBox(width: 8.w),
                _FilterChip(
                  label: 'filter_sandwiches'.tr(context),
                  selected: filter == BreakfastType.sandwich,
                  onTap: () => cubit.setFilter(BreakfastType.sandwich),
                  count: cubit.menuItems
                      .where((item) => item.type == BreakfastType.sandwich)
                      .length,
                ),
                SizedBox(width: 8.w),
                _FilterChip(
                  label: 'filter_drinks'.tr(context),
                  selected: filter == BreakfastType.drink,
                  onTap: () => cubit.setFilter(BreakfastType.drink),
                  count: cubit.menuItems
                      .where((item) => item.type == BreakfastType.drink)
                      .length,
                ),
                SizedBox(width: 8.w),
                _FilterChip(
                  label: 'filter_snacks'.tr(context),
                  selected: filter == BreakfastType.snack,
                  onTap: () => cubit.setFilter(BreakfastType.snack),
                  count: cubit.menuItems
                      .where((item) => item.type == BreakfastType.snack)
                      .length,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          if (filter != null)
            Row(
              children: [
                Text(
                  'filter_summary'
                      .tr(context)
                      .replaceAll('{0}', '$itemCount')
                      .replaceAll('{1}', '$totalCount'),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => cubit.setFilter(null),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.filter_remove,
                        size: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'filter_reset'.tr(context),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.category,
              size: 16.sp,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color:
                    selected ? Colors.white.withOpacity(0.2) : AppColors.border,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textSecondary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
