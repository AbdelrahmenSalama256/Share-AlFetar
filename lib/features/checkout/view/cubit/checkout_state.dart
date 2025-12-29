abstract class CheckoutState {
  const CheckoutState();
}

//! CheckoutInitial
class CheckoutInitial extends CheckoutState {}

//! CheckoutLoading
class CheckoutLoading extends CheckoutState {}

//! CheckoutSuccess
class CheckoutSuccess extends CheckoutState {
  final String orderId;

  const CheckoutSuccess(this.orderId);
}

//! CheckoutError
class CheckoutError extends CheckoutState {
  final String error;

  const CheckoutError(this.error);
}
