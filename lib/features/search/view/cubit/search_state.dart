import 'package:cozy/features/home/data/model/product_model.dart';
import 'package:cozy/features/search/data/model/popular_search_model.dart';

abstract class SearchState {
  const SearchState();

  List<String> get recentSearches => [];
  List<PopularSearchModel> get popularSearches => [];
  List<String> get filterOptions => [];
  String? get selectedFilter => null;
  List<ProductModel> get searchResults => [];
  bool get isLoading => false;
  String get searchQuery => '';
  bool get hasSearched => false;
}

//! SearchInitial
class SearchInitial extends SearchState {
  @override
  final List<String> recentSearches;
  @override
  final List<PopularSearchModel> popularSearches;

  const SearchInitial({
    this.recentSearches = const [],
    this.popularSearches = const [],
  });
}

//! SearchLoading
class SearchLoading extends SearchState {
  @override
  bool get isLoading => true;
}

//! SearchResultsLoading
class SearchResultsLoading extends SearchState {
  @override
  bool get isLoading => true;
}

//! SearchResultsSuccess
class SearchResultsSuccess extends SearchState {
  final String query;
  final List<ProductModel> products;
  final List<String> availableFilters;
  final List<String> selectedFilters;
  final String? storeName;
  final String? storeLogoUrl;
  final bool isStoreOnline;
  final double storeRating;
  final int storeReviewCount;

  const SearchResultsSuccess({
    required this.query,
    required this.products,
    this.availableFilters = const [],
    this.selectedFilters = const [],
    this.storeName,
    this.storeLogoUrl,
    this.isStoreOnline = false,
    this.storeRating = 0.0,
    this.storeReviewCount = 0,
  });

  @override
  List<ProductModel> get searchResults => products;

  @override
  String get searchQuery => query;

  @override
  bool get hasSearched => true;

  @override
  List<String> get filterOptions => availableFilters;

  @override
  String? get selectedFilter =>
      selectedFilters.isNotEmpty ? selectedFilters.first : null;
}

//! SearchFailure
class SearchFailure extends SearchState {
  final String error;

  const SearchFailure({required this.error});
}
