import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/create_business/set_up_business_profile.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/apiservice/key_string.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/utility.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../utils/asset_constants.dart';
import '../get_started/get_started_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashView> {
  var timer;
  bool isLogin = false;
  // LatLng? currentPostion;
  var profileData;

  @override
  void initState() {
    super.initState();
    // _getUserLocation();
    SharedPref.getLoginStatus(KeyConstant.LOGINSTATUS).then((value) {
      if (value == true) {
        isLogin = true;
      } else {
        isLogin = false;
      }
    });

    SharedPref.getProfileData().then((value) {
      if(value.isNotEmpty){
      profileData = json.decode(value);

      setState(() {});
      }
    });

    timer = Timer(const Duration(milliseconds: 2000), _navigateToLogin);
  }

  _navigateToLogin() {
    if (isLogin == true) {
      if (profileData['data']['businesses']['is_verified'].toString() ==
          "Yes") {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/TabScreen', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/VerifiedScreen', (Route<dynamic> route) => false);
      }
    } else {
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: GetStartedView()));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SvgPicture.asset(
              AssetConstants.splashBg,
              alignment: Alignment.center,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: SizedBox(
              key: const Key('splash-image'),
              width: Dimens.percentWidth(0.6),
              child: Image.asset(AssetConstants.splashLogo),
            ),
          )
        ],
      ));
}
