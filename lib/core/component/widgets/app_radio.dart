import 'package:cozy/core/constants/app_colors.dart';

import 'package:flutter/material.dart';

//! AppRadio
class AppRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String text;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.text = '',
    this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Radio<T>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            if (text.isNotEmpty)
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            if (child != null) Expanded(child: child!),
          ],
        ),
      ),
    );
  }
}
