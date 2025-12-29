import 'package:dartz/dartz.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';
import '../../../../core/database/api/api_consumer.dart';
import '../../../../core/database/api/end_points.dart';
import '../model/cart_model.dart';

//! CartRepo
class CartRepo {
  final ApiConsumer api;

  CartRepo(this.api);

  Future<Either<String, Cart>> getCartItems() async {
    try {
      final response = await api.get(EndPoints.cart);
      final data = response.data as Map<String, dynamic>?;
      return Right(Cart.fromJson(data!));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, CartItem>> addToCart({
    required String productId,
    required int quantity,
    required int variationId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.addProductToCart,
        data: {
          'product_id': productId,
          'quantity': quantity,
          'variation_id': variationId,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return Right(CartItem.fromJson(data['data']));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> removeFromCart(int cartItemId) async {
    try {
      await api.get('${EndPoints.removeCartItem}/$cartItemId');
      return Right('item_removed_from_cart_successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> clearCart() async {
    try {
      await api.get(EndPoints.clearCart);
      return Right('cart_cleard_successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await api.post(
        '${EndPoints.updateCartItemQuantity}/$cartItemId',
        data: {
          'quantity': quantity,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final message = (data['message'] as String?) ?? 'cart_item_quantity_updated';
      return Right(message);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
