import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/core/notification/notification_handler.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';
import '../../../profile/data/models/contact_model.dart';

//! LoginRepo
class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  Future<Either<String, ContactResponse>> loginUser({
    String? username,
    String? password,
  }) async {
    try {
      final fcmToken = await NotificationHandler.getToken();
      final response = await api.post(
        EndPoints.login,
        data: {
          'username': username,
          'password': password,
          'fcm_token': fcmToken,
        },
      );

      return Right(ContactResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> sendForgotPasswordCode(
      String emailOrPhone) async {
    try {
      final response = await api.post(
        EndPoints.forgotPassword,
        data: {'email': emailOrPhone}, // Send as JSON
        isFormData: false, // Ensure JSON format
      );

      if (response.data is Map<String, dynamic>) {
        final success = response.data['success'] == true;
        final message =
            response.data['message']?.toString() ?? 'OTP sent successfully';
        if (success) {
          return Right(message);
        } else {
          return Left(message);
        }
      } else {
        return Left('Unexpected response format');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }
}
