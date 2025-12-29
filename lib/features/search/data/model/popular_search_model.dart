//! PopularSearchModel
class PopularSearchModel {
  final String id;
  final String queryKey; // Key for localization
  final int resultCount;

  PopularSearchModel({
    required this.id,
    required this.queryKey,
    required this.resultCount,
  });
}
