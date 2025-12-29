import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';
import '../../../../core/database/api/end_points.dart';
import '../model/wishlist_model.dart';

//! WishlistRepo
class WishlistRepo {
  final ApiConsumer api;
  WishlistRepo(this.api);

  Future<Either<String, String>> addToWishlist({
    required String productId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.addProductToWishlist,
        data: {
          'product_id': productId,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return Right(data['message'] as String);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, Wishlist>> getWishlist() async {
    try {
      final response = await api.get(EndPoints.favorites);
      final data = response.data as Map<String, dynamic>?;
      return Right(Wishlist.fromJson(data!));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> removeFromWishlist(int wishlistItemId) async {
    try {
      final response =
          await api.get('${EndPoints.removeFavItem}/$wishlistItemId');
      final data = response.data as Map<String, dynamic>;
      return Right(data['message'] as String? ??
          'Item removed from wishlist successfully');
    } catch (e) {
      return Left(e is ServerException ? e.errorModel.detail : 'network_error');
    }
  }
}
