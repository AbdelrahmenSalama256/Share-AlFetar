import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! HelpSupportScreen
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'help_support'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'how_can_we_help'.tr(context),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'find_answers_support'.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textGrey,
              ),
            ),
            SizedBox(height: 24.h),
            _buildHelpOption(
              context,
              icon: Icons.quiz_outlined,
              title: 'frequently_asked_questions'.tr(context),
              subtitle: 'find_quick_answers'.tr(context),
              onTap: () {},
            ),
            _buildHelpOption(
              context,
              icon: Icons.chat_outlined,
              title: 'live_chat'.tr(context),
              subtitle: 'chat_with_support'.tr(context),
              onTap: () {},
            ),
            _buildHelpOption(
              context,
              icon: Icons.phone_outlined,
              title: 'call_us'.tr(context),
              subtitle: 'speak_with_agent'.tr(context),
              onTap: () {},
            ),
            _buildHelpOption(
              context,
              icon: Icons.email_outlined,
              title: 'email_support'.tr(context),
              subtitle: 'send_us_email'.tr(context),
              onTap: () {},
            ),
            _buildHelpOption(
              context,
              icon: Icons.local_shipping_outlined,
              title: 'shipping_delivery'.tr(context),
              subtitle: 'shipping_information'.tr(context),
              onTap: () {},
            ),
            _buildHelpOption(
              context,
              icon: Icons.assignment_return_outlined,
              title: 'returns_exchanges'.tr(context),
              subtitle: 'return_policy_info'.tr(context),
              onTap: () {},
            ),
            _buildHelpOption(
              context,
              icon: Icons.payment_outlined,
              title: 'payment_billing'.tr(context),
              subtitle: 'payment_related_help'.tr(context),
              onTap: () {},
            ),
            _buildHelpOption(
              context,
              icon: Icons.security_outlined,
              title: 'account_security'.tr(context),
              subtitle: 'account_safety_tips'.tr(context),
              onTap: () {},
            ),
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.headset_mic_outlined,
                    size: 40.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'need_immediate_help'.tr(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'contact_support_team'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    onPressed: () {},
                    text: 'contact_now'.tr(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textGrey,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
