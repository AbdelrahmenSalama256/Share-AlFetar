import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';
import 'package:cozy/features/breakfast_menu/view/cubit/breakfast_menu_cubit.dart';
import 'package:cozy/features/breakfast_menu/view/widgets/image_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../cubit/breakfast_menu_state.dart';

void openAddEditSheetModal(BuildContext context,
    {BreakfastItemModel? existingItem}) {
  final nameController = TextEditingController(text: existingItem?.name ?? '');
  final descController =
      TextEditingController(text: existingItem?.description ?? '');
  final priceController = TextEditingController(
      text: existingItem != null ? existingItem.price.toStringAsFixed(2) : '');
  final deliveryController = TextEditingController(
      text: existingItem != null
          ? existingItem.deliveryFee.toStringAsFixed(2)
          : '');
  final classificationController =
      TextEditingController(text: existingItem?.classification ?? 'product');
  final imageController =
      TextEditingController(text: existingItem?.image ?? '');
  BreakfastType selectedType = existingItem?.type ?? BreakfastType.sandwich;
  bool isHot = existingItem?.isHot ?? false;
  String? localImagePath = existingItem?.image;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return GestureDetector(
        onTap: () => Navigator.pop(sheetContext),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: BlocBuilder<BreakfastMenuCubit, BreakfastMenuState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                              width: 40.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  Text(
                                    existingItem == null
                                        ? 'sheet_title_add'.tr(context)
                                        : 'sheet_title_edit'
                                            .tr(context)
                                            .replaceAll(
                                                '{name}', existingItem.name),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.pop(sheetContext),
                                    icon: Icon(
                                      Iconsax.close_circle,
                                      size: 24.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: controller,
                                padding: EdgeInsets.all(16.w),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildTextField(
                                          controller: nameController,
                                          label: 'item_name_label'.tr(context),
                                          hint: 'item_name_hint'.tr(context),
                                          icon: Iconsax.tag,
                                          required: true,
                                        ),
                                        SizedBox(height: 16.h),
                                        _buildTextField(
                                          controller: descController,
                                          label: 'item_desc_label'.tr(context),
                                          hint: 'item_desc_hint'.tr(context),
                                          icon: Iconsax.note,
                                          maxLines: 3,
                                        ),
                                        SizedBox(height: 16.h),
                                        _buildTextField(
                                          controller: priceController,
                                          label: 'item_price_label'.tr(context),
                                          hint: '0.00',
                                          icon: Iconsax.money,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  decimal: true),
                                        ),
                                        SizedBox(height: 16.h),
                                        _buildTextField(
                                          controller: deliveryController,
                                          label:
                                              'delivery_fee'.tr(context),
                                          hint: '0',
                                          icon: Iconsax.truck_fast,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                  decimal: true),
                                        ),
                                        SizedBox(height: 16.h),
                                        _buildTextField(
                                          controller: classificationController,
                                          label: 'classification'.tr(context),
                                          hint: 'product / classified',
                                          icon: Iconsax.archive,
                                        ),
                                        SizedBox(height: 16.h),
                                        _buildTypeSelector(
                                            sheetContext, selectedType, (type) {
                                          setState(() {
                                            selectedType = type;
                                          });
                                        }),
                                        SizedBox(height: 16.h),
                                        _buildHotToggle(sheetContext, isHot,
                                            (value) {
                                          setState(() {
                                            isHot = value;
                                          });
                                        }),
                                        SizedBox(height: 16.h),
                                        ImageSelectorField(
                                          currentPath: localImagePath,
                                          onPathPicked: (path) {
                                            setState(() {
                                              localImagePath = path;
                                              imageController.text = path ?? '';
                                            });
                                          },
                                        ),
                                        SizedBox(height: 24.h),
                                        _buildActionButtons(
                                          context,
                                          nameController,
                                          descController,
                                          priceController,
                                          deliveryController,
                                          classificationController,
                                          imageController,
                                          selectedType,
                                          isHot,
                                          existingItem,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  bool required = false,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 18.sp, color: AppColors.textSecondary),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          if (required)
            Text(
              ' *',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
        ],
      ),
      SizedBox(height: 8.h),
      TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          filled: true,
          fillColor: AppColors.backgroundColor,
        ),
      ),
    ],
  );
}

Widget _buildTypeSelector(BuildContext context, BreakfastType currentType,
    Function(BreakfastType) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Iconsax.category, size: 18.sp, color: AppColors.textSecondary),
          SizedBox(width: 8.w),
          Text(
            'type_label'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
        ],
      ),
      SizedBox(height: 8.h),
      Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: BreakfastType.values.map((type) {
          final isSelected = currentType == type;
          return ChoiceChip(
            checkmarkColor: Colors.white,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _iconForType(type),
                  size: 16.sp,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
                SizedBox(width: 4.w),
                Text(type.label.tr(context)),
              ],
            ),
            selected: isSelected,
            onSelected: (_) => onChanged(type),
            selectedColor: AppColors.primary,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildHotToggle(
    BuildContext context, bool currentValue, Function(bool) onChanged) {
  return Row(
    children: [
      Switch.adaptive(
        value: currentValue,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      SizedBox(width: 8.w),
      Icon(Iconsax.flash, size: 18.sp, color: AppColors.textSecondary),
      SizedBox(width: 8.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'hot_label'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          Text(
            'hot_description'.tr(context),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildActionButtons(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController descController,
  TextEditingController priceController,
  TextEditingController deliveryController,
  TextEditingController classificationController,
  TextEditingController imageController,
  BreakfastType selectedType,
  bool isHot,
  BreakfastItemModel? existingItem,
) {
  return Row(
    children: [
      Expanded(
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 14.h),
          ),
          child: Text(
            'cancel'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isEmpty) {
              _showValidationError(context, 'item_name_required'.tr(context));
              return;
            }
            if (name.length < 2) {
              _showValidationError(context, 'item_name_too_short'.tr(context));
              return;
            }

            final parsedPrice =
                double.tryParse(priceController.text.trim().isEmpty
                        ? '0'
                        : priceController.text.trim()) ??
                    0.0;
            final parsedDelivery =
                double.tryParse(deliveryController.text.trim().isEmpty
                        ? '0'
                        : deliveryController.text.trim()) ??
                    0.0;
            final classification = classificationController.text.trim().isEmpty
                ? 'product'
                : classificationController.text.trim();

            final item = BreakfastItemModel(
              id: existingItem?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              description: descController.text.trim(),
              type: selectedType,
              image: imageController.text.trim().isEmpty
                  ? null
                  : imageController.text.trim(),
              isHot: isHot,
              createdAt: existingItem?.createdAt ?? DateTime.now(),
              price: parsedPrice < 0 ? 0 : parsedPrice,
              deliveryFee: parsedDelivery < 0 ? 0 : parsedDelivery,
              classification: classification.isEmpty ? 'product' : classification,
            );

            if (existingItem == null) {
              context.read<BreakfastMenuCubit>().addItem(item);
            } else {
              context.read<BreakfastMenuCubit>().updateItem(item);
            }

            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 14.h),
          ),
          child: Text(
            existingItem == null
                ? 'add_item'.tr(context)
                : 'save_changes'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}

void _showValidationError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
  );
}

IconData _iconForType(BreakfastType type) {
  switch (type) {
    case BreakfastType.drink:
      return Icons.local_cafe;
    case BreakfastType.snack:
      return Icons.bakery_dining;
    case BreakfastType.sandwich:
      return Icons.lunch_dining;
  }
}
