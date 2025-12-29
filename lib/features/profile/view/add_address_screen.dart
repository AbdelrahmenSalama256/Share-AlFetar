import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_dropdown_form_field.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:cozy/features/profile/view/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_toast.dart';
import '../data/repo/address_repo.dart';
import 'cubit/address_state.dart';

//! AddAddressScreen
class AddAddressScreen extends StatelessWidget {
  final AddressModel? address;

  const AddAddressScreen({super.key, this.address});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressCubit(sl<AddressRepo>())
        ..initializeForm(address: address)
        ..fetchCities(),
      child: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressSuccess) {
            Navigator.pop(context);
            showToast(context,
                message: state.message, state: ToastStates.success);
          } else if (state is AddressError) {
            showToast(context, message: state.error, state: ToastStates.error);
          } else if (state is AddressFormInvalid) {
            showToast(context,
                message: 'please_fill_required_fields'.tr(context),
                state: ToastStates.warning);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddressCubit>();
          final isEditing =
              state is AddressFormInitialized ? state.isEditing : false;
          final isDefault = state is AddressFormInitialized
              ? state.isDefault
              : state is AddressFormUpdated
                  ? state.isDefault
                  : false;
          final isLoading = state is AddressLoading;

          return Scaffold(
            backgroundColor: AppColors.lightGrey,
            appBar: _buildAppBar(context, isEditing),
            body: Form(
              key: cubit.formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    SizedBox(height: 16.h),
                    _buildTitleField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildNameField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildPhoneField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildStreetField(context, cubit),
                    SizedBox(height: 16.h),
                    _buildCityStateFields(context, cubit),
                    SizedBox(height: 16.h),
                    _buildZipCountryFields(context, cubit),
                    SizedBox(height: 24.h),
                    _buildDefaultAddressToggle(context, cubit, isDefault),
                    SizedBox(height: 32.h),
                    _buildSaveButton(context, cubit, isEditing, isLoading),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isEditing) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        isEditing ? 'edit_address'.tr(context) : 'add_address'.tr(context),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'address_details'.tr(context),
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textBlack,
      ),
    );
  }

  Widget _buildTitleField(BuildContext context, AddressCubit cubit) {
    return AppTextField(
      labelText: 'address_title'.tr(context),
      hintText: 'address_title_hint'.tr(context),
      controller: cubit.titleController,
    );
  }

  Widget _buildNameField(BuildContext context, AddressCubit cubit) {
    return AppTextField(
      labelText: 'name'.tr(context),
      hintText: 'name_hint'.tr(context),
      controller: cubit.nameController,
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) return 'name_required'.tr(context);
        if (v.length < 2) return 'name_length'.tr(context);
        return null;
      },
    );
  }

  Widget _buildPhoneField(BuildContext context, AddressCubit cubit) {
    return AppTextField(
      labelText: 'phone_number'.tr(context),
      hintText: 'phone_hint'.tr(context),
      controller: cubit.phoneController,
      keyboardType: TextInputType.phone,
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) return 'phone_required'.tr(context);
        final digits = v.replaceAll(RegExp(r'\D'), '');
        if (digits.length < 8) return 'invalid_phone'.tr(context);
        return null;
      },
    );
  }

  Widget _buildStreetField(BuildContext context, AddressCubit cubit) {
    return AppTextField(
      labelText: 'street_address'.tr(context),
      hintText: 'street_hint'.tr(context),
      controller: cubit.streetController,
      validator: (value) =>
          value!.isEmpty ? 'street_required'.tr(context) : null,
    );
  }

  Widget _buildCityStateFields(BuildContext context, AddressCubit cubit) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            // height: 56.h,
            child: AppDropdownFormField(
              hint: 'city'.tr(context),
              items: cubit.cities,
              initialValue: cubit.selectedCity,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'city_required'.tr(context)
                  : null,
              onSaved: (value) {
                cubit.selectedCity = value;
                cubit.cityController.text = value ?? '';
              },
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AppTextField(
            labelText: 'state'.tr(context),
            hintText: 'state_hint'.tr(context),
            controller: cubit.stateController,
          ),
        ),
      ],
    );
  }

  Widget _buildZipCountryFields(BuildContext context, AddressCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            labelText: 'zip_code'.tr(context),
            hintText: 'zip_hint'.tr(context),
            controller: cubit.zipController,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          flex: 2,
          child: AppTextField(
            labelText: 'country'.tr(context),
            hintText: 'country_hint'.tr(context),
            controller: cubit.countryController,
            validator: (value) =>
                value!.isEmpty ? 'country_required'.tr(context) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAddressToggle(
      BuildContext context, AddressCubit cubit, bool isDefault) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'set_as_default'.tr(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'use_as_default_address'.tr(context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isDefault,
            onChanged: (value) => cubit.toggleDefault(value),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, AddressCubit cubit,
      bool isEditing, bool isLoading) {
    return AppButton(
      onPressed: () => cubit.saveAddress(),
      text:
          isEditing ? 'update_address'.tr(context) : 'save_address'.tr(context),
      type: AppButtonType.primary,
      isLoading: isLoading,
      backgroundColor: AppColors.primary,
    );
  }
}
