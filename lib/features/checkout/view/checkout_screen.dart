import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/cart/data/model/cart_model.dart';
import 'package:cozy/features/checkout/data/repo/checkout_repo.dart';
import 'package:cozy/features/checkout/view/order_success_screen.dart';
import 'package:cozy/features/checkout/view/widgets/checkout_bottom_section.dart';
import 'package:cozy/features/checkout/view/widgets/order_notes.dart';
import 'package:cozy/features/checkout/view/widgets/order_summary.dart';
import 'package:cozy/features/checkout/view/widgets/section_container.dart';
import 'package:cozy/features/profile/data/models/address_model.dart';
import 'package:cozy/features/profile/view/cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_loading_indicator.dart';
import '../../../core/component/custom_toast.dart';
import '../../profile/view/cubit/address_state.dart';
import 'cubit/checkout_cubit.dart';
import 'cubit/checkout_state.dart';
import 'widgets/address_card.dart';

//! CheckoutScreen
class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

//! _CheckoutScreenState
class _CheckoutScreenState extends State<CheckoutScreen> {
  int? selectedAddressIndex;
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddressCubit(sl())..fetchAddresses(),
        ),
        BlocProvider(
          create: (context) => CheckoutCubit(sl<CheckoutRepo>()),
        ),
      ],
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSuccessScreen(
                  orderNumber: state.orderId,
                  total: widget.cart.total!,
                  orderId: state.orderId,
                ),
              ),
            );
          } else if (state is CheckoutError) {
            showToast(context, message: state.error, state: ToastStates.error);
          }
        },
        builder: (context, checkoutState) {
          return BlocBuilder<AddressCubit, AddressState>(
            builder: (context, addressState) {
              context.read<AddressCubit>();
              final isProcessing = checkoutState is CheckoutLoading;

              List<AddressModel> addresses = [];
              if (addressState is AddressLoaded) {
                addresses = addressState.addresses;
                selectedAddressIndex ??=
                    addresses.indexWhere((a) => a.isDefault);
                if (selectedAddressIndex! < 0 && addresses.isNotEmpty) {
                  selectedAddressIndex = 0;
                }
              }

              return Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  backgroundColor: AppColors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textBlack,
                      size: 20.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'checkout'.tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: addressState is AddressLoading
                    ? const Center(child: CustomLoadingIndicator())
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h),

                                  OrderSummarySection(cart: widget.cart),
                                  SizedBox(height: 20.h),

                                  SectionContainer(
                                    title: 'delivery_address'.tr(context),
                                    actionText: 'change'.tr(context),
                                    onActionPressed: addresses.isEmpty
                                        ? null
                                        : () => _showAddressSelection(
                                            context, addresses),
                                    child: addresses.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.all(16.w),
                                            child: Text(
                                              'no_addresses'.tr(context),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.textGrey,
                                              ),
                                            ),
                                          )
                                        : AddressCard(
                                            address: addresses[
                                                selectedAddressIndex!],
                                            isSelected: true,
                                          ),
                                  ),
                                  SizedBox(height: 20.h),

                                  OrderNotesSection(
                                      controller: notesController),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          CheckoutBottomSection(
                            total: widget.cart.total!,
                            isProcessing: isProcessing,
                            onPlaceOrder: () => _placeOrder(context, addresses),
                          ),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddressSelection(
      BuildContext context, List<AddressModel> addresses) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_address'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            ...addresses.asMap().entries.map((entry) {
              int index = entry.key;
              AddressModel address = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAddressIndex = index;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: AddressCard(
                    address: address,
                    isSelected: index == selectedAddressIndex,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context, List<AddressModel> addresses) {
    if (addresses.isEmpty) {
      showToast(context,
          message: 'please_add_address'.tr(context),
          state: ToastStates.warning);
      return;
    }
    final checkoutCubit = context.read<CheckoutCubit>();
    if (widget.cart.finalTotal.toString().isEmpty) {
      showToast(context,
          message: 'cart_total_is_empty'.tr(context), state: ToastStates.error);
      return;
    } else {
      checkoutCubit.placeOrder(
        addressId: addresses[selectedAddressIndex!].id,
        saleNote: notesController.text,
        finalTotal: widget.cart.finalTotal.toString(),
      );
    }
  }
}
