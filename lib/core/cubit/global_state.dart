//! GlobalState
class GlobalState {}

final class GlobalInitial extends GlobalState {}

final class BottomNavChangeState extends GlobalState {}

//! LoadingState
class LoadingState extends GlobalState {}

//! ErrorState
class ErrorState extends GlobalState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

//! LanguageChangeState
class LanguageChangeState extends GlobalState {}

//! UserTypeLoadedState
class UserTypeLoadedState extends GlobalState {}

//! UserTypeChangedState
class UserTypeChangedState extends GlobalState {}

//! ProfileLoading
class ProfileLoading extends GlobalState {}

//! ProfileLoaded
class ProfileLoaded extends GlobalState {}

//! ProfileError
class ProfileError extends GlobalState {
  final String message;

  ProfileError({required this.message});
}

//! LogoutLoading
class LogoutLoading extends GlobalState {}

//! LogoutSuccess
class LogoutSuccess extends GlobalState {
  final String message;

  LogoutSuccess(this.message);
}

//! LogoutError
class LogoutError extends GlobalState {
  final String message;

  LogoutError(this.message);
}

//! ProfileDataUpdated
class ProfileDataUpdated extends GlobalState {}

//! ProfileUpdated
class ProfileUpdated extends GlobalState {}

//! WishlistLoading
class WishlistLoading extends GlobalState {}

//! WishlistSuccess
class WishlistSuccess extends GlobalState {
  final String message;
  WishlistSuccess(this.message);
}

//! WishlistError
class WishlistError extends GlobalState {
  final String message;

  WishlistError(this.message);
}

//! GetAddressLoading
class GetAddressLoading extends GlobalState {}

//! GetAddressSuccess
class GetAddressSuccess extends GlobalState {}

//! GetAddressError
class GetAddressError extends GlobalState {
  final String message;

  GetAddressError(this.message);
}

//! AddressLoading
class AddressLoading extends GlobalState {}

//! AddressSuccess
class AddressSuccess extends GlobalState {}

//! AddressError
class AddressError extends GlobalState {
  final String message;
  AddressError(this.message);
}

//! LanguageChangingState
class LanguageChangingState extends GlobalState {}

//! LanguageChangedState
class LanguageChangedState extends GlobalState {}

//! GlobalTokenUpdated
class GlobalTokenUpdated extends GlobalState {}

//! CurrencyChangedState
class CurrencyChangedState extends GlobalState {
  final String code;
  final String symbol;
  CurrencyChangedState(this.code, this.symbol);
}

//! CartLoading
class CartLoading extends GlobalState {}

//! CartLoaded
class CartLoaded extends GlobalState {}

//! CartError
class CartError extends GlobalState {
  final String error;

  CartError(this.error);
}

//! RemoveWishlistLoading
class RemoveWishlistLoading extends GlobalState {}

//! WishlistItemRemovedError
class WishlistItemRemovedError extends GlobalState {
  final String error;

  WishlistItemRemovedError(this.error);
}

//! WishlistItemRemovedSuccess
class WishlistItemRemovedSuccess extends GlobalState {
  final String message;

  WishlistItemRemovedSuccess(this.message);
}

//! WishlistStatusChanged
class WishlistStatusChanged extends GlobalState {
  final String productId;
  final bool isFavourite;

  WishlistStatusChanged({required this.productId, required this.isFavourite});
}

//! ProfileUpdating
class ProfileUpdating extends GlobalState {}
