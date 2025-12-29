import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../database/api/end_points.dart';
import '../models/app_settings.dart';

//! SettingsRepo
class SettingsRepo {
  final ApiConsumer api;
  SettingsRepo(this.api);

  Future<Either<String, AppSettings>> fetchSettings() async {
    try {
      final response = await api.get(EndPoints.settingsEndpoint);
      final data = response.data as Map<String, dynamic>;
      return Right(AppSettings.fromJson(data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('failed_to_fetch_settings');
    }
  }
}

