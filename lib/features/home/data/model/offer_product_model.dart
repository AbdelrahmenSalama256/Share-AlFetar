import 'package:flutter/material.dart';

//! OfferProductModel
class OfferProductModel {
  final int id;
  final String name;
  final String? nameAr;
  final String? image;
  final String imageUrl;
  final bool isFavourited;
  final String sku;
  final String type;
  final double? defaultSellPrice;
  final double? sellPriceIncTax;
  final double? defaultPurchasePrice;
  final double? dppIncTax;
  final double? profitPercent;
  final Brand? brand;
  final Category? category;
  final Unit unit;
  final List<ProductVariation> productVariations;
  final List<ProductLocation> productLocations;

  OfferProductModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.image,
    required this.imageUrl,
    required this.isFavourited,
    required this.sku,
    required this.type,
    this.defaultSellPrice,
    this.sellPriceIncTax,
    this.defaultPurchasePrice,
    this.dppIncTax,
    this.profitPercent,
    this.brand,
    this.category,
    required this.unit,
    required this.productVariations,
    required this.productLocations,
  });

  factory OfferProductModel.fromJson(Map<String, dynamic> json) {
    return OfferProductModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      isFavourited: (json['is_favourited'] as bool?) ?? false,
      sku: json['sku'] as String? ?? '',
      type: json['type'] as String? ?? 'single',
      defaultSellPrice: (json['default_sell_price'] as num?)?.toDouble(),
      sellPriceIncTax: (json['sell_price_inc_tax'] as num?)?.toDouble(),
      defaultPurchasePrice:
          (json['default_purchase_price'] as num?)?.toDouble(),
      dppIncTax: (json['dpp_inc_tax'] as num?)?.toDouble(),
      profitPercent: (json['profit_percent'] as num?)?.toDouble(),
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      unit: Unit.fromJson(json['unit']),
      productVariations: (json['product_variations'] as List<dynamic>?)
              ?.map((v) => ProductVariation.fromJson(v))
              .toList() ??
          [],
      productLocations: (json['product_locations'] as List<dynamic>?)
              ?.map((l) => ProductLocation.fromJson(l))
              .toList() ??
          [],
    );
  }

  String getDisplayName(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return (locale == 'ar' && nameAr != null) ? nameAr! : name;
  }

  double get price => sellPriceIncTax ?? defaultSellPrice ?? 0.0;
  double get oldPrice => dppIncTax ?? defaultPurchasePrice ?? 0.0;
  bool get hasDiscount => oldPrice > 0 && price < oldPrice;
  double get discountPercentage {
    if (oldPrice <= 0 || price >= oldPrice) return 0;
    return ((oldPrice - price) / oldPrice) * 100;
  }
}

//! Brand
class Brand {
  final int id;
  final String name;
  final String? nameAr;
  final String? image;
  final String imageUrl;

  Brand({
    required this.id,
    required this.name,
    this.nameAr,
    this.image,
    required this.imageUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  String getDisplayName(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return (locale == 'ar' && nameAr != null) ? nameAr! : name;
  }
}

//! Category
class Category {
  final int id;
  final String name;
  final String? nameAr;
  final String? image;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    this.nameAr,
    this.image,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  String getDisplayName(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return (locale == 'ar' && nameAr != null) ? nameAr! : name;
  }
}

//! Unit
class Unit {
  final int id;
  final String actualName;
  final String shortName;

  Unit({
    required this.id,
    required this.actualName,
    required this.shortName,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as int,
      actualName: json['actual_name'] as String? ?? '',
      shortName: json['short_name'] as String? ?? '',
    );
  }
}

//! ProductVariation
class ProductVariation {
  final int id;
  final String name;
  final List<Variation> variations;

  ProductVariation({
    required this.id,
    required this.name,
    required this.variations,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      variations: (json['variations'] as List<dynamic>?)
              ?.map((v) => Variation.fromJson(v))
              .toList() ??
          [],
    );
  }
}

//! Variation
class Variation {
  final int id;
  final String name;
  final String subSku;
  final double defaultSellPrice;
  final double sellPriceIncTax;

  Variation({
    required this.id,
    required this.name,
    required this.subSku,
    required this.defaultSellPrice,
    required this.sellPriceIncTax,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      subSku: json['sub_sku'] as String? ?? '',
      defaultSellPrice: (json['default_sell_price'] as num?)?.toDouble() ?? 0.0,
      sellPriceIncTax: (json['sell_price_inc_tax'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

//! ProductLocation
class ProductLocation {
  final int id;
  final String name;

  ProductLocation({
    required this.id,
    required this.name,
  });

  factory ProductLocation.fromJson(Map<String, dynamic> json) {
    return ProductLocation(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}
