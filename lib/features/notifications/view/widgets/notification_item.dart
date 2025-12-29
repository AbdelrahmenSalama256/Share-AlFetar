import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum NotificationType {
  follow,
  like,
  comment,
  order,
  promotion,
}

//! NotificationItem
class NotificationItem {
  final String id;
  final String userName;
  final String userAvatar;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;
  bool? isFollowing;
  String? postImage;

  NotificationItem({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
    this.isFollowing,
    this.postImage,
  });
}

//! NotificationItemWidget
class NotificationItemWidget extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: notification.isRead
            ? null
            : Border.all(
                color: AppColors.primary.withOpacity(0.2),
              ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserAvatar(),
              SizedBox(width: 12.w),
              _buildNotificationContent(),
              SizedBox(width: 8.w),
              _buildNotificationAction(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundImage: NetworkImage(notification.userAvatar),
          backgroundColor: AppColors.lightGrey,
        ),
        if (!notification.isRead)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: notification.userName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                TextSpan(
                  text: ' ${notification.message}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            notification.time,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationAction(BuildContext context) {
    switch (notification.type) {
      case NotificationType.follow:
        return _buildFollowButton(context);
      case NotificationType.like:
      case NotificationType.comment:
        return _buildPostThumbnail();
      case NotificationType.order:
      case NotificationType.promotion:
        return _buildActionIcon();
    }
  }

  Widget _buildFollowButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: notification.isFollowing ?? false
            ? Colors.grey[200]
            : AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        notification.isFollowing ?? false
            ? 'following'.tr(context)
            : 'follow'.tr(context),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: notification.isFollowing ?? false
              ? AppColors.textGrey
              : Colors.white,
        ),
      ),
    );
  }

  Widget _buildPostThumbnail() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: notification.postImage != null
            ? DecorationImage(
                image: NetworkImage(notification.postImage!),
                fit: BoxFit.cover,
              )
            : null,
        color: notification.postImage == null ? AppColors.lightGrey : null,
      ),
      child: notification.postImage == null
          ? Icon(
              Icons.image_outlined,
              color: AppColors.textGrey,
              size: 20.sp,
            )
          : null,
    );
  }

  Widget _buildActionIcon() {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: _getNotificationColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        _getNotificationIcon(),
        color: _getNotificationColor(),
        size: 16.sp,
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.follow:
        return Icons.person_add_outlined;
      case NotificationType.like:
        return Icons.favorite_outline;
      case NotificationType.comment:
        return Icons.chat_bubble_outline;
      case NotificationType.order:
        return Icons.shopping_bag_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.follow:
        return AppColors.primary;
      case NotificationType.like:
        return Colors.red;
      case NotificationType.comment:
        return Colors.blue;
      case NotificationType.order:
        return Colors.green;
      case NotificationType.promotion:
        return Colors.orange;
    }
  }
}
