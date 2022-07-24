import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  CachedNetworkImageWidget({
    Key? key,
    this.imageUrl,
    this.radius,
    this.width,
    this.height,
    this.onTap,
    this.borderWidth,
    this.borderColor,
    this.phImagePath,
    this.errorImagePath,
    this.isShowPlaceholderImage
  }) : super(key: key);

  final String? imageUrl;
  final double? radius;
  final double? width;
  final double? height;
  final double? borderWidth;
  final Color? borderColor;
  final String? phImagePath;
  final String? errorImagePath;
  final bool? isShowPlaceholderImage;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius!)),
            border: Border.all(
              width: borderWidth ?? 0.0,
              color: borderColor ?? Colors.transparent,
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => !isShowPlaceholderImage! ? Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius!)),
            color: AppColors.lightGreyColor
          ),
        ) : Container(
          width: width,
          height: height,
          child: SvgPicture.asset(
            errorImagePath!,
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius!)),
            border: Border.all(
              width: borderWidth ?? 0.0,
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
        errorWidget: (context, url, dynamic error) => !isShowPlaceholderImage! ? Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radius!)),
              color: AppColors.lightGreyColor
          ),
        ) : Container(
          width: width,
          height: height,
          child: SvgPicture.asset(
            errorImagePath!,
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius!)),
            border: Border.all(
              width: borderWidth ?? 0.0,
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
      );
}
