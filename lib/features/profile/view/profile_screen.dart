import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/error_message_handler.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/constants/language_switcher.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/cubit/global_state.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/auth/view/create_account_screen.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/customer_services/view/customer_service_screen.dart';
import 'package:cozy/features/profile/view/about_us_screen.dart';
import 'package:cozy/features/profile/view/addresses_screen.dart';
import 'package:cozy/features/profile/view/cubit/address_cubit.dart';
import 'package:cozy/features/profile/view/edit_profile_screen.dart';
import 'package:cozy/features/profile/view/my_orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_toast.dart';
import '../data/models/contact_model.dart';
import '../data/repo/address_repo.dart';

//! ProfileScreen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalCubit()..getProfile(),
      child: StreamBuilder<ContactResponse?>(
        stream: context.read<GlobalCubit>().profileStream,
        builder: (context, snapshot) {
          return BlocConsumer<GlobalCubit, GlobalState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                showToast(
                  context,
                  message: state.message.tr(context),
                  state: ToastStates.success,
                  style: ToastStyle.furniture,
                );
                navigateAndFinish(context, const LoginScreen());
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              }
              if (state is LogoutError) {
                Navigator.pop(context);
                ErrorMessageHandler.showErrorToast(
                  context,
                  state.message.tr(context),
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<GlobalCubit>();

              final userData = snapshot.data ?? cubit.contactResponse;

              return Scaffold(
                backgroundColor: AppColors.lightGrey,
                body: SafeArea(
                  child: state is ProfileLoading
                      ? const CustomLoadingIndicator()
                      : AppConstants.token.isNotEmpty
                          ? _buildLoggedInProfile(
                              context, cubit, state, userData)
                          : _buildGuestProfile(context),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoggedInProfile(BuildContext context, GlobalCubit cubit,
      GlobalState state, ContactResponse? userData) {
    final user = userData?.data.user;
    final global = context.read<GlobalCubit>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.primary,
                    child: user?.image == null
                        ? Text(
                            user?.name?.split(' ').map((e) => e[0]).join('') ??
                                'U',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(100.r),
                            child: Image.network(
                              user?.imageUrl ?? "",
                              width: 90.w,
                              height: 90.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                      height: 100.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(CupertinoIcons.person,
                                          size: 40.r, color: Colors.grey)),
                            ),
                          ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    user?.name ?? 'User',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.person_outline,
                  title: 'edit_profile'.tr(context),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen())),
                ),
                !global.isAuthenticated
                    ? SizedBox.shrink()
                    : _buildProfileOption(
                        icon: Icons.shopping_bag_outlined,
                        title: 'my_orders'.tr(context),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrdersScreen())),
                      ),
                _buildProfileOption(
                  icon: Icons.location_on_outlined,
                  title: 'addresses'.tr(context),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) =>
                                    AddressCubit(sl<AddressRepo>())
                                      ..fetchAddresses(),
                                child: const AddressesScreen(),
                              ))),
                ),
                // _buildProfileOption(
                //   icon: Icons.payment_outlined,
                //   title: 'payment_methods'.tr(context),
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const PaymentMethodsScreen())),
                // ),

                _buildProfileOption(
                  icon: Icons.support_agent_outlined,
                  title: 'customer_service'.tr(context),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerServiceScreen())),
                ),
                // _buildProfileOption(
                //   icon: Icons.notifications_outlined,
                //   title: 'notifications'.tr(context),
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const NotificationsScreen())),
                // ),
                _buildProfileOption(
                  icon: Icons.language_outlined,
                  title: 'language'.tr(context),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('select_language'.tr(context)),
                        content: const LanguageSwitcher(),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('close'.tr(context)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.info_outline,
                  title: 'about_us'.tr(context),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutUsScreen())),
                ),
                state is LogoutLoading
                    ? const CustomLoadingIndicator()
                    : _buildProfileOption(
                        icon: Icons.logout,
                        title: 'logout'.tr(context),
                        onTap: () {
                          _showLogoutDialog(context, cubit);
                        },
                        isDestructive: true,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 100.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 24.h),
          Text(
            'welcome_guest'.tr(context),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'login_to_access_features'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: AppButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              text: 'login'.tr(context),
            ),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen())),
            child: Text(
              'create_account'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      color: AppColors.white,
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? AppColors.error : AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        isDestructive ? AppColors.error : AppColors.textBlack,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textGrey,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, GlobalCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr(context)),
        content: Text('logout_confirmation'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(context)),
          ),
          TextButton(
            onPressed: () {
              cubit.logout();
            },
            child: Text(
              'logout'.tr(context),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
