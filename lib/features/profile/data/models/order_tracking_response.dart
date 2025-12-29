import 'tracking_event_model.dart';

//! OrderTrackResponse
class OrderTrackResponse {
  final bool success;
  final List<TrackingEvent> trackingEvents;
  final String orderDate;
  final int items;
  final String invoiceNo;
  final String trackingNo;
  final String finalTotal;

  OrderTrackResponse({
    required this.success,
    required this.trackingEvents,
    required this.orderDate,
    required this.items,
    required this.invoiceNo,
    required this.trackingNo,
    required this.finalTotal,
  });

  factory OrderTrackResponse.fromJson(Map<String, dynamic> json) {
    return OrderTrackResponse(
      success: json['success'] as bool? ?? false,
      trackingEvents: json['data'] != null && json['data'] is List
          ? (json['data'] as List)
              .map((eventJson) => TrackingEvent.fromJson(eventJson))
              .toList()
          : [],
      orderDate: json['order_date']?.toString() ?? '',
      items: _parseItems(json['items']),
      invoiceNo: json['invoice_no']?.toString() ?? '',
      trackingNo: json['tracking_no']?.toString() ?? '',
      finalTotal: json['final_total']?.toString() ?? '',
    );
  }

  static int _parseItems(dynamic items) {
    if (items == null) return 0;
    if (items is int) return items;
    if (items is String) {
      return int.tryParse(items) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': trackingEvents.map((event) => event.toJson()).toList(),
      'order_date': orderDate,
      'items': items,
      'invoice_no': invoiceNo,
      'tracking_no': trackingNo,
      'final_total': finalTotal,
    };
  }
}
