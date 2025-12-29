import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/error_message_handler.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/cubit/global_state.dart' as core_state;
import 'widgets/action_buttons.dart';
import 'widgets/product_details_content.dart';

//! ProductDetailsScreen
class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchProductDetails(productId),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is ProductDetailsError) {
            ErrorMessageHandler.showErrorToast(context, state.message);
          }
        },
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          if (state is ProductDetailsLoading || cubit.productDetails.isEmpty) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CustomLoadingIndicator()),
            );
          }

          if (state is ProductDetailsError) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: _buildErrorState(context, cubit),
            );
          }

          final product = cubit.productDetails.last;
          final hasVariations = product.variations?.isNotEmpty ?? false;

          return Scaffold(
            backgroundColor: Colors.white,
            body: ProductDetailsContent(
              product: product,
              productId: productId,
            ),
            bottomNavigationBar:
                BlocBuilder<GlobalCubit, core_state.GlobalState>(
              builder: (context, globalState) {
                return ActionButtons(
                  productId: productId,
                  hasVariations: hasVariations,
                  globalState: globalState,
                  product: product,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, HomeCubit cubit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(
            'error_loading_product'.tr(context),
            style: TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
          ),
          SizedBox(height: 16.h),
          AppButton(
            text: 'retry'.tr(context),
            onPressed: () {
              cubit.fetchProductDetails(productId);
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }
}
