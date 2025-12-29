import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! RegisterSuccessScreen
class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(flex: 2),
              Container(
                padding: EdgeInsets.all(20.sp),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.successGreen,
                ),
                child: Icon(Icons.check, size: 60.sp, color: AppColors.white),
              ),
              SizedBox(height: 30.h),
              Text(
                "auth_register_success_title".tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24.sp,
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
              Spacer(flex: 3),
              AppButton(
                text: "auth_go_to_homepage_button".tr(context),
                onPressed: () {
                  if (kDebugMode) {
                    print("Navigate to Homepage");
                  }
                },
                backgroundColor: AppColors.primary,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
