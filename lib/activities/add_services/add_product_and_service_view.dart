import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_vendor_app/activities/add_product/add_product_category.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';

import '../../utils/asset_constants.dart';
import '../../utils/utility.dart';

class AddProductAndServiceScreen extends StatefulWidget {
  bool isProductScreen = false;

  AddProductAndServiceScreen({Key? key, required this.isProductScreen})
      : super(key: key);
  @override
  _AddProductAndServiceScreenState createState() =>
      _AddProductAndServiceScreenState();
}

class _AddProductAndServiceScreenState
    extends State<AddProductAndServiceScreen> {
  @override
  void initState() {
    Utility.facebookEvent("add_product_screen");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isProductScreen
                    ? Container(
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
                      )
                    : Container(),
                Dimens.boxHeight15,
                Text(
                  NewMarkitVendorLocalizations.of(context)!
                      .find('which_thing_to_you_msg'),
                  style: Styles.loginPageTitleBlack,
                ),
                Dimens.boxHeight20,
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: AddProductCategoryScreen()));
                  },
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: AppColors.addNewProductColor),
                        color: AppColors.addNewProductColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: Dimens.seventyEight,
                          height: Dimens.seventyEight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: Container(
                            width: Dimens.sixty,
                            height: Dimens.sixty,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: SizedBox(
                              width: Dimens.fourtyFive,
                              height: Dimens.fourtyFive,
                              child: SvgPicture.asset(
                                AssetConstants.addProdcut,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('add_no_product'),
                              style: Styles.productTitle,
                            ),
                            Dimens.boxHeight5,
                            Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('give_a_minute_to_add_product'),
                                style: Styles.black12),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Dimens.boxHeight20,
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     height: 100,
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //         border: Border.all(
                //             width: 1, color: AppColors.addNewServiceColor),
                //         color: AppColors.addNewServiceColor,
                //         borderRadius: BorderRadius.circular(16)),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Container(
                //           width: Dimens.seventyEight,
                //           height: Dimens.seventyEight,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //               color: Colors.white.withOpacity(0.2),
                //               shape: BoxShape.circle),
                //           child: Container(
                //             width: Dimens.sixty,
                //             height: Dimens.sixty,
                //             alignment: Alignment.center,
                //             decoration: const BoxDecoration(
                //                 color: Colors.white, shape: BoxShape.circle),
                //             child: SizedBox(
                //               width: Dimens.fourtyFive,
                //               height: Dimens.fourtyFive,
                //               child: SvgPicture.asset(
                //                 AssetConstants.addService,
                //                 fit: BoxFit.contain,
                //               ),
                //             ),
                //           ),
                //         ),
                //         Column(
                //           mainAxisSize: MainAxisSize.min,
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               NewMarkitVendorLocalizations.of(context)!
                //                   .find('add_no_service'),
                //               style: Styles.serviceTitle,
                //             ),
                //             Dimens.boxHeight5,
                //             Text(
                //                 NewMarkitVendorLocalizations.of(context)!
                //                     .find('give_a_minute_to_add_service'),
                //                 style: Styles.black12),
                //           ],
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
