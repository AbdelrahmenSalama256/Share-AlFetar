import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/core/database/api/end_points.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';
import '../models/contact_model.dart';

//! ProfileRepo
class ProfileRepo {
  final ApiConsumer api;

  ProfileRepo(this.api);

  Future<Either<String, ContactResponse>> getProfile() async {
    try {
      final response = await api.get(EndPoints.getProfile);
      return Right(ContactResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch profile: $e');
    }
  }

  Future<Either<String, String>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    XFile? image,
  }) async {
    try {
      Map<String, dynamic> data = {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (mobile != null) 'mobile': mobile,
      };

      if (image != null) {
        data['image'] =
            await MultipartFile.fromFile(image.path, filename: image.name);
      }

      final response = await api.post(
        EndPoints.updateProfile,
        data: data,
        isFormData: true,
      );

      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to update profile: $e');
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      final response = await api.get(EndPoints.userLogout);
      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to logout: $e');
    }
  }
}
