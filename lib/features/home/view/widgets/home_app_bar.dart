import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! HomeAppBar
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onNotificationTap;
  final String userName;
  final String userAvatarUrl;
  final bool hasUnreadNotifications;

  const HomeAppBar({
    super.key,
    required this.onSearchTap,
    required this.onNotificationTap,
    this.userName = "Jonathan",
    this.userAvatarUrl =
        "assets/images/icons/png/avatar.png", // Changed to asset path
    this.hasUnreadNotifications = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: AppColors.white,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage(userAvatarUrl),
              onBackgroundImageError: (exception, stackTrace) {

              },
              backgroundColor: AppColors.lightGrey,
            ),
            SizedBox(width: 12.w),
            Flexible(

              child: Text(
                '${'home_greeting_user'.tr(context)} $userName',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: AppColors.textBlack, size: 26.sp),
          onPressed: onSearchTap,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none_outlined,
                  color: AppColors.textBlack, size: 26.sp),
              onPressed: onNotificationTap,
            ),
            if (hasUnreadNotifications)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
