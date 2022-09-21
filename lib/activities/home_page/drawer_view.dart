import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:market_vendor_app/activities/home_page/drawer_screen/common_page_screen.dart';
import 'package:market_vendor_app/activities/home_page/drawer_screen/rating_screen.dart';
import 'package:market_vendor_app/activities/home_page/view_all_prodcut.dart';
import 'package:market_vendor_app/activities/order_package/view_all_return_product.dart';
import 'package:market_vendor_app/apiservice/url_string.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/theme/dimens.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import '../order_package/all_retrun_orders.dart';
import 'model/profile_model.dart';

class DrawerViewScreen extends StatefulWidget {
  String totalOrder;
  String totalRevenue;
  ProfileModel? model;
  Function(int)? callBack;
  DrawerViewScreen(
      {required this.model,
      required this.callBack,
      required this.totalOrder,
      required this.totalRevenue});
  @override
  _DrawerViewScreenState createState() => _DrawerViewScreenState();
}

class _DrawerViewScreenState extends State<DrawerViewScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.model!.data!.businesses!.storeImages!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      child: Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 50,
                color: AppColors.redColor,
                child: SafeArea(
                  bottom: false,
                  top: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget
                                    .model!.data!.businesses!.storeImages!
                                    .contains(",")
                                ? widget.model!.data!.businesses!.storeImages!
                                    .split(",")[0]
                                : widget.model!.data!.businesses!.storeImages!,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 70.0,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: 70.0,
                              width: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                              ),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryColor)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              alignment: Alignment.center,
                              height: 70.0,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.rectangle,
                              ),
                              child: Image.asset(
                                AssetConstants.error,
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Dimens.ten,
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.model!.data!.businesses!.name!,
                                    style: Styles.boldWhite16,
                                  ),
                                  SizedBox(
                                    height: Dimens.five,
                                  ),
                                  Text(
                                    widget.model!.data!.phone!,
                                    style: Styles.boldWhite14,
                                  ),
                                  SizedBox(
                                    height: Dimens.five,
                                  ),
                                  Text(
                                    widget.model!.data!.email!,
                                    style: Styles.boldWhite14,
                                  ),
                                ],
                              ))
                        ],
                      ),
                      SizedBox(
                        height: Dimens.sixTeen,
                      ),
                      const DottedLine(
                        dashColor: Colors.white,
                      ),
                      SizedBox(
                        height: Dimens.sixTeen,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(5),
                            child: Row(children: [
                              SizedBox(
                                width: Dimens.five,
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Text(
                                  AppConstants.priceSign,
                                  style: Styles.boldBlack18,
                                ),
                              ),
                              SizedBox(
                                width: Dimens.five,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('earnings'),
                                      style: Styles.lightWhite14,
                                    ),
                                    Text(
                                      AppConstants.priceSign +
                                          widget.totalRevenue,
                                      style: Styles.boldWhite16,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: Dimens.five,
                              ),
                            ]),
                          )),
                          SizedBox(
                            width: Dimens.sixTeen,
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(5),
                            child: Row(children: [
                              SizedBox(
                                width: Dimens.five,
                              ),
                              Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.black,
                                    size: 18,
                                  )),
                              SizedBox(
                                width: Dimens.five,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('orders'),
                                      style: Styles.lightWhite14,
                                    ),
                                    Text(
                                      widget.totalOrder,
                                      style: Styles.boldWhite16,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: Dimens.five,
                              ),
                            ]),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: Dimens.sixTeen,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ViewAllProductScreen()))
                              .then((value) {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimens.sixTeen),
                          child: Row(children: [
                            SvgPicture.asset(
                              AssetConstants.product,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: Dimens.sixTeen,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('products'),
                              style: Styles.boldMenuText16,
                            ),
                          ]),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: AllReturnOrderScreen()))
                              .then((value) {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimens.sixTeen),
                          child: Row(children: [
                            SvgPicture.asset(
                              AssetConstants.order,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: Dimens.sixTeen,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('retrun/Exchange'),
                              style: Styles.boldMenuText16,
                            ),
                          ]),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.pop(context);

                      //     widget.callBack!(1);
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(Dimens.sixTeen),
                      //     child: Row(children: [
                      //       SvgPicture.asset(
                      //         AssetConstants.order,
                      //         width: 25,
                      //         height: 25,
                      //       ),
                      //       SizedBox(
                      //         width: Dimens.sixTeen,
                      //       ),
                      //       Text(
                      //         NewMarkitVendorLocalizations.of(context)!
                      //             .find('orders'),
                      //         style: Styles.boldMenuText16,
                      //       ),
                      //     ]),
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.all(Dimens.sixTeen),
                      //   child: Row(children: [
                      //     SvgPicture.asset(
                      //       AssetConstants.earning,
                      //       width: 15,
                      //       height: 20,
                      //     ),
                      //     SizedBox(
                      //       width: Dimens.sixTeen,
                      //     ),
                      //     Text(
                      //       NewMarkitVendorLocalizations.of(context)!
                      //           .find('myEarnings'),
                      //       style: Styles.boldMenuText16,
                      //     ),
                      //   ]),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.pop(context);

                      //     widget.callBack!(2);
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(Dimens.sixTeen),
                      //     child: Row(children: [
                      //       SvgPicture.asset(
                      //         AssetConstants.rating,
                      //         width: 25,
                      //         height: 25,
                      //       ),
                      //       SizedBox(
                      //         width: Dimens.sixTeen,
                      //       ),
                      //       Text(
                      //         NewMarkitVendorLocalizations.of(context)!
                      //             .find('ratingAndReviews'),
                      //         style: Styles.boldMenuText16,
                      //       ),
                      //     ]),
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.all(Dimens.sixTeen),
                      //   child: Row(children: [
                      //     SvgPicture.asset(
                      //       AssetConstants.address,
                      //       width: 25,
                      //       height: 25,
                      //     ),
                      //     SizedBox(
                      //       width: Dimens.sixTeen,
                      //     ),
                      //     Text(
                      //       NewMarkitVendorLocalizations.of(context)!
                      //           .find('myAddress'),
                      //       style: Styles.boldMenuText16,
                      //     ),
                      //   ]),
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: CommonViewScreen(
                                    title: NewMarkitVendorLocalizations.of(
                                            context)!
                                        .find('about'),
                                    url: UrlConstant.aboutPage,
                                  ))).then((value) {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(Dimens.sixTeen),
                          child: Row(children: [
                            SvgPicture.asset(
                              AssetConstants.about,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: Dimens.sixTeen,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('about'),
                              style: Styles.boldMenuText16,
                            ),
                          ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: CommonViewScreen(
                                    title: NewMarkitVendorLocalizations.of(
                                            context)!
                                        .find('helpSupport'),
                                    url: UrlConstant.helpSupport,
                                  ))).then((value) {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimens.sixTeen),
                          child: Row(children: [
                            SvgPicture.asset(
                              AssetConstants.help,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: Dimens.sixTeen,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('helpSupport'),
                              style: Styles.boldMenuText16,
                            ),
                          ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: CommonViewScreen(
                                    title: NewMarkitVendorLocalizations.of(
                                            context)!
                                        .find('termOfUse'),
                                    url: UrlConstant.termAndConditions,
                                  ))).then((value) {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(Dimens.sixTeen),
                          child: Row(children: [
                            SvgPicture.asset(
                              AssetConstants.term,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: Dimens.sixTeen,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('termOfUse'),
                              style: Styles.boldMenuText16,
                            ),
                          ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: CommonViewScreen(
                                    title: NewMarkitVendorLocalizations.of(
                                            context)!
                                        .find('privacyPolicy'),
                                    url: UrlConstant.privacyPolicy,
                                  ))).then((value) {});
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(Dimens.sixTeen),
                          child: Row(children: [
                            SvgPicture.asset(
                              AssetConstants.privacy,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: Dimens.sixTeen,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('privacyPolicy'),
                              style: Styles.boldMenuText16,
                            ),
                          ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          LaunchReview.launch(
                              androidAppId:
                                  'shri.complete.fitness.gymtrainingapp',
                              iOSAppId: 'com.example.rating');
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimens.sixTeen),
                          child: Row(children: [
                            SvgPicture.asset(
                              AssetConstants.rateus,
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(
                              width: Dimens.sixTeen,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('rateUs'),
                              style: Styles.boldMenuText16,
                            ),
                          ]),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: Dimens.ten,
              ),
              const DottedLine(
                dashColor: Colors.black,
              ),
              SizedBox(
                height: Dimens.ten,
              ),
              GestureDetector(
                onTap: () {
                  SharedPref.prefs!.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/LoginView', (Route<dynamic> route) => false);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  height: 60,
                  child: SafeArea(
                    bottom: true,
                    top: false,
                    child: Text(
                      NewMarkitVendorLocalizations.of(context)!.find('logout'),
                      style: Styles.boldMenuText16,
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
