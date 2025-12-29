import 'package:image_picker/image_picker.dart';

//! UserRegistrationModel
class UserRegistrationModel {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String name;
  final String mobile;
  final String? fcmToken;
  final XFile? image;

  UserRegistrationModel({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.name,
    required this.mobile,
    this.fcmToken,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'name': name,
        'mobile': mobile,
        'fcm_token': fcmToken,
        'image': image?.path.split('/').last,
      };

  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) =>
      UserRegistrationModel(
        username: json['username'],
        email: json['email'],
        password: json['password'],
        passwordConfirmation: json['password_confirmation'],
        name: json['name'],
        mobile: json['mobile'],
        fcmToken: json['fcm_token'],
        image: json['image'] != null ? XFile(json['image']) : null,
      );
}
