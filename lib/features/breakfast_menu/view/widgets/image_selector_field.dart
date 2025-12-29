import 'dart:io';

import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectorField extends StatelessWidget {
  const ImageSelectorField({
    super.key,
    required this.currentPath,
    required this.onPathPicked,
  });

  final String? currentPath;
  final ValueChanged<String?> onPathPicked;

  @override
  Widget build(BuildContext context) {
    final hasImage = currentPath != null && currentPath!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'image_add_title'.tr(context),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _openPicker(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Iconsax.gallery, color: AppColors.primary, size: 18.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasImage
                            ? 'image_add_path'
                                .tr(context)
                                .replaceFirst('{path}', currentPath!)
                            : 'image_add_hint'.tr(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: hasImage
                              ? AppColors.textBlack
                              : AppColors.textSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                      if (hasImage)
                        Text(
                          'image_add_change'.tr(context),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Iconsax.arrow_down_1,
                    color: AppColors.textSecondary, size: 16.sp),
              ],
            ),
          ),
        ),
        if (hasImage) ...[
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              height: 140.h,
              width: double.infinity,
              child: Image.file(
                File(currentPath!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          padding: EdgeInsets.all(16.w),
          child: _ImagePickerRow(
            currentPath: currentPath,
            onPick: onPathPicked,
          ),
        ),
      ),
    );
  }
}

class _ImagePickerRow extends StatelessWidget {
  const _ImagePickerRow({
    required this.currentPath,
    required this.onPick,
  });

  final String? currentPath;
  final ValueChanged<String?> onPick;

  @override
  Widget build(BuildContext context) {
    final hasImage = currentPath != null && currentPath!.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ImagePickButton(
                label: 'image_pick_gallery'.tr(context),
                icon: Iconsax.image,
                onPick: () async {
                  final picker = ImagePicker();
                  final picked =
                      await picker.pickImage(source: ImageSource.gallery);
                  onPick(picked?.path);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10.h),
              _ImagePickButton(
                label: 'image_pick_camera'.tr(context),
                icon: Iconsax.camera,
                onPick: () async {
                  final picker = ImagePicker();
                  final picked =
                      await picker.pickImage(source: ImageSource.camera);
                  onPick(picked?.path);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        if (hasImage) ...[
          SizedBox(height: 12.h),
          Text(
            'image_add_path'.tr(context).replaceFirst('{path}', currentPath!),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ],
    );
  }
}

class _ImagePickButton extends StatelessWidget {
  const _ImagePickButton({
    required this.label,
    required this.icon,
    required this.onPick,
  });

  final String label;
  final IconData icon;
  final Future<void> Function() onPick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPick,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      ),
      icon: Icon(
        icon,
        size: 16.sp,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}
