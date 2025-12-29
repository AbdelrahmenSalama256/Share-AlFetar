import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/features/profile/view/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../../core/common/logs.dart';
import '../../data/models/contact_model.dart';

//! ProfileCubit
class ProfileCubit extends Cubit<ProfileState> {
  final GlobalCubit globalCubit;
  StreamSubscription? _profileSubscription;

  ProfileCubit(this.globalCubit) : super(ProfileInitial()) {
    _initControllers();
    _setupProfileUpdatesListener();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  XFile? profileImage;
  bool hasChanges = false;

  Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );
    return image;
  }

  void _setupProfileUpdatesListener() {
    _profileSubscription = globalCubit.profileStream.listen((contactResponse) {
      if (contactResponse != null) {
        _updateControllers(contactResponse.data.user);
        checkForChanges();
      }
    });
  }

  void _initControllers() {
    final user = globalCubit.contactResponse?.data.user ??
        UserDetails(
          id: 0,
          type: '',
          contactId: '',
          contactStatus: 'active',
        );

    _updateControllers(user);

    nameController.addListener(checkForChanges);
    emailController.addListener(checkForChanges);
    mobileController.addListener(checkForChanges);
  }

  void _updateControllers(UserDetails user) {

    final newName = user.name ??
        (user.firstName != null && user.lastName != null
            ? '${user.firstName} ${user.lastName}'
            : '');

    final newEmail = user.email ?? '';
    final newMobile = user.mobile ?? '';

    if (nameController.text != newName) {
      nameController.text = newName;
    }

    if (emailController.text != newEmail) {
      emailController.text = newEmail;
    }

    if (mobileController.text != newMobile) {
      mobileController.text = newMobile;
    }
  }

  void setProfileImage(XFile image) {
    final extension = path.extension(image.path).toLowerCase();
    if (['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(extension)) {
      profileImage = image;
      checkForChanges();
      emit(ProfileImageUpdated(profileImage: profileImage));
    } else {
      Print.info("Invalid image format - ${image.path}");
      emit(ProfileImageError(
          'Image must be of type jpeg, jpg, png, gif, or svg'));
    }
  }

  void clearProfileImage() {
    profileImage = null;
    checkForChanges();
    emit(ProfileImageCleared());
  }

  void checkForChanges() {
    final user = globalCubit.contactResponse?.data.user ??
        UserDetails(
          id: 0,
          type: '',
          contactId: '',
          contactStatus: 'active',
        );


    final currentName = user.name ??
        (user.firstName != null && user.lastName != null
            ? '${user.firstName} ${user.lastName}'
            : '');

    final newState = nameController.text != currentName ||
        emailController.text != (user.email ?? '') ||
        mobileController.text != (user.mobile ?? '') ||
        profileImage != null;

    if (newState != hasChanges) {
      hasChanges = newState;
      emit(ProfileDataUpdated(hasChanges: hasChanges));
    }
  }

  Future<void> saveChanges() async {
    emit(ProfileUpdating());
    if (!formKey.currentState!.validate()) return;

    await globalCubit.updateProfile(
      name: nameController.text,
      email: emailController.text,
      mobile: mobileController.text,
      image: profileImage,
    );

    clearProfileImage();
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    return super.close();
  }
}
