import 'package:flutter/material.dart';

//! PaymentMethod
class PaymentMethod {
  final String id;
  final String type;
  final String details;
  final IconData icon;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.details,
    required this.icon,
    required this.isDefault,
  });
}
