import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! RegisterSuccessBottomSheet
class RegisterSuccessBottomSheet extends StatelessWidget {
  const RegisterSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Container(
      padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 12.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 30.h),
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.successGreen,
            ),
            child: Icon(Icons.check, size: 40.sp, color: AppColors.white),
          ),
          SizedBox(height: 24.h),
          Text(
            "auth_register_success_title".tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack),
          ),
          SizedBox(height: 12.h),
          Text(
            "auth_register_success_message".tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp, color: AppColors.textGrey, height: 1.5.h),
          ),
          SizedBox(height: 30.h),
          AppButton(
            text: "auth_go_to_homepage_button".tr(context),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                          value: authCubit,
                          child: const LoginScreen(),
                        )),
              );
            },
            backgroundColor: AppColors.primary,
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
