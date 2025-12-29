//! OrderItem
class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String? productImage;
  final double unitPrice;
  final int quantity;
  final double lineTotal;
  final String? variations;
  final String? sellLineNote;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    this.variations,
    this.sellLineNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'unit_price': unitPrice,
      'quantity': quantity,
      'line_total': lineTotal,
      'variations': variations,
      'sell_line_note': sellLineNote,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product']?['name']?.toString() ?? 'Unknown Product',
      productImage: json['product']?['image_url']?.toString() ??
          json['product']?['image']?.toString(),
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      lineTotal: (double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0) *
          (int.tryParse(json['quantity']?.toString() ?? '0') ?? 0),
      variations: json['variations']?['name']?.toString(),
      sellLineNote: json['sell_line_note']?.toString(),
    );
  }
}
