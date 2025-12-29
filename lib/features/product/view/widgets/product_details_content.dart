import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/error_message_handler.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/cubit/global_state.dart' as core_state;
import '../../data/model/product_details_model.dart';
import 'product_images_section.dart';
import 'product_info_section.dart';

//! ProductDetailsContent
class ProductDetailsContent extends StatelessWidget {
  final ProductDetailsModel product;
  final int productId;

  const ProductDetailsContent(
      {super.key, required this.product, required this.productId});

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>();
    final hasVariations = product.variations?.isNotEmpty ?? false;
    final imageUrls = product.imageUrls ?? [product.imageUrl ?? ''];

    return BlocConsumer<GlobalCubit, core_state.GlobalState>(
      listener: (context, globalState) {
        if (globalState is core_state.WishlistError) {
          ErrorMessageHandler.showErrorToast(context, globalState.message);
        } else if (globalState is core_state.WishlistSuccess) {
          showToast(
            context,
            message: globalState.message.tr(context),
            state: ToastStates.success,
            duration: const Duration(seconds: 3),
          );
        }
        if (globalState is core_state.CartError) {
          ErrorMessageHandler.showErrorToast(context, globalState.error);
        } else if (globalState is core_state.CartLoaded) {
          showToast(
            context,
            message: 'product_added_successfully'.tr(context),
            state: ToastStates.success,
            duration: const Duration(seconds: 3),
          );
        }
      },
      builder: (context, globalState) {
        return CustomScrollView(
          slivers: [
            ProductImagesSection(imageUrls: imageUrls, productId: productId),
            ProductInfoSection(
              product: product,
              productId: productId,
              hasVariations: hasVariations,
              globalState: globalState,
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 84.h)),
          ],
        );
      },
    );
  }
}
