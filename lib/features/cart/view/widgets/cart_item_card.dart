import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/currency_formatter.dart';
import 'package:cozy/features/cart/data/model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy/core/constants/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! CartItemCard
class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
  final VoidCallback ontap;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final unitPrice = cartItem.product?.price ?? 0;
    final qty = cartItem.quantity ?? 1;
    final lineTotal = unitPrice * qty;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CustomCachedImage(
                imageUrl: cartItem.product?.imagePath,
                w: 84.w,
                h: 84.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.product?.name?.tr(context) ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBlack),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              cartItem.product?.storeName?.tr(context) ?? '',
                              style: TextStyle(
                                  fontSize: 12.sp, color: AppColors.textGrey),
                            ),
                            if ((cartItem.variationName?.isNotEmpty ??
                                false)) ...[
                              SizedBox(height: 6.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  cartItem.variationName!,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.textBlack),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: onRemove,
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(CupertinoIcons.trash,
                              size: 18.sp, color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatCurrency(context, lineTotal),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${formatCurrency(context, unitPrice)}  ×  $qty',
                              style: TextStyle(
                                  fontSize: 12.sp, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                      _QtyStepper(
                        quantity: qty,
                        onDec: () {
                          if (qty > 1) {
                            onQuantityChanged(qty - 1);
                          } else {
                            onRemove();
                          }
                        },
                        onInc: () => onQuantityChanged(qty + 1),
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
  }
}

//! _QtyStepper
class _QtyStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDec;
  final VoidCallback onInc;

  const _QtyStepper({
    required this.quantity,
    required this.onDec,
    required this.onInc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SquareBtn(
          onTap: onDec,
          bg: AppColors.lightGrey,
          icon: CupertinoIcons.minus,
          iconColor: AppColors.textGrey,
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 36.w,
          child: Center(
            child: Text(
              '$quantity',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textBlack),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        _SquareBtn(
          onTap: onInc,
          bg: AppColors.primary,
          icon: CupertinoIcons.add,
          iconColor: Colors.white,
        ),
      ],
    );
  }
}

//! _SquareBtn
class _SquareBtn extends StatelessWidget {
  final VoidCallback onTap;
  final Color bg;
  final IconData icon;
  final Color iconColor;

  const _SquareBtn({
    required this.onTap,
    required this.bg,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 18.sp, color: iconColor),
      ),
    );
  }
}
