import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/mode/data/repo/mode_repo.dart';
import 'package:cozy/features/mode/view/cubit/mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class BreakfastHeader extends StatelessWidget {
  const BreakfastHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final modeState = context.watch<ModeCubit>().state;
    final isHost = modeState.mode == UserMode.host;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.9),
            AppColors.secondary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Iconsax.coffee,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'header_title'.tr(context),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isHost
                          ? 'header_desc_host'.tr(context)
                          : 'header_desc_requester'.tr(context),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13.sp,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.read<GlobalCubit>().changeLanguage(),
                icon: Icon(Icons.language, color: Colors.white, size: 22.sp),
                tooltip: 'change_language_button'.tr(context),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    _Tag(
                      label: isHost
                          ? 'header_mode_host'.tr(context)
                          : 'header_mode_requester'.tr(context),
                      icon: isHost ? Iconsax.user : Iconsax.home,
                      color: Colors.white.withOpacity(0.85),
                    ),
                    SizedBox(width: 8.w),
                    _Tag(
                      label: 'header_fast'.tr(context),
                      icon: Iconsax.flash,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context
                    .read<ModeCubit>()
                    .setMode(isHost ? UserMode.requester : UserMode.host),
                icon: Icon(
                  isHost ? Iconsax.home : Iconsax.user,
                  color: Colors.white,
                  size: 22.sp,
                ),
                tooltip: 'toggle_mode'.tr(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
