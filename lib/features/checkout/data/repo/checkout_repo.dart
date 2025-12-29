import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/core/database/api/end_points.dart';
import 'package:dartz/dartz.dart';

//! CheckoutRepo
class CheckoutRepo {
  final ApiConsumer api;

  CheckoutRepo(this.api);

  Future<Either<String, String>> placeOrder({
    required String addressId,
    required String saleNote,
    required String finalTotal,
  }) async {
    try {
      final response = await api.post(
        EndPoints.placeOrder,
        data: {
          'address_id': addressId,
          'sale_note': saleNote,
          'final_total': finalTotal,
        },
        isFormData: true,
      );
      if (response.data['success']) {
        return Right(response.data['data']['id'].toString());
      } else {
        return Left('Failed to place order');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to place order: $e');
    }
  }
}
