import 'package:cozy/features/home/data/model/product_model.dart';
import 'package:cozy/features/search/data/model/popular_search_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_state.dart';

//! SearchCubit
class SearchCubit extends Cubit<SearchState> {
  SearchCubit()
      : super(SearchInitial(
            recentSearches: _sampleRecentSearches,
            popularSearches: _samplePopularSearches));

  static const List<String> _sampleRecentSearches = [
    'search_recent_1',
    'search_recent_2',
    'search_recent_3',
  ];

  static final List<PopularSearchModel> _samplePopularSearches = [
    PopularSearchModel(
        id: 'pop1', queryKey: 'search_popular_query_1', resultCount: 1200),
    PopularSearchModel(
        id: 'pop2', queryKey: 'search_popular_query_2', resultCount: 950),
    PopularSearchModel(
        id: 'pop3', queryKey: 'search_popular_query_3', resultCount: 700),
  ];

  final List<ProductModel> _allSampleProducts = [];

  final List<String> _currentRecentSearches = List.from(_sampleRecentSearches);
  List<String> _selectedFilters = [];

  void loadInitialData() {
    emit(SearchInitial(
      recentSearches: _currentRecentSearches,
      popularSearches: _samplePopularSearches,
    ));
  }

  void onSearchQueryChanged(String query) {
    if (query.isEmpty) {
      emit(SearchInitial(
        recentSearches: _currentRecentSearches,
        popularSearches: _samplePopularSearches,
      ));
    }
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial(
        recentSearches: _currentRecentSearches,
        popularSearches: _samplePopularSearches,
      ));
      return;
    }

    emit(SearchResultsLoading());
    await Future.delayed(const Duration(seconds: 1));

    if (!_currentRecentSearches.contains(query) && query.length < 20) {
      _currentRecentSearches.insert(0, query);
      if (_currentRecentSearches.length > 5) {
        _currentRecentSearches.removeLast();
      }
    }

    final results = _allSampleProducts
        .where((p) =>
            p.nameKey.toLowerCase().contains(query.toLowerCase()) ||
            p.storeNameKey.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(SearchResultsSuccess(
      query: query,
      products: results,
      availableFilters: [
        'filter_brand_key',
        'filter_price_key',
        'filter_color_key',
        'filter_rating_key',
      ],
      selectedFilters: _selectedFilters,
      storeName: results.isNotEmpty ? 'store_sample_shop_key' : null,
      storeLogoUrl: results.isNotEmpty
          ? 'https://images.unsplash.com/photo-1588196749597-9ff075ee6b5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=50&q=80'
          : null,
      isStoreOnline: results.isNotEmpty,
      storeRating: results.isNotEmpty ? 4.7 : 0.0,
      storeReviewCount: results.isNotEmpty ? 230 : 0,
    ));
  }

  void selectFilter(String filterKey) {
    final currentState = state;
    if (currentState is SearchResultsSuccess) {
      final newSelectedFilters =
          List<String>.from(currentState.selectedFilters);
      if (newSelectedFilters.contains(filterKey)) {
        newSelectedFilters.remove(filterKey);
      } else {
        newSelectedFilters.add(filterKey);
      }
      _selectedFilters = newSelectedFilters;

      emit(currentState.copyWith(selectedFilters: newSelectedFilters));
    }
  }

  void clearRecentSearches() {
    _currentRecentSearches.clear();
    if (state is SearchInitial) {
      emit(SearchInitial(
        recentSearches: _currentRecentSearches,
        popularSearches: _samplePopularSearches,
      ));
    }
  }

  void removeRecentSearch(String queryKey) {
    _currentRecentSearches.remove(queryKey);
    if (state is SearchInitial) {
      emit(SearchInitial(
        recentSearches: _currentRecentSearches,
        popularSearches: _samplePopularSearches,
      ));
    }
  }
}

extension SearchResultsSuccessCopyWith on SearchResultsSuccess {
  SearchResultsSuccess copyWith({
    String? query,
    List<ProductModel>? products,
    List<String>? availableFilters,
    List<String>? selectedFilters,
    String? storeName,
    String? storeLogoUrl,
    bool? isStoreOnline,
    double? storeRating,
    int? storeReviewCount,
  }) {
    return SearchResultsSuccess(
      query: query ?? this.query,
      products: products ?? this.products,
      availableFilters: availableFilters ?? this.availableFilters,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      storeName: storeName ?? this.storeName,
      storeLogoUrl: storeLogoUrl ?? this.storeLogoUrl,
      isStoreOnline: isStoreOnline ?? this.isStoreOnline,
      storeRating: storeRating ?? this.storeRating,
      storeReviewCount: storeReviewCount ?? this.storeReviewCount,
    );
  }
}
