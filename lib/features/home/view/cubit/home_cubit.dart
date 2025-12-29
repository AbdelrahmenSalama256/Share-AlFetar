import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/notification/local_notification_handler.dart';
import '../../../../core/notification/notification_prefs.dart';
import '../../../../core/services/service_locator.dart';
import '../../../product/data/model/product_details_model.dart';
import '../../data/model/category_model.dart';
import '../../data/model/offer_product_model.dart' hide ProductVariation;
import '../../data/model/offers_model.dart';
import '../../data/model/product_model.dart';
import '../../data/repo/home_repo.dart';
import 'home_state.dart';

//! HomeCubit
class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo = sl<HomeRepo>();
  HomeCubit() : super(HomeInitial());

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<OfferModel> offers = [];
  List<OfferProductModel> offerProducts = []; // Add this

  List<ProductDetailsModel> productDetails = [];
  int selectedCategoryIndex = 0;
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  String selectedVariationId = '';
  int quantity = 1;
  final Map<int, int> _productStockCache = {};

  List<ProductModel> get filteredProducts {
    if (searchQuery.trim().isEmpty) return products;
    final q = searchQuery.toLowerCase().trim();
    return products.where((p) {
      final name = (p.nameKey).toLowerCase();
      final store = (p.storeNameKey).toLowerCase();
      return name.contains(q) || store.contains(q);
    }).toList();
  }

  void setSearchQuery(String query) {
    searchController.text = query;
    searchQuery = query;
    emit(HomeProductsLoaded());
  }

  void initialize() {
    fetchCategories();
    fetchOffers();

    fetchProducts();
  }

  Future<void> fetchCategories() async {
    emit(HomeLoading());
    final result = await homeRepo.fetchCategories();
    result.fold(
      (error) => emit(HomeError(error)),
      (data) {
        categories = data;
        emit(HomeLoaded(categories: data));
      },
    );
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isLoadingMore) return;

    if (isRefresh) {
      resetPagination();
      emit(HomeProductsLoading());
    } else if (!hasMore) {
      return;
    }

    isLoadingMore = true;
    final categoryId =
        selectedCategoryIndex > 0 ? categories[selectedCategoryIndex].id : null;
    final name = selectedCategoryIndex == 0
        ? null
        : categories[selectedCategoryIndex].name;

    final result = await homeRepo.getProducts(
      categoryId: categoryId,
      page: currentPage,
      name: name,
    );
    result.fold(
      (error) => emit(HomeProductsError(error)),
      (data) {
        products.addAll(data['products'] as List<ProductModel>);
        updatePagination(data['meta'] as Map<String, dynamic>);
        emit(HomeProductsLoaded());
      },
    );
    isLoadingMore = false;
  }

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    fetchProducts(isRefresh: true);
    emit(HomeCategorySelected(index: index));
  }

  void resetPagination() {
    currentPage = 1;
    products.clear();
    hasMore = true;
  }

  void updatePagination(Map<String, dynamic> meta) {
    hasMore = currentPage < (meta['last_page'] as int);
    if (hasMore) currentPage++;
  }

  Future<void> fetchProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    selectedVariationId = '';
    quantity = 1;

    final result = await homeRepo.getProductDetails(productId);
    final previousStock = _productStockCache[productId];
    await result.fold(
      (error) async {
        emit(ProductDetailsError(error));
      },
      (product) async {
        productDetails = [product];

        if (product.variations?.isNotEmpty ?? false) {
          selectedVariationId = product.variations!.first.id?.toString() ?? '';
        }
        final currentStock = currentSelectedStock;
        final totalStock = product.totalAvailableQuantity;
        _productStockCache[productId] = totalStock;
        quantity = currentStock > 0 ? 1 : 0;
        final shouldNotify =
            previousStock != null && previousStock <= 0 && totalStock > 0;
        if (shouldNotify) {
          await _notifyProductRestock(product);
        }
        emit(ProductDetailsLoaded());
      },
    );
  }

  void selectVariation(String variationId) {
    selectedVariationId = variationId;
    if (productDetails.isNotEmpty) {
      final product = productDetails.last;
      final variation = _findVariationById(product, variationId);
      final available = variation?.quantity ?? 0;
      quantity = available > 0 ? 1 : 0;
    }
    emit(ProductVariationSelected());
  }

  void updateQuantity(int newQuantity) {
    final maxQuantity = currentSelectedStock;
    if (maxQuantity <= 0) {
      quantity = 0;
    } else {
      final clamped = newQuantity.clamp(1, maxQuantity);
      quantity = clamped.toInt();
    }
    emit(ProductQuantityUpdated());
  }

  Future<void> fetchOffers() async {
    emit(HomeOffersLoading());
    final result = await homeRepo.fetchOffers();
    result.fold(
      (error) => emit(HomeOffersError(error)),
      (data) {
        offers = data;
        emit(HomeOffersLoaded(data));
      },
    );
  }

  Future<void> fetchOfferProducts(int offerId) async {
    emit(HomeOfferProductsLoading());
    final result = await homeRepo.fetchOfferProducts(offerId);
    result.fold(
      (error) => emit(HomeOfferProductsError(error)),
      (data) {
        offerProducts = data;
        emit(HomeOfferProductsLoaded(data));
      },
    );
  }

  void setProductFavouriteById(String productId, bool isFavourite) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      products[index] = products[index].copyWith(isFavourited: isFavourite);
      emit(HomeProductsLoaded());
    }
  }

  void setProductDetailsFavourite(bool isFavourite) {
    if (productDetails.isNotEmpty) {
      final last = productDetails.last;
      productDetails[productDetails.length - 1] =
          last.copyWith(isFavourited: isFavourite);
      emit(ProductDetailsLoaded());
    }
  }

  int get currentSelectedStock {
    if (productDetails.isEmpty) return 0;
    final product = productDetails.last;
    if (product.variations?.isNotEmpty ?? false) {
      final targetId = selectedVariationId.isNotEmpty
          ? selectedVariationId
          : product.variations!.first.id?.toString() ?? '';
      final variation = _findVariationById(product, targetId);
      return variation?.quantity ?? 0;
    }
    return product.totalAvailableQuantity;
  }

  bool get isCurrentSelectionOutOfStock => currentSelectedStock <= 0;

  ProductVariation? _findVariationById(
      ProductDetailsModel product, String variationId) {
    if (product.variations == null) return null;
    for (final variation in product.variations!) {
      if (variation.id?.toString() == variationId) {
        return variation;
      }
    }
    return null;
  }

  Future<void> _notifyProductRestock(ProductDetailsModel product) async {
    if (!NotificationPrefs.getPushEnabled() &&
        !NotificationPrefs.getStockAlertsEnabled()) {
      return;
    }
    final productName =
        product.name?.trim().isEmpty ?? true ? 'Product' : product.name!.trim();
    const title = 'Back in Stock';
    final body = '$productName is available now.';
    await LocalNotificationService.showSimpleNotification(
      title: title,
      body: body,
      id: product.id ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}
