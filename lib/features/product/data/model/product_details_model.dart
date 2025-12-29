import 'package:html/parser.dart' as html_parser;

//! ProductDetailsModel
class ProductDetailsModel {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? description;
  final List<String>? imageUrls;
  final double? price;
  final double? oldPrice;
  final String? storeName;
  final double? rating;
  final Map<String, String>? specifications;
  final bool? isFavorite;
  final bool? isFavourited; // Added this field
  final List<ProductVariation>? variations;
  final String? selectedVariationId;

  ProductDetailsModel({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.imageUrls,
    this.price,
    this.oldPrice,
    this.storeName,
    this.rating,
    this.specifications,
    this.isFavorite = false,
    this.isFavourited = false, // Default to false
    this.variations,
    this.selectedVariationId = '',
  });

  ProductDetailsModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? description,
    List<String>? imageUrls,
    double? price,
    double? oldPrice,
    String? storeName,
    double? rating,
    Map<String, String>? specifications,
    bool? isFavorite,
    bool? isFavourited,
    List<ProductVariation>? variations,
    String? selectedVariationId,
  }) {
    return ProductDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      storeName: storeName ?? this.storeName,
      rating: rating ?? this.rating,
      specifications: specifications ?? this.specifications,
      isFavorite: isFavorite ?? this.isFavorite,
      isFavourited: isFavourited ?? this.isFavourited,
      variations: variations ?? this.variations,
      selectedVariationId: selectedVariationId ?? this.selectedVariationId,
    );
  }

  int get totalAvailableQuantity {
    if (variations == null || variations!.isEmpty) {
      return 0;
    }
    var total = 0;
    for (final variation in variations!) {
      total += variation.quantity ?? 0;
    }
    return total;
  }

  bool get isOutOfStock => totalAvailableQuantity <= 0;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    try {

      final dataList = json['data'] as List? ?? [];
      if (dataList.isEmpty) {
        throw Exception('No product data found');
      }

      final productData = dataList.first as Map<String, dynamic>;


      final variations = (productData['product_variations'] as List? ?? [])
          .expand((pv) => (pv['variations'] as List? ?? []).map((v) {
                final variation = ProductVariation.fromJson(v);

                final locationDetails =
                    (v['variation_location_details'] as List? ?? []);
                if (locationDetails.isNotEmpty) {
                  variation.quantity = double.tryParse(
                          locationDetails.first['qty_available']?.toString() ??
                              '0')
                      ?.toInt();
                }
                return variation;
              }))
          .toList();





      final descriptionRaw =
          productData['product_description']?.toString() ?? '';
      final document = html_parser.parse(descriptionRaw);
      final description = document.body?.text.trim() ?? '';

      final firstVariation = variations.isNotEmpty ? variations.first : null;
      final price = firstVariation?.price ?? 0.0;


      final brand = productData['brand'] as Map<String, dynamic>?;
      final storeName = brand?['name']?.toString() ?? 'Unknown';

      return ProductDetailsModel(
        id: productData['id'] as int?,
        name: productData['name']?.toString(),
        imageUrl: productData['image_url']?.toString(),
        description: description,
        imageUrls: [productData['image_url']?.toString() ?? ''],
        price: price,
        storeName: storeName,
        specifications: {
          'Material': description.isNotEmpty ? description : 'Not specified',
          'Dimensions': 'Not specified',
          'Color': 'Not specified',
          'Weight Capacity': 'Not specified',
        },
        isFavourited:
            productData['is_favourited'] as bool? ?? false, // Added this line
        variations: variations,
        selectedVariationId:
            variations.isNotEmpty ? variations.first.id.toString() : '',
      );
    } catch (e) {
      throw Exception('Failed to parse product details: $e');
    }
  }
}

//! ProductVariation
class ProductVariation {
  final int? id;
  final String? name;
  final double? price;
  final String? color;
  final String? size;
  int? quantity;

  ProductVariation({
    this.id,
    this.name,
    this.price,
    this.color,
    this.size,
    this.quantity,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: double.tryParse(json['sell_price_inc_tax']?.toString() ?? '0'),
      quantity: int.tryParse(json['qty_available']?.toString() ?? '0'),
    );
  }
}
