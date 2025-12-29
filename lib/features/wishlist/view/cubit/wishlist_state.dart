//! WishlistState
class WishlistState {}

final class WishlistInitial extends WishlistState {}

//! WishlistLoading
class WishlistLoading extends WishlistState {}

//! WishlistLoaded
class WishlistLoaded extends WishlistState {}

//! WishlistError
class WishlistError extends WishlistState {
  final String error;
  WishlistError(this.error);
}

//! WishlistItemRemovedLoading
class WishlistItemRemovedLoading extends WishlistState {}

//! WishlistItemRemovedSuccess
class WishlistItemRemovedSuccess extends WishlistState {
  final String message;
  WishlistItemRemovedSuccess(this.message);
}

//! WishlistItemRemovedError
class WishlistItemRemovedError extends WishlistState {
  final String error;
  WishlistItemRemovedError(this.error);
}
