import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/product_details_model.dart';

//! ProductNameAndStore
class ProductNameAndStore extends StatelessWidget {
  final ProductDetailsModel product;

  const ProductNameAndStore({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name?.tr(context) ?? 'No Name',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          product.storeName?.tr(context) ?? 'Unknown Store',
          style: TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
        ),
      ],
    );
  }
}

