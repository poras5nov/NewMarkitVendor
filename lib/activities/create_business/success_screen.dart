import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_vendor_app/activities/home_page/tab/verified_screen.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../widgets/form_submit_widget.dart';
import '../../utils/globals.dart' as globals;

class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SvgPicture.asset(
              AssetConstants.regsitrationCompleted,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  AssetConstants.registerCompleteImg,
                  width: 200,
                  height: 200,
                ),
                Dimens.boxHeight30,
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    NewMarkitVendorLocalizations.of(context)!
                        .find('requestSentTitle'),
                    style: Styles.loginPageTitleBlack2,
                  ),
                ),
                Dimens.boxHeight30,
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    NewMarkitVendorLocalizations.of(context)!
                        .find('requestSentSubTitle'),
                    style: Styles.lightBlue14,
                  ),
                ),
                Dimens.boxHeight40,
                FormSubmitWidget(
                  opacity: 1,
                  disableColor: AppColors.primaryColor,
                  padding: Dimens.edgeInsets0,
                  text: NewMarkitVendorLocalizations.of(context)!
                      .find('goToDashboard'),
                  textStyle: Styles.buttonWhiteTextStyle,
                  startColor: AppColors.primaryColor,
                  endColor: AppColors.primaryColor,
                  iconColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/VerifiedScreen', (Route<dynamic> route) => false);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
