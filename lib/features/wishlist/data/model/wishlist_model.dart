import 'package:html_unescape/html_unescape.dart';

String cleanHtmlText(String htmlText) {
  final unescape = HtmlUnescape();
  String withoutHtmlTags = htmlText.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  return unescape.convert(withoutHtmlTags);
}

//! WishlistProduct
class WishlistProduct {
  final int id;
  final String name;
  final String imageUrl;
  final String storeName;
  final String description;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewCount;

  WishlistProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.storeName,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewCount,
  });

  factory WishlistProduct.fromJson(Map<String, dynamic> json) {
    final parsedPrice =
        double.tryParse(json['sell_price_inc_tax']?.toString() ?? '0.0') ?? 0.0;
    final parsedOldPrice =
        double.tryParse(json['stroked_price']?.toString() ?? '0.0') ?? 0.0;
    final parsedRating =
        double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0;

    return WishlistProduct(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'No Name',
      imageUrl: json['image_url'] as String? ?? '',
      storeName: json['business_id'] != null
          ? 'Store ${json['business_id']}'
          : 'Unknown',
      description: cleanHtmlText(json['product_description'] as String? ?? ''),
      price: parsedPrice.isFinite ? parsedPrice : 0.0,
      oldPrice: parsedOldPrice.isFinite ? parsedOldPrice : 0.0,
      rating: parsedRating.isFinite ? parsedRating : 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
    );
  }
}

//! WishlistItem
class WishlistItem {
  final int id;
  final int userId;
  final int productId;
  final int? variationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WishlistProduct product;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    this.variationId,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      variationId: json['variation_id'] as int?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
      product: WishlistProduct.fromJson(
          json['product'] as Map<String, dynamic>? ?? {}),
    );
  }
}

//! Wishlist
class Wishlist {
  final List<WishlistItem> items;
  final int wishlistCount;

  Wishlist({
    required this.items,
    required this.wishlistCount,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      items: (json['data'] as List?)
              ?.where((e) => e != null)
              .map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      wishlistCount: json['wishlist_count'] as int? ?? 0,
    );
  }
}
