import 'package:flutter/material.dart';

//! LoadingOverlay
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color barrierColor;

  const LoadingOverlay({super.key, required this.child, required this.isLoading, this.barrierColor = const Color(0x66000000)});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ColoredBox(
            color: barrierColor,
            child: const Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

