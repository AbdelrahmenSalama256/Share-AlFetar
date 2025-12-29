import 'package:flutter/material.dart';

//! OfferModel
class OfferModel {
  final int id;
  final String name;
  final String nameAr;
  final bool isActive;
  final String? image;
  final String imageUrl;

  OfferModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.isActive,
    this.image,
    required this.imageUrl,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      isActive: (json['is_active'] as int?) == 1,
      image: json['image'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  String getName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar' ? nameAr : name;
  }
}
