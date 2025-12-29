import 'package:image_picker/image_picker.dart';

abstract class ProfileState {
  const ProfileState();
}

//! ProfileInitial
class ProfileInitial extends ProfileState {}

//! ProfileImageUpdated
class ProfileImageUpdated extends ProfileState {
  final XFile? profileImage;

  const ProfileImageUpdated({this.profileImage});
}

//! ProfileImageCleared
class ProfileImageCleared extends ProfileState {}

//! ProfileImageError
class ProfileImageError extends ProfileState {
  final String message;

  const ProfileImageError(this.message);
}

//! ProfileDataUpdated
class ProfileDataUpdated extends ProfileState {
  final bool hasChanges;
  ProfileDataUpdated({required this.hasChanges});
}

//! ProfileUpdating
class ProfileUpdating extends ProfileState {}
