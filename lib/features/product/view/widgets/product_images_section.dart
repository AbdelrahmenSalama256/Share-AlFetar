import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/cubit/global_state.dart' as core_state;
import 'product_image_carousel.dart';

//! ProductImagesSection
class ProductImagesSection extends StatelessWidget {
  final List<String> imageUrls;
  final int productId;

  const ProductImagesSection(
      {super.key, required this.imageUrls, required this.productId});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400.h,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child:
              Icon(Icons.arrow_back, color: AppColors.textBlack, size: 20.sp),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        BlocBuilder<GlobalCubit, core_state.GlobalState>(
          builder: (context, state) {
            final homeCubit = context.read<HomeCubit>();
            final prod = homeCubit.productDetails.isNotEmpty
                ? homeCubit.productDetails.last
                : null;
            final isFav =
                (prod?.isFavourited == true) || (prod?.isFavorite == true);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? AppColors.error : AppColors.textGrey,
              ),
              onPressed: () {
                final globalCubit = context.read<GlobalCubit>();
                final homeCubit = context.read<HomeCubit>();
                if (!globalCubit.isAuthenticated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  return;
                }
                if (isFav) {
                  homeCubit.setProductDetailsFavourite(false);
                  globalCubit.removeProductFromWishlistByProductId(
                      productId.toString());
                  homeCubit.setProductFavouriteById(
                      productId.toString(), false);
                } else {
                  homeCubit.setProductDetailsFavourite(true);
                  globalCubit.addtowishlist(productId: productId.toString());
                  homeCubit.setProductFavouriteById(productId.toString(), true);
                }
              },
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: imageUrls.isNotEmpty
            ? ProductImageCarousel(imageUrls: imageUrls)
            : Container(
                color: AppColors.lightGrey,
                child: const Icon(Icons.image_not_supported),
              ),
      ),
    );
  }
}
