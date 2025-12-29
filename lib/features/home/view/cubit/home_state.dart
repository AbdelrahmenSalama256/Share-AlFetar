import '../../data/model/category_model.dart';
import '../../data/model/offer_product_model.dart';
import '../../data/model/offers_model.dart';

//! HomeState
class HomeState {}

final class HomeInitial extends HomeState {}

//! HomeLoading
class HomeLoading extends HomeState {}

//! HomeLoaded
class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  HomeLoaded({required this.categories});
}

//! HomeError
class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}

//! HomeCategorySelected
class HomeCategorySelected extends HomeState {
  final int index;
  HomeCategorySelected({required this.index});
}

//! HomeProductsLoading
class HomeProductsLoading extends HomeState {}

//! HomeProductsError
class HomeProductsError extends HomeState {
  final String error;
  HomeProductsError(this.error);
}

//! HomeProductsLoaded
class HomeProductsLoaded extends HomeState {}

//! ProductDetailsLoading
class ProductDetailsLoading extends HomeState {}

//! ProductDetailsLoaded
class ProductDetailsLoaded extends HomeState {}

//! ProductDetailsError
class ProductDetailsError extends HomeState {
  final String message;

  ProductDetailsError(this.message);
}

//! ProductVariationSelected
class ProductVariationSelected extends HomeState {}


//! ProductQuantityUpdated
class ProductQuantityUpdated extends HomeState {}

//! HomeOffersLoading
class HomeOffersLoading extends HomeState {}

//! HomeOffersLoaded
class HomeOffersLoaded extends HomeState {
  final List<OfferModel> offers;

  HomeOffersLoaded(this.offers);
}

//! HomeOffersError
class HomeOffersError extends HomeState {
  final String message;

  HomeOffersError(this.message);
}

//! HomeOfferProductsLoading
class HomeOfferProductsLoading extends HomeState {}

//! HomeOfferProductsLoaded
class HomeOfferProductsLoaded extends HomeState {
  final List<OfferProductModel> products;

  HomeOfferProductsLoaded(this.products);
}

//! HomeOfferProductsError
class HomeOfferProductsError extends HomeState {
  final String message;

  HomeOfferProductsError(this.message);
}
