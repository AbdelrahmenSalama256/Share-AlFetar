import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../customer_services/view/complaint_screen.dart';
import '../../customer_services/view/general_inquiry_screen.dart';
import '../../customer_services/view/return_request_screen.dart';
import 'support_tickets_screen.dart';

//! CustomerServiceScreen
class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final global = context.read<GlobalCubit>();
    if (!global.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline,
                    size: 80.sp, color: AppColors.textGrey),
                SizedBox(height: 16.h),
                Text('login_required'.tr(context),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack)),
                SizedBox(height: 8.h),
                Text('login_required_message'.tr(context),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14.sp, color: AppColors.textGrey)),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppButton(
                      text: 'login'.tr(context),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      },
                    ),
                    SizedBox(width: 12.w),
                    AppButton(
                      text: 'start_shopping'.tr(context),
                      type: AppButtonType.text,
                      onPressed: () =>
                          context.read<GlobalCubit>().changeBottomNavIndex(0),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 24.h),
            _buildServiceCard(
              context,
              'my_tickets'.tr(context),
              'view_support_tickets'.tr(context),
              Icons.support_agent_outlined,
              AppColors.primary,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportTicketsScreen(),
                ),
              ),
            ),
            _buildServiceCard(
              context,
              'general_inquiry'.tr(context),
              'general_inquiry_desc'.tr(context),
              Icons.help_outline,
              AppColors.primary,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeneralInquiryScreen(),
                ),
              ),
            ),
            _buildServiceCard(
              context,
              'return_refund'.tr(context),
              'return_refund_desc'.tr(context),
              Icons.assignment_return,
              AppColors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReturnRequestScreen(),
                ),
              ),
            ),
            _buildServiceCard(
              context,
              'complaint_feedback'.tr(context),
              'complaint_feedback_desc'.tr(context),
              Icons.feedback_outlined,
              AppColors.error,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComplaintScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'customer_service'.tr(context),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
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
          'choose_service_below'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24.sp,
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
                      description,
                      style: TextStyle(
                        fontSize: 14.sp,
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
