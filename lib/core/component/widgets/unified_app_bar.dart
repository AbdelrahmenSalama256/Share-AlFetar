import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class UnifiedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isMain; // true for main/root screens, false for inner screens
  final List<Widget>? actions;
  final bool centerTitle;

  const UnifiedAppBar.main({super.key, required this.title, this.actions, this.centerTitle = true})
      : isMain = true;

  const UnifiedAppBar.inner({super.key, required this.title, this.actions, this.centerTitle = true})
      : isMain = false;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: centerTitle,
      leading: isMain
          ? null
          : IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textBlack,
                size: 18.sp,
              ),
              onPressed: () => Navigator.pop(context),
            ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
      actions: actions,
    );
  }
}

