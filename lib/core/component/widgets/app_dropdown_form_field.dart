import 'package:cozy/core/component/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! AppDropdownFormField
class AppDropdownFormField extends FormField<String> {
  AppDropdownFormField({
    super.key,
    required String hint,
    required List<String> items,
    super.onSaved,
    super.validator,
    super.initialValue,
    bool autovalidate = false,
  }) : super(
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppDropdownField(
                  hint: hint,
                  value: state.value,
                  items: items,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  onChanged: (value) {
                    state.didChange(value);
                  },
                  validator: validator,
                  showErrorBorder: state.hasError,
                ),
                if (state.hasError)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
