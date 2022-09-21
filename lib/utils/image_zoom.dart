import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:market_vendor_app/activities/create_business/set_up_business_profile.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/apiservice/key_string.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/utility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../utils/asset_constants.dart';

class ImageZoomView extends StatefulWidget {
  String? url;
  ImageZoomView({Key? key, this.url}) : super(key: key);

  @override
  State<ImageZoomView> createState() {
    return _ImageViewScreen();
  }
}

class _ImageViewScreen extends State<ImageZoomView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
        top: true,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.blackColor,
                    size: Dimens.twentyEight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: PinchZoom(
                    child: CachedNetworkImage(
                      imageUrl: widget.url!,
                      placeholder: (context, url) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.error,
                            color: Colors.black, size: 30),
                      ),
                    ),
                    resetDuration: const Duration(milliseconds: 100),
                    maxScale: 2.5,
                    onZoomStart: () {
                      print('Start zooming');
                    },
                    onZoomEnd: () {
                      print('Stop zooming');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
}
