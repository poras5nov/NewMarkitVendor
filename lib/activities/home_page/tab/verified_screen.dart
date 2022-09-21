import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/home_page/tab/document_edit/adhar_card_document.dart';
import 'package:market_vendor_app/activities/home_page/tab/document_edit/gst_document.dart';
import 'package:market_vendor_app/activities/home_page/tab/document_edit/pan_card_document.dart';
import 'package:market_vendor_app/activities/home_page/tab/document_edit/signature_document.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert' show json, jsonDecode, jsonEncode;

import '../../../theme/dimens.dart';
import '../../../theme/styles.dart';
import '../../../utils/asset_constants.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/strings/app_constants.dart';
import '../../../widgets/form_submit_widget.dart';
import '../model/DocumentModel.dart';
import '../model/profile_model.dart';
import 'document_edit/cancel_check.dart';

class VerifiedScreen extends StatefulWidget {
  @override
  _VerifiedScreenState createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen>
    implements ApiInterface {
  var profileData;
  ProfileModel model = ProfileModel();
  var token;
  bool isReject = false;
  bool isLoader = true;
  @override
  void initState() {
    super.initState();
    getProfile();
    getToken();
  }

  getProfile() {
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);
      updateView();
    });
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      print(token);

      ApiCall.getVendorDetails(token, this, context);
    });
  }

  updateView() {
    for (int i = 0; i < model.data!.documents!.length; i++) {
      if (model.data!.documents![i].status == "Decline") {
        isReject = true;
        break;
      } else {
        isReject = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.topColor,
              Colors.white,
            ],
          )),
          child: SafeArea(
            top: true,
            child: isLoader
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, top: 20),
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: model.data == null
                                          ? ""
                                          : model.data!.profile == null
                                              ? ""
                                              : model.data!.profile!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 40.0,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        height: 40.0,
                                        width: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          child:
                                              const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          AppColors
                                                              .primaryColor)),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        alignment: Alignment.center,
                                        height: 40.0,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.supervised_user_circle,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    model.data != null
                                        ? Text(
                                            "Hi,${model.data!.name}",
                                            style: Styles.loginPageTitleBlack2,
                                          )
                                        : Container(),
                                  ],
                                ),
                                // const Icon(
                                //   Icons.notifications_none,
                                //   size: 30,
                                // ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AssetConstants.waiting,
                                ),
                                isReject == false
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Your Verification is\nUnder Process.",
                                            textAlign: TextAlign.center,
                                            style: Styles.loginPageTitleBlack,
                                          ),
                                          Dimens.boxHeight15,
                                          Text(
                                              "Please wait until we verify your business\ndetails. For more please email us on\ncustomercare@newmarketkart.com or contact our\nsupport on (+91) 903-435-7394",
                                              textAlign: TextAlign.center,
                                              style:
                                                  Styles.loginPageSubTitleGrey),
                                        ],
                                      )
                                    : Expanded(
                                        flex: 1,
                                        child: ListView(
                                          children: [
                                            Text(
                                              "Your Account has been\nRejected!",
                                              textAlign: TextAlign.center,
                                              style: Styles.loginPageTitleBlack,
                                            ),
                                            Dimens.boxHeight15,
                                            Text(
                                                "Please check below documents is not verifed.",
                                                textAlign: TextAlign.center,
                                                style: Styles
                                                    .loginPageSubTitleGrey),
                                            Dimens.boxHeight10,
                                            Wrap(
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        model.data!.documents!
                                                            .length;
                                                    i++)
                                                  model.data!.documents![i]
                                                              .status ==
                                                          "Decline"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            if (model
                                                                    .data!
                                                                    .documents![
                                                                        i]
                                                                    .name ==
                                                                "PAN IMAGE") {
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          PanCardDocument(
                                                                        v: i,
                                                                        id: model
                                                                            .data!
                                                                            .documents![i]
                                                                            .id
                                                                            .toString(),
                                                                      ))).then(
                                                                  (value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    model
                                                                        .data!
                                                                        .documents![
                                                                            value]
                                                                        .status = "Pending";
                                                                    updateView();
                                                                  });
                                                                }
                                                              });
                                                            } else if (model
                                                                    .data!
                                                                    .documents![
                                                                        i]
                                                                    .name ==
                                                                "AADHAAR IMAGE") {
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          AdharCardCardDocument(
                                                                        v: i,
                                                                        id: model
                                                                            .data!
                                                                            .documents![i]
                                                                            .id
                                                                            .toString(),
                                                                      ))).then(
                                                                  (value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    model
                                                                        .data!
                                                                        .documents![
                                                                            value]
                                                                        .status = "Pending";
                                                                    updateView();
                                                                  });
                                                                }
                                                              });
                                                            } else if (model
                                                                    .data!
                                                                    .documents![
                                                                        i]
                                                                    .name ==
                                                                "GST IMAGE") {
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          GSTDocument(
                                                                        v: i,
                                                                        id: model
                                                                            .data!
                                                                            .documents![i]
                                                                            .id
                                                                            .toString(),
                                                                      ))).then(
                                                                  (value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    model
                                                                        .data!
                                                                        .documents![
                                                                            value]
                                                                        .status = "Pending";
                                                                    updateView();
                                                                  });
                                                                }
                                                              });
                                                            } else if (model
                                                                    .data!
                                                                    .documents![
                                                                        i]
                                                                    .name ==
                                                                "SIGNATURE IMAGE") {
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          SignatureDocument(
                                                                        v: i,
                                                                        id: model
                                                                            .data!
                                                                            .documents![i]
                                                                            .id
                                                                            .toString(),
                                                                      ))).then(
                                                                  (value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    model
                                                                        .data!
                                                                        .documents![
                                                                            value]
                                                                        .status = "Pending";
                                                                    updateView();
                                                                  });
                                                                }
                                                              });
                                                            } else {
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          CheckDocument(
                                                                        v: i,
                                                                        id: model
                                                                            .data!
                                                                            .documents![i]
                                                                            .id
                                                                            .toString(),
                                                                      ))).then(
                                                                  (value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    model
                                                                        .data!
                                                                        .documents![
                                                                            value]
                                                                        .status = "Pending";
                                                                    updateView();
                                                                  });
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 16,
                                                                    right: 16,
                                                                    top: 16),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  offset:
                                                                      const Offset(
                                                                    5.0,
                                                                    5.0,
                                                                  ),
                                                                  blurRadius:
                                                                      5.0,
                                                                  spreadRadius:
                                                                      2.0,
                                                                ), //BoxShadow
                                                                const BoxShadow(
                                                                  color: Colors
                                                                      .white,
                                                                  offset:
                                                                      Offset(
                                                                          0.0,
                                                                          0.0),
                                                                  blurRadius:
                                                                      0.0,
                                                                  spreadRadius:
                                                                      0.0,
                                                                ), //BoxShadow
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            model.data!.documents![i].name!,
                                                                            textAlign: TextAlign.center,
                                                                            style: Styles.boldBlack14),
                                                                        Dimens
                                                                            .boxHeight5,
                                                                        Text(
                                                                          "Reason:- " +
                                                                              model.data!.documents![i].rejectReason!,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              Styles.redMedium14,
                                                                          maxLines:
                                                                              2,
                                                                        ),
                                                                      ]),
                                                                ),
                                                                const Icon(
                                                                    Icons
                                                                        .chevron_right_sharp,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 30),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Container()
                                              ],
                                            ),
                                            Dimens.boxHeight20,
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void onFailure(message) {
    isLoader = false;
    setState(() {});
  }

  @override
  void onSuccess(data) {
    print(data);
    var d = jsonEncode(data);
    SharedPref.saveProfileData(d);
    if (data['data']['businesses']['is_verified'].toString() == "Yes") {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/TabScreen', (Route<dynamic> route) => false);
    } else {
      model = ProfileModel.fromJson(data);
      updateView();
    }
    isLoader = false;
    setState(() {});
  }

  @override
  void onTokenExpired() {
    isLoader = false;
    setState(() {});
  }
}
