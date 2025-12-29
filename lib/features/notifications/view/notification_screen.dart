import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/notifications/view/cubit/notifications_cubit.dart';
import 'package:cozy/features/notifications/view/widgets/notification_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:cozy/core/component/widgets/unified_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/cubit/global_cubit.dart';
import '../../auth/view/login_screen.dart';
import '../data/models/notification_model.dart';
import '../data/repo/notifications_repo.dart';
import 'cubit/notifications_state.dart';
import 'widgets/notifications_empty_state.dart';

//! NotificationsScreen
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final global = context.read<GlobalCubit>();

    if (!global.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline,
                      size: 100.sp, color: AppColors.textGrey),
                  SizedBox(height: 24.h),
                  Text(
                    'login_required'.tr(context),
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'login_required_message'.tr(context),
                    style:
                        TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: 'login'.tr(context),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    type: AppButtonType.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) =>
          NotificationsCubit(sl<NotificationsRepo>())..fetchNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: UnifiedAppBar.inner(title: 'notifications'.tr(context)),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return _buildLoadingState(context);
            }

            if (state is NotificationsError) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppButton(
                        onPressed: () => context
                            .read<NotificationsCubit>()
                            .fetchNotifications(),
                        text: 'retry'.tr(context),
                      ),
                    ],
                  ),
                ),
              );
            }

            final cubit = context.read<NotificationsCubit>();
            final notifications = cubit.notifications;

            if (notifications.isEmpty) {
              return const NotificationsEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationsCubit>().fetchNotifications();
              },
              color: AppColors.primary,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationItemWidget(
                    notification: notification,
                    onTap: () => _handleNotificationTap(context, notification),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomLoadingIndicator(
            type: LoadingType.furnitureRotation,
          ),
          SizedBox(height: 16.h),
          Text(
            'loading_notifications'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(
      BuildContext context, NotificationModel notification) {
    if (!notification.isRead) {
      context.read<NotificationsCubit>().markAsRead(notification.id);
    }

    switch (notification.type) {
      case NotificationType.order:
        if (notification.link != null) {
          PrintUtil.debug('Navigate to order: ${notification.data}');
        }
        break;
      case NotificationType.promotion:
        PrintUtil.debug('Navigate to promotion');
        break;
      case NotificationType.system:
        break;
      case NotificationType.follow:
        break;
      case NotificationType.like:
      case NotificationType.comment:
        break;
      case NotificationType.unknown:
        break;
    }
  }
}
