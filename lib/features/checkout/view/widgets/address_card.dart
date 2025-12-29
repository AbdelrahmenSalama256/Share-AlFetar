import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! AddressCard
class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;

  const AddressCard({
    super.key,
    required this.address,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(4.r),
        border:
            isSelected ? Border.all(color: AppColors.primary, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: isSelected ? AppColors.primary : AppColors.textGrey,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address.name.isNotEmpty ? address.name : address.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    if (address.isDefault) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'default'.tr(context),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  address.fullAddress,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
                if (address.phone.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    address.phone,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
