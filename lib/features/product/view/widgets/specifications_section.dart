import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! SpecificationsSection
class SpecificationsSection extends StatelessWidget {
  final Map<String, String> specifications;

  const SpecificationsSection({super.key, required this.specifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('specifications'.tr(context),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        ...specifications.entries.map(
          (entry) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    entry.key.tr(context),
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Text(entry.value, style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

