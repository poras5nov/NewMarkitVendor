import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/dimens.dart';

class CustomCardWidget extends StatelessWidget {
  CustomCardWidget({
    Key? key,
    this.cardColor,
    this.shadowColor,
    this.cardWidth,
    this.shadowElevation,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.child,
  }) : super(key: key);

  final Color? cardColor;
  final Color? shadowColor;
  final double? cardWidth;
  final double? shadowElevation;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final void Function()? onTap;
  final double? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          color: cardColor!,
          borderRadius: BorderRadius.circular(borderRadius ?? Dimens.six),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? AppColors.blackColor,
              blurRadius: shadowElevation ?? 6,
            ),
          ],
        ),
        width: cardWidth ?? Get.width,
        padding: padding ?? Dimens.edgeInsets0,
        margin: margin ?? Dimens.edgeInsets0,
        child: child ?? Container(),

      )
    ],
  );
}
