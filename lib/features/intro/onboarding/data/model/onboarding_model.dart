import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';

//! OnboardingModel
class OnboardingModel {
  final String imagePath;
  final String titleKey;
  final String descriptionKey;

  OnboardingModel({
    required this.imagePath,
    required this.titleKey,
    required this.descriptionKey,
  });

  String title(BuildContext context) => titleKey.tr(context);
  String description(BuildContext context) => descriptionKey.tr(context);
}

List<OnboardingModel> onboardingContents = [
  OnboardingModel(
    imagePath:
        "https://images.unsplash.com/photo-1445205170230-053b83016050?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    titleKey: "onboarding_title1",
    descriptionKey: "onboarding_desc1",
  ),
  OnboardingModel(
    imagePath:
        "https://images.unsplash.com/photo-1555529669-2269763671c0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    titleKey: "onboarding_title2",
    descriptionKey: "onboarding_desc2",
  ),
  OnboardingModel(
    imagePath:
        "https://images.unsplash.com/photo-1483985988355-763728e1935b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    titleKey: "onboarding_title3",
    descriptionKey: "onboarding_desc3",
  ),
];
