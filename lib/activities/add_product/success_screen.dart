import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../../widgets/form_submit_widget.dart';
import '../../utils/globals.dart' as globals;
import 'model/addproduct.dart';

class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  AddProductModel newData = AddProductModel();
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
            height: 300,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.topColor,
                Colors.white,
              ],
            )),
          ),
          Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  AssetConstants.watingProdcut,
                  width: 200,
                  height: 200,
                ),
                Dimens.boxHeight30,
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Text(
                    NewMarkitVendorLocalizations.of(context)!
                        .find('after_product_upload_success'),
                    style: Styles.loginPageTitleBlack2,
                  ),
                ),
                Dimens.boxHeight30,
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    NewMarkitVendorLocalizations.of(context)!
                        .find('after_product_upload_success_msg'),
                    style: Styles.lightBlue14,
                  ),
                ),
                Dimens.boxHeight40,
                FormSubmitWidget(
                  opacity: 1,
                  disableColor: AppColors.primaryColor,
                  padding: Dimens.edgeInsets0,
                  text: NewMarkitVendorLocalizations.of(context)!
                      .find('continue_add_product_image'),
                  textStyle: Styles.buttonWhiteTextStyle,
                  startColor: AppColors.primaryColor,
                  endColor: AppColors.primaryColor,
                  iconColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Dimens.boxHeight20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
