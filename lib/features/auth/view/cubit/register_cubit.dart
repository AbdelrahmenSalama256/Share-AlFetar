
import 'package:bloc/bloc.dart';
import 'package:cozy/core/common/logs.dart';
import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/auth/data/models/user_registration_model.dart';
import 'package:cozy/features/auth/data/repo/register_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'register_state.dart';

//! RegisterCubit
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;
  final String id = DateTime.now().toString();

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordObscure = true;
  bool isStrongPassword = false;
  XFile? profileImage;

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    emit(RegisterPasswordVisibilityChanged(isObscure: isPasswordObscure));
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = pickedFile;
      emit(RegisterDataUpdated(profileImage: profileImage));
    }
  }

  Future<void> attemptAccountCreation() async {
    emit(RegisterLoading());

    final user = UserRegistrationModel(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      passwordConfirmation: passwordConfirmationController.text.trim(),
      name: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      image: profileImage,
    );

    final response = await registerRepo.registerUser(user);

    response.fold(
      (error) {
        Print.error("Registration failed: $error");
        emit(RegisterError(message: error));
      },
      (data) async {
        final token = data['data']['token'] as String?;
        if (token != null) {
          final cacheHelper = sl<CacheHelper>();
          await cacheHelper.setData(AppConstants.token, token);
          Print.success("Token cached: $token");
        } else {
          Print.warning("No token received in response");
        }
        emit(RegisterSuccess(
            message: data['message'] ?? 'Registration successful',
            emailForVerification: user.email));
      },
    );
  }

  void setProfileImage(XFile image) {
    final extension = path.extension(image.path).toLowerCase();
    if (['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(extension)) {
      profileImage = image;
      emit(RegisterDataUpdated(profileImage: profileImage));
    } else {
      Print.info("Invalid image format - ${image.path}");
      emit(RegisterError(
          message: 'Image must be of type jpeg, jpg, png, gif, or svg'));
    }
  }

  @override
  Future<void> close() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    nameController.dispose();
    mobileController.dispose();
    return super.close();
  }
}
