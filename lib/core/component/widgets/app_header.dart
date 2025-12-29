import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum HeaderAlignment { left, center, right, spaceBetween }

enum HeaderStyle { standard, transparent, elevated }

//! AppHeader
class AppHeader extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showLogo;
  final String logoPath;
  final double? logoHeight;
  final double? logoWidth;
  final Color backgroundColor;
  final double? height;
  final EdgeInsetsGeometry padding;
  final HeaderAlignment alignment;
  final HeaderStyle style;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Widget? bottom;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final MainAxisAlignment leadingPosition;

  const AppHeader({
    super.key,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.showLogo = false,
    this.logoPath = 'assets/images/logo_text.png',
    this.logoHeight,
    this.logoWidth,
    this.backgroundColor = AppColors.white,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.alignment = HeaderAlignment.spaceBetween,
    this.style = HeaderStyle.standard,
    this.onBackPressed,
    this.centerTitle = false,
    this.bottom,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.leadingPosition = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";
    final canPop = Navigator.of(context).canPop();
    final shouldShowBackButton = showBackButton ||
        (automaticallyImplyLeading && canPop && leading == null);

    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (shouldShowBackButton) {
      leadingWidget = Container(

        width: 45.w,
        height: 45.h,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xffFAFAFA),
          shape: BoxShape.circle,
        ),
        child: IconButton(

          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Color(0xff444444)),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        ),
      );
    }

    Widget? titleContent = titleWidget ??
        (showLogo
            ? Image.asset(
                logoPath,
                height: logoHeight ?? 32.h,
                width: logoWidth ?? 118.w,
                fit: BoxFit.contain,
              )
            : (title != null
                ? Text(
                    title!,
                    style: titleStyle ??
                        TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                    overflow: TextOverflow.ellipsis,
                  )
                : null));

    BoxDecoration? decoration = style == HeaderStyle.elevated
        ? BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Color(0x80EEEEEE), // هذا يعادل #EEEEEE80 (50% opacity)
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: Offset(0, 0), // x = 0, y = 0
              ),
            ],
          )
        : BoxDecoration(
            color: style == HeaderStyle.transparent
                ? Colors.transparent
                : backgroundColor,
          );

    Widget content = Row(
      mainAxisAlignment: alignment == HeaderAlignment.center
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (leadingWidget != null && leadingPosition == MainAxisAlignment.start)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [leadingWidget],
          ),
        if (leadingPosition == MainAxisAlignment.center)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [leadingWidget ?? const SizedBox()],
            ),
          ),

        if (titleContent != null) ...[
          if (centerTitle == true) ...[
            Expanded(
              child: Row(
                children: [
                  Spacer(
                    flex: leadingWidget != null ? 2 : 1,
                  ),
                  Center(child: titleContent),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ] else if (isRTL) ...[
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: titleContent,
              ),
            ),
          ] else ...[
            Expanded(
              child: Align(
                alignment: centerTitle == true
                    ? Alignment.center
                    : isRTL
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: titleContent,
              ),
            ),
          ],
        ] else ...[
          const SizedBox.shrink(),
        ],
        if (actions != null && actions!.isNotEmpty)
          Row(mainAxisSize: MainAxisSize.min, children: actions!),
        if (leadingWidget != null && leadingPosition == MainAxisAlignment.end)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [leadingWidget],
          ),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          padding: padding,
          decoration: decoration,
          child: content,
        ),
        if (bottom != null) bottom!,
      ],
    );
  }
}
