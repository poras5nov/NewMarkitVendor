import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/dimens.dart';

class CustomImageWidget extends StatelessWidget {
  CustomImageWidget({
    Key? key,
    this.iconPath,
    this.iconColor,
    this.iconWidth,
    this.padding,
    this.onTap,
    this.iconHeight,
  }) : super(key: key);

  final String? iconPath;
  final Color? iconColor;
  final double? iconWidth;
  final EdgeInsets? padding;
  final void Function()? onTap;
  final double? iconHeight;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap!,
    child: Container(
      height: iconHeight ?? Dimens.twentyFour,
      padding: padding ?? Dimens.edgeInsets0,
      width: iconWidth ?? Dimens.twentyFour,
      child: iconPath!.contains('.svg')
          ? SvgPicture.asset(
        iconPath!,
        height: iconHeight ?? Dimens.twentyFour,
        width: iconWidth ?? Dimens.twentyFour,
        color: iconColor ?? AppColors.iconDefaultColor,
      )
          : Image.asset(iconPath!,
          height: iconHeight ?? Dimens.twentyFour,
          width: iconWidth ?? Dimens.twentyFour,
          color: iconColor ?? AppColors.iconDefaultColor),
    ),
  );
}
