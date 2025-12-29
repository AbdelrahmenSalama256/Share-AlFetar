//! CartState
class CartState {}

final class CartInitial extends CartState {}

//! CartUpdated
class CartUpdated extends CartState {}

//! GetCartLoading
class GetCartLoading extends CartState {}

//! GetCartLoaded
class GetCartLoaded extends CartState {}

//! GetCartError
class GetCartError extends CartState {
  final String error;
  GetCartError(this.error);
}

//! CartItemRemovedLoading
class CartItemRemovedLoading extends CartState {}

//! CartItemRemovedSuccess
class CartItemRemovedSuccess extends CartState {
  final String message;
  CartItemRemovedSuccess(this.message);
}

//! CartItemRemovedError
class CartItemRemovedError extends CartState {
  final String error;
  CartItemRemovedError(this.error);
}

//! CartItemQuantityUpdated
class CartItemQuantityUpdated extends CartState {
  final String message;
  CartItemQuantityUpdated(this.message);
}

//! CartItemQuantityUpdateError
class CartItemQuantityUpdateError extends CartState {
  final String error;
  CartItemQuantityUpdateError(this.error);
}

//! CartLoading
class CartLoading extends CartState {}

//! ClearCartLoading
class ClearCartLoading extends CartState {}

//! ClearCartSuccess
class ClearCartSuccess extends CartState {
  final String message;
  ClearCartSuccess(this.message);
}

//! ClearCartError
class ClearCartError extends CartState {
  final String error;
  ClearCartError(this.error);
}
