import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';
import '../models/notification_model.dart';

//! NotificationsRepo
class NotificationsRepo {
  final ApiConsumer api;

  NotificationsRepo(this.api);

  Future<Either<String, List<NotificationModel>>> fetchNotifications() async {
    try {
      final response = await api.get(EndPoints.notifications);
      final data = response.data as Map<String, dynamic>?;
      final notifications = (data?['notifications'] as List<dynamic>?)
          ?.map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(notifications ?? []);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, bool>> markAsRead(int notificationId) async {
    try {
      return Right(true);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, bool>> markAllAsRead() async {
    try {
      return Right(true);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
