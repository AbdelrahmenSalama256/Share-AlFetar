import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/view/add_address_screen.dart';
import 'package:cozy/features/profile/view/cubit/address_cubit.dart';
import 'package:cozy/features/profile/view/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_button.dart';
import 'cubit/address_state.dart';

//! AddressesScreen
class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'addresses'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            showToast(context, message: state.error, state: ToastStates.error);
          } else if (state is AddressSuccess) {
            showToast(context,
                message: state.message, state: ToastStates.success);
          }
        },
        builder: (context, state) {
          final cubit = context.read<AddressCubit>();

          if (state is AddressLoading) {
            return const Center(child: CustomLoadingIndicator());
          } else if (state is AddressLoaded) {
            final addresses = state.addresses;
            return addresses.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildEmptyState(context, cubit),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(20.w),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      return AddressCard(
                        address: addresses[index],
                        onEdit: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddAddressScreen(address: addresses[index]),
                          ),
                        ).then((_) => cubit.fetchAddresses()),
                        onDelete: () =>
                            cubit.deleteAddress(addresses[index].id),
                        onSetDefault: () =>
                            cubit.setDefaultAddress(addresses[index].id),
                      );
                    },
                  );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildEmptyState(context, cubit),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cubit = context.read<AddressCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAddressScreen(),
            ),
          ).then((_) => cubit.fetchAddresses());
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AddressCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 80.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_addresses'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'add_address_message'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          AppButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddressScreen(),
                ),
              ).then((_) => cubit.fetchAddresses());
            },
            text: 'add_address'.tr(context),
          ),
        ],
      ),
    );
  }
}
