
import 'package:image_picker/image_picker.dart';

//! RegisterState
class RegisterState {}

//! RegisterInitial
class RegisterInitial extends RegisterState {}

//! RegisterLoading
class RegisterLoading extends RegisterState {}

//! RegisterSuccess
class RegisterSuccess extends RegisterState {
  final String message;
  final String emailForVerification;

  RegisterSuccess({required this.message, required this.emailForVerification});
}

//! RegisterError
class RegisterError extends RegisterState {
  final String message;
  RegisterError({required this.message});
}

//! RegisterPasswordVisibilityChanged
class RegisterPasswordVisibilityChanged extends RegisterState {
  final bool isObscure;
  RegisterPasswordVisibilityChanged({required this.isObscure});
}

//! RegisterDataUpdated
class RegisterDataUpdated extends RegisterState {
  final XFile? profileImage;
  RegisterDataUpdated({this.profileImage});
}
