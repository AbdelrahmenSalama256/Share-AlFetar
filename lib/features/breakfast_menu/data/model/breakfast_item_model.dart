enum BreakfastType { sandwich, drink, snack }

extension BreakfastTypeLabel on BreakfastType {
  String get label {
    switch (this) {
      case BreakfastType.sandwich:
        return 'filter_sandwiches';
      case BreakfastType.drink:
        return 'filter_drinks';
      case BreakfastType.snack:
        return 'filter_snacks';
    }
  }
}

class BreakfastItemModel {
  final String id;
  final String name;
  final String description;
  final BreakfastType type;
  final String? image;
  final bool isHot;
  final DateTime? createdAt;
  final double price;
  final double deliveryFee;
  final String classification;

  const BreakfastItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.image,
    this.isHot = false,
    this.createdAt,
    this.price = 0.0,
    this.deliveryFee = 0.0,
    this.classification = 'product',
  });

  BreakfastItemModel copyWith({
    String? id,
    String? name,
    String? description,
    BreakfastType? type,
    String? image,
    bool? isHot,
    DateTime? createdAt,
    double? price,
    double? deliveryFee,
    String? classification,
  }) {
    return BreakfastItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      image: image ?? this.image,
      isHot: isHot ?? this.isHot,
      createdAt: createdAt ?? this.createdAt,
      price: price ?? this.price,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      classification: classification ?? this.classification,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'image': image,
      'isHot': isHot,
      'createdAt': createdAt?.toIso8601String(),
      'price': price,
      'deliveryFee': deliveryFee,
      'classification': classification,
    };
  }

  factory BreakfastItemModel.fromJson(Map<String, dynamic> json) {
    return BreakfastItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: _typeFromJson(json['type'] as String?),
      image: json['image'] as String?,
      isHot: json['isHot'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      price: _parseDouble(json['price'], fallback: 0.0),
      deliveryFee: _parseDouble(json['deliveryFee'], fallback: 0.0),
      classification: json['classification'] as String? ?? 'product',
    );
  }

  static BreakfastType _typeFromJson(String? value) {
    switch (value) {
      case 'drink':
        return BreakfastType.drink;
      case 'snack':
        return BreakfastType.snack;
      case 'sandwich':
      default:
        return BreakfastType.sandwich;
    }
  }

  static double _parseDouble(dynamic value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? fallback;
  }
}
