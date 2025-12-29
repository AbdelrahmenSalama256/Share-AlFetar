import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';
import '../../../product/data/model/product_details_model.dart';
import '../model/category_model.dart';
import '../model/offer_product_model.dart';
import '../model/offers_model.dart';
import '../model/product_model.dart';

//! HomeRepo
class HomeRepo {
  final ApiConsumer api;

  HomeRepo(this.api);

  Future<Either<String, Map<String, dynamic>>> getProducts({
    int? categoryId,
    int? page = 1,
    int? perPage,
    String? brandId,
    String? sku,
    String? name,
  }) async {
    try {
      final queryParams = _buildQueryParams(
        categoryId: categoryId,
        page: page,
        perPage: perPage,
        brandId: brandId,
        sku: sku,
        name: name,
      );
      final response =
          await api.get(EndPoints.allProducts, queryParameters: queryParams);
      final data = response.data as Map<String, dynamic>;
      final products = (data['data'] as List<dynamic>?)
              ?.map(
                  (json) => ProductModel.fromJson(json as Map<String, dynamic>))
              .toList() ??
          [];
      return Right({'products': products, 'meta': data['meta']});
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Map<String, dynamic>? _buildQueryParams({
    int? categoryId,
    int? page,
    int? perPage,
    String? brandId,
    String? sku,
    String? name,
  }) {
    final params = <String, dynamic>{
      if (categoryId != null) 'category_id': categoryId,
      if (page != null) 'page': page,
      if (perPage != null) 'per_page': perPage,
      if (brandId != null) 'brand_id': brandId,
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
    };
    return params.isNotEmpty ? params : null;
  }

  Future<Either<String, List<CategoryModel>>> fetchCategories() async {
    try {
      final response = await api.get(EndPoints.category);
      final data = response.data as Map<String, dynamic>?;
      final categories = (data?['data'] as List<dynamic>?)
          ?.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(categories ?? []);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ProductDetailsModel>> getProductDetails(
      int productId) async {
    try {
      final response = await api.get('${EndPoints.productDetails}/$productId');
      final responseData = response.data as Map<String, dynamic>;


      return Right(ProductDetailsModel.fromJson(responseData));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to load product details');
    }
  }

  Future<Either<String, List<OfferModel>>> fetchOffers() async {
    try {
      final response = await api.get(EndPoints.offers);
      final data = response.data as Map<String, dynamic>?;
      final offers = (data?['data'] as List<dynamic>?)
          ?.map((json) => OfferModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(offers ?? []);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, List<OfferProductModel>>> fetchOfferProducts(
      int offerId) async {
    try {
      final response = await api.get('${EndPoints.productByoffers}/$offerId');
      final data = response.data as Map<String, dynamic>?;
      final products = (data?['data'] as List<dynamic>?)
          ?.map((json) =>
              OfferProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(products ?? []);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
