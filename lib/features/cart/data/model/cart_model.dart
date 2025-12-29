//! CartItem
class CartItem {
  final int? id;
  final ProductModel? product;
  final int? quantity;
  final int? variationId;
  final String? variationName;

  CartItem({
    this.id,
    this.product,
    this.quantity,
    this.variationId,
    this.variationName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final variation = json['variation'] as Map<String, dynamic>? ?? {};
    final productJson = variation['product'] as Map<String, dynamic>? ?? {};
    return CartItem(
      id: json['id'] as int?,
      product: ProductModel.fromJson({
        ...productJson,
        'sell_price_inc_tax': variation['sell_price_inc_tax'] ?? '0',
        'image_url': productJson['image_url'] ?? '',
      }),
      quantity: json['quantity'] as int?,
      variationId: json['variation_id'] as int?,
      variationName: variation['name'] as String?,
    );
  }
}

//! Cart
class Cart {
  final List<CartItem> items;
  final double? shipping;
  final double? tax;
  final double? total;
  final double? cartTotal;
  final double? finalTotal;
  final int? totalItems;

  Cart({
    required this.items,
    this.shipping,
    this.tax,
    this.total,
    this.cartTotal,
    this.finalTotal,
    this.totalItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['data'] as List?)
              ?.where((e) => e != null)
              .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      shipping: double.tryParse(json['shipping']?.toString() ?? '') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0.0,
      total: double.tryParse(json['final_total']?.toString() ?? '') ?? 0.0,
      cartTotal: double.tryParse(json['cart_total']?.toString() ?? '') ?? 0.0,
      finalTotal: double.tryParse(json['final_total']?.toString() ?? '') ?? 0.0,
      totalItems: json['total_items'] as int? ?? 0,
    );
  }
}

//! ProductModel
class ProductModel {
  final int? id;
  final String? name;
  final String? imagePath;
  final double? price;
  final String? storeName;

  ProductModel({
    this.id,
    this.name,
    this.imagePath,
    this.price,
    this.storeName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? 'Unknown',
      imagePath: json['image_url'] as String? ?? '',
      price:
          double.tryParse(json['sell_price_inc_tax'] as String? ?? '0') ?? 0.0,
      storeName: json['business_id'] != null
          ? 'Store ${json['business_id']}'
          : 'Unknown',
    );
  }
}
