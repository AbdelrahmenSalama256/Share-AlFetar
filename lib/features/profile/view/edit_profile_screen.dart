import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/component/widgets/error_message_handler.dart';
import 'package:cozy/core/component/widgets/profile_image_picker.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/cubit/global_state.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/contact_model.dart';
import 'package:cozy/features/profile/view/cubit/profile_cubit.dart';
import 'package:cozy/features/profile/view/cubit/profile_state.dart';
import 'package:cozy/features/profile/view/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! EditProfileScreen
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: BlocProvider.of<GlobalCubit>(context)),
        BlocProvider(
            create: (context) => ProfileCubit(context.read<GlobalCubit>())),
      ],
      child: BlocListener<GlobalCubit, GlobalState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            showToast(
              context,
              message: 'profile_updated_success'.tr(context),
              state: ToastStates.success,
              style: ToastStyle.furniture,
            );
            Navigator.pop(context); // Return to profile screen after update
          } else if (state is ProfileError) {
            ErrorMessageHandler.showErrorToast(
                context, state.message.tr(context));
          }
        },
        child: BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, globalState) {
            final globalCubit = context.read<GlobalCubit>();
            final profileCubit = context.read<ProfileCubit>();
            final user = globalCubit.contactResponse?.data.user ??
                UserDetails(
                  id: 0,
                  type: '',
                  contactId: '',
                  contactStatus: 'active',
                );

            return BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                return Scaffold(
                  backgroundColor: AppColors.lightGrey,
                  appBar: _buildAppBar(context),
                  body: Form(
                    key: profileCubit.formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          globalState is ProfileLoading
                              ? const Center(child: CustomLoadingIndicator())
                              : Center(
                                  child: profileCubit.profileImage != null
                                      ? ProfileImagePicker(
                                          profileImage:
                                              profileCubit.profileImage,
                                          onImageSelected:
                                              profileCubit.setProfileImage,
                                        )
                                      : user.image == null
                                          ? ProfileImagePicker(
                                              profileImage:
                                                  profileCubit.profileImage,
                                              onImageSelected:
                                                  profileCubit.setProfileImage,
                                            )
                                          : ProfileSection(
                                              userName: user.name ?? '',
                                              userImageUrl: user.imageUrl ?? "",
                                              textStyle: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.w500),
                                              subtitle: '',
                                              isVendor: true,
                                              onTap: () async {
                                                // allow replacing image even if current URL fails to load
                                                final picked =
                                                    await profileCubit
                                                        .pickImage();
                                                if (picked != null) {
                                                  profileCubit
                                                      .setProfileImage(picked);
                                                }
                                              },
                                            ),
                                ),
                          SizedBox(height: 32.h),
                          _buildPersonalInfoSection(
                              context, profileCubit, user),
                          if (profileCubit.hasChanges) ...[
                            SizedBox(height: 32.h),
                            _buildSaveButton(context,
                                globalState is ProfileLoading, profileCubit),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'edit_profile'.tr(context),
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(
      BuildContext context, ProfileCubit cubit, UserDetails user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'personal_information'.tr(context),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: cubit.nameController,
          labelText: 'name'.tr(context),
          hintText: 'enter_name'.tr(context),
          onChanged: (_) => cubit.checkForChanges(),
          validator: (value) =>
              value!.isEmpty ? 'name_required'.tr(context) : null,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: cubit.emailController,
          labelText: 'email'.tr(context),
          hintText: 'enter_email'.tr(context),
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => cubit.checkForChanges(),
          validator: (value) {
            if (value!.isEmpty) return 'email_required'.tr(context);
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'invalid_email'.tr(context);
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: cubit.mobileController,
          labelText: 'phone_number'.tr(context),
          hintText: 'enter_phone'.tr(context),
          keyboardType: TextInputType.phone,
          onChanged: (_) => cubit.checkForChanges(),
        ),
        SizedBox(height: 16.h),
        _buildReadOnlyField(context, 'contact_id'.tr(context), user.contactId),
        SizedBox(height: 16.h),
        _buildReadOnlyField(
            context, 'contact_status'.tr(context), user.contactStatus),
        SizedBox(height: 16.h),
        _buildReadOnlyField(
            context, 'created_at'.tr(context), user.createdAt ?? ''),
        SizedBox(height: 16.h),
        _buildReadOnlyField(
            context, 'updated_at'.tr(context), user.updatedAt ?? ''),
      ],
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String label, String value) {
    final isDateField =
        label == 'created_at'.tr(context) || label == 'updated_at'.tr(context);
    final displayValue = isDateField ? _formatDate(value) : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            displayValue,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(
      BuildContext context, bool isLoading, ProfileCubit cubit) {
    return AppButton(
      text: 'save_changes'.tr(context),
      onPressed: cubit.saveChanges,
      type: AppButtonType.primary,
      height: 50.h,
      borderRadius: BorderRadius.circular(4.r),
      isLoading: isLoading,
    );
  }
}

String _formatDate(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  } catch (e) {
    return dateString; // Return original if parsing fails
  }
}
