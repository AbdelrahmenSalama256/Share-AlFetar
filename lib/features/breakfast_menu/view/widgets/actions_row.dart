import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ActionsRow extends StatelessWidget {
  const ActionsRow({
    super.key,
    required this.onImport,
    required this.onExport,
    required this.onOrdersLog,
    required this.onShare,
    required this.onGuide,
    this.pendingCount = 0,
    this.onMultiOrder,
    this.showMultiOrder = false,
  });

  final VoidCallback onImport;
  final VoidCallback onExport;
  final VoidCallback onOrdersLog;
  final VoidCallback onShare;
  final VoidCallback onGuide;
  final int pendingCount;
  final VoidCallback? onMultiOrder;
  final bool showMultiOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = (constraints.maxWidth - 8.w) / 2;
          return Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _ActionButton(
                width: buttonWidth,
                onPressed: onImport,
                icon: Iconsax.import,
                label: 'action_import'.tr(context),
              ),
              _ActionButton(
                width: buttonWidth,
                onPressed: onExport,
                icon: Iconsax.export,
                label: 'action_export'.tr(context),
              ),
              _ActionButton(
                width: buttonWidth,
                onPressed: onShare,
                icon: Iconsax.send_2,
                label: 'action_share'.tr(context),
                isPrimary: true,
              ),
              if (showMultiOrder)
                _ActionButton(
                  width: buttonWidth,
                  onPressed: onMultiOrder ?? () {},
                  icon: Iconsax.shopping_bag,
                  label: 'action_multi_order'.tr(context),
                  isPrimary: true,
                ),
              _ActionButton(
                width: buttonWidth,
                onPressed: onOrdersLog,
                icon: Iconsax.receipt,
                label: 'action_orders_log'.tr(context),
                outlined: true,
                badgeCount: pendingCount,
              ),
              _ActionButton(
                width: buttonWidth,
                onPressed: onGuide,
                icon: Iconsax.info_circle,
                label: 'action_guide'.tr(context),
                outlined: true,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.width,
    this.isPrimary = false,
    this.outlined = false,
    this.badgeCount = 0,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final double width;
  final bool isPrimary;
  final bool outlined;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: outlined ? AppColors.textBlack : Colors.white,
        ),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );

    final button = outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              side: BorderSide(color: AppColors.border),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor:
                  isPrimary ? AppColors.secondary : AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: child,
          );

    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          if (badgeCount > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
