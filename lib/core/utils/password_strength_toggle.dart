
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! PasswordFieldWithToggle
class PasswordFieldWithToggle extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function(String?) onChanged;
  final bool isPasswordObscure;
  final bool isEnabled;

  final VoidCallback togglePasswordVisibility;

  const PasswordFieldWithToggle({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.isEnabled,
    required this.onChanged,
    required this.isPasswordObscure,
    required this.togglePasswordVisibility,
  });

  @override
  State<PasswordFieldWithToggle> createState() =>
      _PasswordFieldWithToggleState();
}

//! _PasswordFieldWithToggleState
class _PasswordFieldWithToggleState extends State<PasswordFieldWithToggle> {
  bool isStrongPassword = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: widget.controller,
          labelText: widget.labelText.tr(context),
          hintText: widget.hintText.tr(context),
          prefixIcon: Icon(Icons.lock_outline,
              color: AppColors.textGrey.withOpacity(0.7)),
          obscureText: widget.isPasswordObscure,
          suffixIcon: IconButton(
            icon: Icon(
              widget.isPasswordObscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.primary,
            ),
            onPressed: widget.togglePasswordVisibility,
          ),
          validator: (value) => Validators.validatePassword(
            value,
            context,
            isStrong: isStrongPassword, // Use named parameter
          ),
          onChanged: widget.onChanged,
          enabled: widget.isEnabled,
        ),
        SizedBox(height: 8.h),
        PasswordStrengthToggle(
          value: isStrongPassword,
          onChanged: (value) {
            setState(() {
              isStrongPassword = value;
            });





          },
          label: "require_strong_password".tr(context),
        ),
      ],
    );
  }
}

//! PasswordStrengthToggle
class PasswordStrengthToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const PasswordStrengthToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
