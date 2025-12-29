import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';
import '../models/about_model.dart';

//! AboutRepo
class AboutRepo {
  final ApiConsumer api;
  AboutRepo(this.api);

  Future<Either<String, AboutResponse>> fetchAbout() async {
    try {
      final response = await api.get(EndPoints.about);
      final data = response.data as Map<String, dynamic>;
      return Right(AboutResponse.fromJson(data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('failed_to_fetch_about');
    }
  }
}

