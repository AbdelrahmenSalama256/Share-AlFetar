import '../../data/models/address_model.dart';

//! AddressState
class AddressState {
  const AddressState();
}

//! AddressInitial
class AddressInitial extends AddressState {}

//! AddressLoading
class AddressLoading extends AddressState {}

//! AddressLoaded
class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;

  const AddressLoaded(this.addresses);
}

//! AddressSuccess
class AddressSuccess extends AddressState {
  final String message;

  const AddressSuccess(this.message);
}

//! AddressError
class AddressError extends AddressState {
  final String error;

  const AddressError(this.error);
}

//! AddressFormUpdated
class AddressFormUpdated extends AddressState {
  final bool isDefault;

  const AddressFormUpdated({required this.isDefault});
}

//! AddressFormInvalid
class AddressFormInvalid extends AddressState {}

//! AddressFormInitialized
class AddressFormInitialized extends AddressState {
  final bool isEditing;
  final bool isDefault;

  const AddressFormInitialized(
      {required this.isEditing, required this.isDefault});
}
