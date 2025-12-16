import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/utils/notification_receiver.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../utils/notification_show.dart';
import '../../widgets/form_submit_widget.dart';
import '../build_your_profile/build_your_profile_view.dart';
import '../verify_otp/login_with_otp_view.dart';

class GetStartedView extends StatefulWidget {
  @override
  State<GetStartedView> createState() {
    return _GetStartedView();
  }
}

class _GetStartedView extends State<GetStartedView>
    implements NotificationInterface {
  @override
  void initState() {
    super.initState();
    NotificationShow.initPlatformState(this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SvgPicture.asset(
                  AssetConstants.getStartedBg,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Dimens.percentWidth(0.6),
                        height: Dimens.percentHeight(0.14),
                        child: SvgPicture.asset(
                          AssetConstants.loginLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        width: Dimens.percentWidth(0.8),
                        height: Dimens.percentHeight(0.27),
                        child: SvgPicture.asset(
                          AssetConstants.getStartedImg,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: Dimens.edgeInsets30,
                        child: Column(
                          children: [
                            Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('getStartedTitle'),
                                textAlign: TextAlign.center,
                                style: Styles.loginPageTitleBlack),
                            Dimens.boxHeight15,
                            Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('getStartedSubTitle'),
                                textAlign: TextAlign.center,
                                style: Styles.loginPageSubTitleGrey),
                            Dimens.boxHeight50,
                            FormSubmitWidget(
                              key: const Key('login-started-button'),
                              opacity: 1,
                              disableColor: AppColors.primaryColor,
                              padding: Dimens.edgeInsets0,
                              text: NewMarkitVendorLocalizations.of(context)!
                                  .find('login'),
                              textStyle: Styles.buttonWhiteTextStyle,
                              startColor: AppColors.primaryColor,
                              endColor: AppColors.primaryColor,
                              iconColor: Colors.white,
                              //iconPath: AssetConstants.arrowRight,
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: LoginView()));
                              },
                            ),
                            Dimens.boxHeight30,
                            FormSubmitWidget(
                              key: const Key('signup-started-button'),
                              opacity: 1,
                              disableColor: AppColors.primaryColor,
                              padding: Dimens.edgeInsets0,
                              text: NewMarkitVendorLocalizations.of(context)!
                                  .find('signUp'),
                              textStyle: Styles.buttonBlackTextStyle,
                              startColor: AppColors.lightGreyColor,
                              endColor: AppColors.lightGreyColor,
                              iconColor: Colors.white,
                              //iconPath: AssetConstants.arrowRight,
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: RegisterWithOTPView()));
                              },
                            ),
                            Dimens.boxHeight50,
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ));

  @override
  void onClick(id, type, requestId) {
    // TODO: implement onClick
  }

  @override
  void onMessageReceived(id, type) {
    // TODO: implement onMessageReceived
  }
}
