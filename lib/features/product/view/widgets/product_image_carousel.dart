import 'package:cozy/core/constants/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';

//! ProductImageCarousel
class ProductImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ProductImageCarousel({super.key, required this.imageUrls});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

//! _ProductImageCarouselState
class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.imageUrls.length,
      onPageChanged: (index) => setState(() => currentImageIndex = index),
      itemBuilder: (context, index) => CustomCachedImage(
        imageUrl: widget.imageUrls[index],
        fit: BoxFit.cover,
        h: double.infinity,
        w: double.infinity,
      ),
    );
  }
}
