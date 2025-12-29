import 'package:cozy/core/constants/app_colors.dart';

import 'package:cozy/core/locale/app_loacl.dart';

import 'package:flutter/material.dart';

//! AppStepIndicator
class AppStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double circleRadius;
  final double lineHeight;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle? textStyle;
  final bool showStepText;

  const AppStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.circleRadius = 12,
    this.lineHeight = 2,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.border,
    this.textStyle,
    this.showStepText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {

            if (index % 2 == 0) {
              final stepNumber = (index ~/ 2) + 1;
              final isActive = stepNumber <= currentStep;
              final isCurrentStep = stepNumber == currentStep;

              return Container(
                width: circleRadius * 2,
                height: circleRadius * 2,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : inactiveColor,
                  shape: BoxShape.circle,
                  border: isCurrentStep
                      ? Border.all(color: activeColor, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    stepNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              final lineIndex = index ~/ 2;
              final isActive = lineIndex < currentStep - 1;

              return Expanded(
                child: Container(
                  height: lineHeight,
                  color: isActive ? activeColor : inactiveColor,
                ),
              );
            }
          }),
        ),
        if (showStepText) ...[
          const SizedBox(height: 8),
          Text(
            "${"step".tr(context)} $currentStep ${"of".tr(context)} $totalSteps",
            style: textStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ],
    );
  }
}
