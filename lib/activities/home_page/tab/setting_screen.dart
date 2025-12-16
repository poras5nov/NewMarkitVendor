import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/edit_profile/EditProfile.dart';
import 'package:market_vendor_app/activities/edit_profile/change_password.dart';
import 'package:market_vendor_app/activities/edit_profile/document_show.dart';
import 'package:market_vendor_app/activities/edit_profile/edit_address.dart';
import 'package:market_vendor_app/activities/edit_profile/working_hours.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../theme/dimens.dart';
import '../../../theme/styles.dart';
import '../../../utils/asset_constants.dart';
import '../../../utils/notification_receiver.dart';
import '../../../utils/notification_show.dart';
import '../../../utils/utility.dart';
import '../../../widgets/color_range.dart';
import '../../edit_profile/edit_business.dart';
import '../../order_package/my_orders_details.dart';
import '../../order_package/return_order_details.dart';
import '../model/profile_model.dart';

class MyAccountSettingScreen extends StatefulWidget {
  Function(int)? callBack;
  MyAccountSettingScreen({required this.callBack});
  @override
  _MyAccountSettingScreenState createState() => _MyAccountSettingScreenState();
}

class _MyAccountSettingScreenState extends State<MyAccountSettingScreen>
    implements ApiInterface, NotificationInterface {
  var token;
  bool isLoader = true;
  var profileData;
  ProfileModel model = ProfileModel();

  @override
  void initState() {
    NotificationShow.initPlatformState(this);
    Utility.facebookEvent("setting_screen");

    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);

      print(model.data!.documents!.length);

      setState(() {});
    });
    getToken();
    super.initState();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
            SafeArea(
              top: true,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     widget.callBack!(0);
                            //   },
                            //   child: const Icon(
                            //     Icons.arrow_back,
                            //     size: 30,
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // const SizedBox(
                            //   width: 5,
                            // ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('myAccount'),
                              style: Styles.boldBlack16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimens.sixTeen,
                                right: Dimens.sixTeen,
                                top: Dimens.sixTeen),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: model.data == null
                                      ? ""
                                      : model.data!.profile == null
                                          ? ""
                                          : model.data!.profile!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 80.0,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    height: 80.0,
                                    width: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryColor)),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    alignment: Alignment.center,
                                    height: 80.0,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.perm_identity,
                                      size: 60,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Dimens.ten,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          model.data == null
                                              ? ""
                                              : model.data!.name!,
                                          style: Styles.boldBlack14,
                                        ),
                                        SizedBox(
                                          height: Dimens.five,
                                        ),
                                        Text(
                                          model.data == null
                                              ? ""
                                              : model.data!.email!,
                                          style: Styles.grey14Medium,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          //  ColorPicker(width: 300)
                          SizedBox(
                            height: Dimens.sixTeen,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                left: Dimens.sixTeen, right: Dimens.sixTeen),
                            height: 80,
                            decoration: BoxDecoration(
                                color:
                                    AppColors.upgradeBoxColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  left: Dimens.sixTeen, right: Dimens.sixTeen),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      NewMarkitVendorLocalizations.of(context)!
                                          .find('yourBusinessType'),
                                      style: Styles.blackMedium14,
                                    ),
                                    SizedBox(
                                      height: Dimens.ten,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Retailer",
                                          style: Styles.boldBlack16,
                                        ),
                                        // Text(
                                        //   NewMarkitVendorLocalizations.of(
                                        //           context)!
                                        //       .find('upgrade'),
                                        //   style: Styles.redMedium16,
                                        // ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: Dimens.ten,
                          ),
                          Container(
                            padding: EdgeInsets.all(Dimens.sixTeen),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: EditProfileView()))
                                    .then((value) {
                                  SharedPref.getProfileData().then((value) {
                                    profileData = json.decode(value);
                                    model = ProfileModel.fromJson(profileData);

                                    print(model.data!.documents!.length);

                                    setState(() {});
                                  });
                                });
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      AssetConstants.userRed,
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: Dimens.sixTeen,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NewMarkitVendorLocalizations.of(
                                                    context)!
                                                .find('personalInformations'),
                                            style: Styles.boldMenuText14,
                                          ),
                                          SizedBox(
                                            height: Dimens.sixTeen,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: Dimens.ten,
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: EditBusinessProfile()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: Dimens.sixTeen,
                                  right: Dimens.sixTeen,
                                  bottom: Dimens.sixTeen),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      AssetConstants.business,
                                      width: 20,
                                      height: 20,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(
                                      width: Dimens.sixTeen,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NewMarkitVendorLocalizations.of(
                                                    context)!
                                                .find('businessInformations'),
                                            style: Styles.boldMenuText14,
                                          ),
                                          SizedBox(
                                            height: Dimens.sixTeen,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: Dimens.ten,
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: EditWorkingHoursPage()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: Dimens.sixTeen,
                                  right: Dimens.sixTeen,
                                  bottom: Dimens.sixTeen),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      AssetConstants.hours,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: Dimens.fourteen,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NewMarkitVendorLocalizations.of(
                                                    context)!
                                                .find('businessWorkingHours'),
                                            style: Styles.boldMenuText14,
                                          ),
                                          SizedBox(
                                            height: Dimens.sixTeen,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: Dimens.ten,
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: EditAddressDetails()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: Dimens.sixTeen,
                                  right: Dimens.sixTeen,
                                  bottom: Dimens.sixTeen),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      AssetConstants.address,
                                      width: 25,
                                      height: 25,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(
                                      width: Dimens.fourteen,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NewMarkitVendorLocalizations.of(
                                                    context)!
                                                .find('businessAddress'),
                                            style: Styles.boldMenuText14,
                                          ),
                                          SizedBox(
                                            height: Dimens.sixTeen,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: Dimens.ten,
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: DocumentView()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: Dimens.sixTeen,
                                  right: Dimens.sixTeen,
                                  bottom: Dimens.sixTeen),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      AssetConstants.document,
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: Dimens.sixTeen,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NewMarkitVendorLocalizations.of(
                                                    context)!
                                                .find('myDocument'),
                                            style: Styles.boldMenuText14,
                                          ),
                                          SizedBox(
                                            height: Dimens.sixTeen,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          // SizedBox(
                          //   height: Dimens.ten,
                          // ),

                          // Container(
                          //   padding: EdgeInsets.only(
                          //       left: Dimens.sixTeen,
                          //       right: Dimens.sixTeen,
                          //       bottom: Dimens.sixTeen),
                          //   child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         SvgPicture.asset(
                          //           AssetConstants.product,
                          //           width: 25,
                          //           height: 25,
                          //           color: AppColors.primaryColor,
                          //         ),
                          //         SizedBox(
                          //           width: Dimens.sixTeen,
                          //         ),
                          //         Expanded(
                          //           flex: 1,
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.start,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Text(
                          //                 NewMarkitVendorLocalizations.of(
                          //                         context)!
                          //                     .find('manageCategory'),
                          //                 style: Styles.boldMenuText14,
                          //               ),
                          //               SizedBox(
                          //                 height: Dimens.sixTeen,
                          //               ),
                          //               Container(
                          //                 width: double.infinity,
                          //                 height: 1,
                          //                 color: Colors.grey.withOpacity(0.3),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ]),
                          // ),
                          // SizedBox(
                          //   height: Dimens.ten,
                          // ),

                          // Container(
                          //   padding: EdgeInsets.only(
                          //       left: Dimens.sixTeen,
                          //       right: Dimens.sixTeen,
                          //       bottom: Dimens.sixTeen),
                          //   child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         SvgPicture.asset(
                          //           AssetConstants.earning,
                          //           width: 20,
                          //           height: 20,
                          //           color: AppColors.primaryColor,
                          //         ),
                          //         SizedBox(
                          //           width: Dimens.sixTeen,
                          //         ),
                          //         Expanded(
                          //           flex: 1,
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.start,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Text(
                          //                 NewMarkitVendorLocalizations.of(
                          //                         context)!
                          //                     .find('mySubscriptions'),
                          //                 style: Styles.boldMenuText14,
                          //               ),
                          //               SizedBox(
                          //                 height: Dimens.sixTeen,
                          //               ),
                          //               Container(
                          //                 width: double.infinity,
                          //                 height: 1,
                          //                 color: Colors.grey.withOpacity(0.3),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ]),
                          // ),
                          SizedBox(
                            height: Dimens.ten,
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: ChangePasswordView()))
                                  .then((value) {
                                SharedPref.getProfileData().then((value) {
                                  profileData = json.decode(value);
                                  model = ProfileModel.fromJson(profileData);

                                  print(model.data!.documents!.length);

                                  setState(() {});
                                });
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: Dimens.sixTeen,
                                  right: Dimens.sixTeen,
                                  bottom: Dimens.sixTeen),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      AssetConstants.change,
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(
                                      width: Dimens.sixTeen,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            NewMarkitVendorLocalizations.of(
                                                    context)!
                                                .find('changePassword'),
                                            style: Styles.boldMenuText14,
                                          ),
                                          SizedBox(
                                            height: Dimens.sixTeen,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey.withOpacity(0.3),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: Dimens.ten,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onFailure(message) {
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {}

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }

  callScreenAfterNotificationClick(var id, var type, var requestId) {
    if (type == "new") {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: OrderDetailsScreen(
                id: id,
              )));
    } else {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: RetrunOrderDetailsScreen(
                id: id,
                rId: requestId,
              )));
    }
    SharedPref.setOrderID("");
    SharedPref.setOrderType("");
    SharedPref.setRequestOrderId("");
  }

  @override
  void onClick(id, type, requestId) {
    callScreenAfterNotificationClick(id, type, requestId);
  }

  @override
  void onMessageReceived(id, type) {
    print(id);
  }
}
