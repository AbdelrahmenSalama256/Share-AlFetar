import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/order/data/model/breakfast_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderPopup extends StatelessWidget {
  const OrderPopup({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    this.onDismiss,
  });

  final BreakfastRequestModel request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final item in request.items) {
      counts.update(item.name, (value) => value + 1, ifAbsent: () => 1);
    }
    final itemNames = counts.entries
        .map((e) => e.value > 1 ? '${e.key} x${e.value}' : e.key)
        .join(', ');
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.breakfast_dining,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'incoming_breakfast_request'.tr(context),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.close, color: Colors.white70, size: 20.sp),
                      onPressed: onDismiss,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '${request.requesterName} ${'wants'.tr(context)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  itemNames,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((request.note ?? '').isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    '"${request.note}"',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: Size(double.infinity, 44.h),
                        ),
                        onPressed: onAccept,
                        child: Text('accept'.tr(context)),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side:
                              const BorderSide(color: Colors.white, width: 1.5),
                          minimumSize: Size(double.infinity, 44.h),
                        ),
                        onPressed: onReject,
                        child: Text('reject'.tr(context)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
