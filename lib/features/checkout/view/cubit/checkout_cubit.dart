import 'package:bloc/bloc.dart';
import 'package:cozy/core/common/logs.dart';
import 'package:cozy/features/checkout/data/repo/checkout_repo.dart';

import 'checkout_state.dart';

//! CheckoutCubit
class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepo checkoutRepo;

  CheckoutCubit(this.checkoutRepo) : super(CheckoutInitial());

  Future<void> placeOrder({
    required String addressId,
    required String saleNote,
    required String finalTotal,
  }) async {
    emit(CheckoutLoading());
    final result = await checkoutRepo.placeOrder(
      addressId: addressId,
      saleNote: saleNote,
      finalTotal: finalTotal,
    );
    result.fold(
      (error) {
        Print.error(error);
        emit(CheckoutError(error));
      },
      (orderId) {
        emit(CheckoutSuccess(orderId));
      },
    );
  }
}
