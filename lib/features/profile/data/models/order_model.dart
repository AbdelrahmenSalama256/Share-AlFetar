import 'package:flutter/material.dart';

import 'order_details_item_model.dart';
import 'order_status.dart';
import 'tracking_event_model.dart';

//! OrderModel
class OrderModel {
  final String id;
  final String businessId;
  final String locationId;
  final String contactId;
  final String invoiceNo;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double totalBeforeTax;
  final double taxAmount;
  final double finalTotal;
  final OrderStatus status;
  final String? paymentStatus;
  final String? additionalNotes;
  final String? shippingAddress;
  final String? shippingStatus;
  final String? shippingDetails;
  final String? deliveredTo;
  final String? deliveryPerson;
  final double shippingCharges;
  final List<OrderItem> items;
  final List<TrackingEvent> trackingEvents; // New field for tracking events

  OrderModel({
    required this.id,
    required this.businessId,
    required this.locationId,
    required this.contactId,
    required this.invoiceNo,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.totalBeforeTax,
    required this.taxAmount,
    required this.finalTotal,
    required this.status,
    this.paymentStatus,
    this.additionalNotes,
    this.shippingAddress,
    this.shippingStatus,
    this.shippingDetails,
    this.deliveredTo,
    this.deliveryPerson,
    this.shippingCharges = 0.0,
    required this.items,
    this.trackingEvents = const [], // Default to empty list
  });


  DateTime get date => transactionDate;
  double get total => finalTotal;

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.orderd:
        return 'orderd';
      case OrderStatus.packed:
        return 'packed';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.grey;
      case OrderStatus.orderd:
        return Colors.blue;
      case OrderStatus.packed:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.blueAccent;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'location_id': locationId,
      'contact_id': contactId,
      'invoice_no': invoiceNo,
      'transaction_date': transactionDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_before_tax': totalBeforeTax,
      'tax_amount': taxAmount,
      'final_total': finalTotal,
      'status': status.toString().split('.').last,
      'payment_status': paymentStatus,
      'additional_notes': additionalNotes,
      'shipping_address': shippingAddress,
      'shipping_status': shippingStatus,
      'shipping_details': shippingDetails,
      'delivered_to': deliveredTo,
      'delivery_person': deliveryPerson,
      'shipping_charges': shippingCharges,
      'items': items.map((item) => item.toJson()).toList(),
      'tracking_events': trackingEvents.map((event) => event.toJson()).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    OrderStatus parseStatus(String? status) {
      switch (status?.toLowerCase()) {
        case 'orderd':
          return OrderStatus.orderd;
        case 'packed':
          return OrderStatus.packed;
        case 'shipped':
          return OrderStatus.shipped;
        case 'delivered':
          return OrderStatus.delivered;
        case 'cancelled':
          return OrderStatus.cancelled;
        case 'final':
          return OrderStatus.delivered;
        default:
          return OrderStatus.pending;
      }
    }

    final orderData = json['data'] is Map ? json['data'] : json;

    return OrderModel(
      id: orderData['id']?.toString() ?? '',
      businessId: orderData['business_id']?.toString() ?? '',
      locationId: orderData['location_id']?.toString() ?? '',
      contactId: orderData['contact_id']?.toString() ?? '',
      invoiceNo: orderData['invoice_no']?.toString() ?? '',
      transactionDate: DateTime.parse(
          orderData['transaction_date'] ?? DateTime.now().toString()),
      createdAt:
          DateTime.parse(orderData['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(orderData['updated_at'] ?? DateTime.now().toString()),
      totalBeforeTax:
          double.tryParse(orderData['total_before_tax']?.toString() ?? '0') ??
              0,
      taxAmount:
          double.tryParse(orderData['tax_amount']?.toString() ?? '0') ?? 0,
      finalTotal:
          double.tryParse(orderData['final_total']?.toString() ?? '0') ?? 0,
      status: parseStatus(orderData['shipping_status']?.toString()),
      paymentStatus: orderData['payment_status']?.toString(),
      additionalNotes: orderData['additional_notes']?.toString(),
      shippingAddress: orderData['shipping_address']?.toString(),
      shippingStatus: orderData['shipping_status']?.toString(),
      shippingDetails: orderData['shipping_details']?.toString(),
      deliveredTo: orderData['delivered_to']?.toString(),
      deliveryPerson: orderData['delivery_person']?.toString(),
      shippingCharges:
          double.tryParse(orderData['shipping_charges']?.toString() ?? '0') ??
              0,
      items: (orderData['sell_lines'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      trackingEvents: (orderData['tracking_events'] as List<dynamic>?)
              ?.map((event) => TrackingEvent.fromJson(event))
              .toList() ??
          [],
    );
  }

  static List<OrderModel> fromJsonList(Map<String, dynamic> json) {
    if (json['success'] == true && json['data'] is List) {
      return (json['data'] as List)
          .map((item) => OrderModel.fromJson(item))
          .toList();
    }
    return [];
  }
}
