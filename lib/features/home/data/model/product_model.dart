import 'package:cozy/core/constants/widgets/print_util.dart';

//! ProductModel
class ProductModel {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final String imagePath;
  final double price;
  final double? oldPrice;
  final String categoryKey;
  final String storeNameKey;
  final String currencySymbolKey;
  final double rating;
  final int reviewCount;
  final bool isFavourited;
  final bool isInStock;
  final List<String> imageGallery;
  final Map<String, String> specifications;
  final List<String> availableSizes;
  final List<String> availableColors;

  ProductModel({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.imagePath,
    required this.price,
    this.oldPrice,
    required this.categoryKey,
    required this.storeNameKey,
    required this.currencySymbolKey,
    required this.rating,
    required this.reviewCount,
    this.isFavourited = false,
    this.isInStock = true,
    this.imageGallery = const [],
    this.specifications = const {},
    this.availableSizes = const [],
    this.availableColors = const [],
  });

  ProductModel copyWith({
    String? id,
    String? nameKey,
    String? descriptionKey,
    String? imagePath,
    double? price,
    double? oldPrice,
    String? categoryKey,
    String? storeNameKey,
    String? currencySymbolKey,
    double? rating,
    int? reviewCount,
    bool? isFavourited,
    bool? isInStock,
    List<String>? imageGallery,
    Map<String, String>? specifications,
    List<String>? availableSizes,
    List<String>? availableColors,
  }) {
    return ProductModel(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      categoryKey: categoryKey ?? this.categoryKey,
      storeNameKey: storeNameKey ?? this.storeNameKey,
      currencySymbolKey: currencySymbolKey ?? this.currencySymbolKey,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavourited: isFavourited ?? this.isFavourited,
      isInStock: isInStock ?? this.isInStock,
      imageGallery: imageGallery ?? this.imageGallery,
      specifications: specifications ?? this.specifications,
      availableSizes: availableSizes ?? this.availableSizes,
      availableColors: availableColors ?? this.availableColors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'descriptionKey': descriptionKey,
      'imagePath': imagePath,
      'price': price,
      'oldPrice': oldPrice,
      'categoryKey': categoryKey,
      'storeNameKey': storeNameKey,
      'currencySymbolKey': currencySymbolKey,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavourited': isFavourited,
      'isInStock': isInStock,
      'imageGallery': imageGallery,
      'specifications': specifications,
      'availableSizes': availableSizes,
      'availableColors': availableColors,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final parsedPrice = double.tryParse(
          json['product_variations'] != null &&
                  json['product_variations'].isNotEmpty &&
                  json['product_variations'][0]['variations'] != null &&
                  json['product_variations'][0]['variations'].isNotEmpty
              ? json['product_variations'][0]['variations'][0]
                          ['default_sell_price']
                      ?.toString() ??
                  '0.0'
              : json['sell_price_inc_tax']?.toString() ?? '0.0',
        ) ??
        10.0; // Default to 10.0 if price is missing
    final parsedOldPrice =
        double.tryParse(json['stroked_price']?.toString() ?? '0.0') ?? 0.0;

    PrintUtil.debug(
        'ProductModel: id=${json['id']}, price=$parsedPrice, oldPrice=$parsedOldPrice, isFavourited=${json['is_favourited']}');

    return ProductModel(
      id: json['id']?.toString() ?? '0',
      nameKey: json['name'] as String? ?? 'No Name',
      descriptionKey: json['product_description'] as String? ?? '',
      imagePath: json['image_url'] as String? ?? '',
      price: parsedPrice.isFinite ? parsedPrice : 10.0,
      oldPrice: parsedOldPrice.isFinite ? parsedOldPrice : null,
      categoryKey: json['category'] != null && json['category']['name'] != null
          ? json['category']['name'] as String
          : 'Unknown',
      storeNameKey: json['brand'] != null && json['brand']['name'] != null
          ? json['brand']['name'] as String
          : 'Store ${json['business_id'] ?? 'Unknown'}',
      currencySymbolKey: json['currency_symbol'] as String? ?? '\$',
      rating: double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isFavourited: json['is_favourited'] as bool? ?? false,
      isInStock: json['enable_stock'] == 1 && json['not_for_selling'] != 1,
      imageGallery: (json['image_url'] as String?) != null
          ? [json['image_url'] as String]
          : [],
      specifications: {},
      availableSizes: (json['product_variations'] as List?)
              ?.expand((v) => v['variations'] ?? [])
              .map((v) => v['name'] as String? ?? '')
              .where((name) => name.isNotEmpty)
              .toList() ??
          [],
      availableColors: [],
    );
  }
}
