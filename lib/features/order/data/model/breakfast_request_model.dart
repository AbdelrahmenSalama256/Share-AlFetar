import 'package:cozy/features/breakfast_menu/data/model/breakfast_item_model.dart';

enum RequestStatus { pending, accepted, rejected }

class BreakfastRequestModel {
  final String id;
  final List<BreakfastItemModel> items;
  final String? note;
  final String requesterName;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final double deliveryFee;

  const BreakfastRequestModel({
    required this.id,
    required this.items,
    required this.requesterName,
    required this.status,
    required this.createdAt,
    this.note,
    this.respondedAt,
    this.deliveryFee = 0.0,
  });

  BreakfastRequestModel copyWith({
    String? id,
    List<BreakfastItemModel>? items,
    String? note,
    String? requesterName,
    RequestStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
    double? deliveryFee,
  }) {
    return BreakfastRequestModel(
      id: id ?? this.id,
      items: items ?? this.items,
      requesterName: requesterName ?? this.requesterName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      respondedAt: respondedAt ?? this.respondedAt,
      deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'note': note,
      'requesterName': requesterName,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'deliveryFee': deliveryFee,
    };
  }

  factory BreakfastRequestModel.fromJson(Map<String, dynamic> json) {
    return BreakfastRequestModel(
      id: json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => BreakfastItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      note: json['note'] as String?,
      requesterName: json['requesterName'] as String? ?? 'Guest',
      status: _statusFromJson(json['status'] as String?),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      respondedAt: json['respondedAt'] != null
          ? DateTime.tryParse(json['respondedAt'] as String)
          : null,
      deliveryFee: _parseDouble(json['deliveryFee']),
    );
  }

  static RequestStatus _statusFromJson(String? value) {
    switch (value) {
      case 'accepted':
        return RequestStatus.accepted;
      case 'rejected':
        return RequestStatus.rejected;
      case 'pending':
      default:
        return RequestStatus.pending;
    }
  }

  /// Total price of all selected items (respects quantity via duplicates).
  double get itemsTotal =>
      items.fold<double>(0.0, (sum, item) => sum + item.price);

  /// Delivery fee combines order-level fee and per-item fees.
  double get totalDelivery =>
      deliveryFee +
      items.fold<double>(0.0, (sum, item) => sum + item.deliveryFee);

  double get grandTotal => itemsTotal + totalDelivery;

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
