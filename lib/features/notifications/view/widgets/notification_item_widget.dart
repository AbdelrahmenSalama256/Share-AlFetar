import 'package:cozy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/notification_model.dart';

//! NotificationItemWidget
class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead
          ? Colors.transparent
          : AppColors.primary.withOpacity(0.05),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        leading: _buildNotificationIcon(),
        title: Text(
          notification.title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification.text,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textGrey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              notification.timeAgo,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.order:
        icon = Icons.shopping_bag;
        color = AppColors.primary;
        break;
      case NotificationType.promotion:
        icon = Icons.local_offer;
        color = Colors.orange;
        break;
      case NotificationType.system:
        icon = Icons.info;
        color = Colors.blue;
        break;
      case NotificationType.follow:
        icon = Icons.person_add;
        color = Colors.green;
        break;
      case NotificationType.like:
        icon = Icons.favorite;
        color = Colors.red;
        break;
      case NotificationType.comment:
        icon = Icons.comment;
        color = Colors.purple;
        break;
      case NotificationType.unknown:
        icon = Icons.notifications;
        color = AppColors.textGrey;
        break;
    }

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20.sp,
        color: color,
      ),
    );
  }
}
