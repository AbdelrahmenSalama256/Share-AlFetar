import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/cart/data/repo/cart_repo.dart';
import 'package:cozy/features/cart/view/cubit/cart_cubit.dart';
import 'package:cozy/features/cart/view/cubit/cart_state.dart' as cart_state;
import 'package:cozy/features/checkout/view/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//! CheckoutLauncher
class CheckoutLauncher extends StatelessWidget {
  const CheckoutLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(sl<CartRepo>())..fetchCart(),
      child: BlocBuilder<CartCubit, cart_state.CartState>(
        builder: (context, state) {
          final cubit = context.read<CartCubit>();
          if (state is cart_state.GetCartLoading) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CustomLoadingIndicator()),
            );
          }
          if (cubit.cart == null) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CustomLoadingIndicator()),
            );
          }
          return CheckoutScreen(cart: cubit.cart!);
        },
      ),
    );
  }
}

