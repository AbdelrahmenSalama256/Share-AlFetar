import 'dart:io';

import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../custom_toast.dart';

//! ProfileImagePicker
class ProfileImagePicker extends StatelessWidget {
  final XFile? profileImage;
  final Function(XFile) onImageSelected;
  final double size;
  final Color backgroundColor;
  final Color editIconBackgroundColor;
  final Color editIconColor;

  const ProfileImagePicker({
    super.key,
    required this.profileImage,
    required this.onImageSelected,
    this.size = 100,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.editIconBackgroundColor = Colors.white,
    this.editIconColor = AppColors.primary,
  });

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (image != null) {
        onImageSelected(image);
      }
    } catch (e) {
      if (!context.mounted) return;
      showToast(
        context,
        message: 'error_picking_image'.tr(context),
        state: ToastStates.error,
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_image_source'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: Icon(CupertinoIcons.photo_camera_solid,
                  color: Theme.of(context).primaryColor),
              title: Text('camera'.tr(context)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, context);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.photo_on_rectangle,
                  color: Theme.of(context).primaryColor),
              title: Text('gallery'.tr(context)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Stack(
        children: [
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(size / 2),
                    child: Image.file(
                      File(profileImage!.path),
                      width: size.w,
                      height: size.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: (size * 0.4).w,
                          height: (size * 0.4).w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: (size * 0.5).w,
                          height: (size * 0.2).h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(size * 0.1)),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: (size * 0.24).w,
              height: (size * 0.24).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: editIconBackgroundColor,
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1.w,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: (size * 0.14).w,
                color: editIconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
