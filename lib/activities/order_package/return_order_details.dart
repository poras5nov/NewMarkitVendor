import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/order_package/model/change_status_list_model.dart';
import 'package:market_vendor_app/activities/order_package/picked_up.dart';
import 'package:market_vendor_app/activities/order_package/return_decline_order.dart';

import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/theme/dimens.dart';
import 'package:market_vendor_app/utils/asset_constants.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';
import 'package:page_transition/page_transition.dart';

import '../../../theme/styles.dart';
import '../../apiservice/api_call.dart';
import '../../utils/image_zoom.dart';
import '../../utils/utility.dart';
import '../../widgets/form_submit_widget.dart';
import 'model/order_details.dart';
import 'model/return_order_details.dart';
import 'model/return_status.dart';

class RetrunOrderDetailsScreen extends StatefulWidget {
  int? id;
  int? rId;
  RetrunOrderDetailsScreen({required this.id, required this.rId});

  @override
  _RetrunOrderDetailsScreenState createState() =>
      _RetrunOrderDetailsScreenState();
}

class _RetrunOrderDetailsScreenState extends State<RetrunOrderDetailsScreen>
    implements ApiInterface {
  ReturnOrdersDetails details = ReturnOrdersDetails();
  Data? model = Data();
  ChangeStatusList listModel = ChangeStatusList();

  var token;
  bool isScreenLoader = false;
  var orderIndex;

  bool isLoader = false;
  String whichApiCall = "details";
  List<String> statusChange = ["Processing", "Picked up", "Delivered"];
  List<String> statusReturn = ["Processing", "Picked up"];

  List<ReturnStatusData> orderType = [];
  List<ReturnStatusData> orderRetrunType = [];

  List<ReturnStatusData> orderTypeModel = [];

  double? subTotalForRturn;
  double? subTotalForGST;
  double? total;

  @override
  void initState() {
    getToken();
    for (int i = 0; i < statusChange.length; i++) {
      ReturnStatusData model = ReturnStatusData();
      model.name = statusChange[i];
      model.isSelected = false;
      orderType.add(model);
    }
    for (int i = 0; i < statusReturn.length; i++) {
      ReturnStatusData model = ReturnStatusData();
      model.name = statusReturn[i];
      model.isSelected = false;
      orderRetrunType.add(model);
    }

    super.initState();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      setState(() {
        isScreenLoader = true;
      });
      print("${widget.id}  ${widget.rId.toString()}");

      ApiCall.returnOrderDetails(
          widget.id.toString(), widget.rId.toString(), token, this, context);
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
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70, left: 16, right: 16),
                    child: isScreenLoader
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : ListView(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.menuTextColor
                                                .withOpacity(0.4)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 110,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: model!
                                                                    .returnRequest!
                                                                    .status! ==
                                                                "Cancelled"
                                                            ? AppColors
                                                                .primaryColor
                                                            : (model!.returnRequest!
                                                                            .status! ==
                                                                        "Delivered" ||
                                                                    model!.returnRequest!
                                                                            .status ==
                                                                        "Refund_initiated")
                                                                ? AppColors
                                                                    .greenColor
                                                                : AppColors
                                                                    .yellowColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 5.0,
                                                          ),
                                                        ]),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: Dimens.five,
                                                        ),
                                                        Text(
                                                          model!.returnRequest!
                                                              .status!,
                                                          style: Styles
                                                              .whiteLight12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "Type:",
                                                        style: Styles
                                                            .grey14Regular,
                                                      ),
                                                      Text(
                                                        model!
                                                            .returnRequest!
                                                            .requestType!
                                                            .capitalizeFirst!,
                                                        style: Styles
                                                            .blackMedium14,
                                                      ),
                                                      SizedBox(
                                                        width: Dimens.ten,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                NewMarkitVendorLocalizations.of(
                                                        context)!
                                                    .find('orderNo'),
                                                style: Styles.grey14Regular,
                                              ),
                                              Text(
                                                "#${model!.orderNumber}",
                                                style: Styles.boldBlack14,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: Dimens.ten,
                                          ),
                                          Text(
                                            model!.returnRequest!.createdAt!
                                                .split("T")[0],
                                            style: Styles.grey14Regular,
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    NewMarkitVendorLocalizations.of(context)!
                                        .find('orderStatus'),
                                    style: Styles.grey14Regular,
                                  ),
                                  model!.returnRequest!.requestType != "Pending"
                                      ? Text(
                                          model!.returnRequest!.updatedAt!
                                              .split("T")[0],
                                          style: Styles.grey14Regular,
                                        )
                                      : Container()
                                ],
                              ),
                              SizedBox(
                                height: Dimens.ten,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    model!.returnRequest!.status!,
                                    style: Styles.grey16Regular,
                                  ),
                                  (model!.returnRequest!.status ==
                                              "Delivered" ||
                                          model!.returnRequest!.status ==
                                              "Pending" ||
                                          model!.returnRequest!.status ==
                                              "Cancelled" ||
                                          model!.returnRequest!.status ==
                                              "Refund_initiated")
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            orderTypeBottomSheet(context);
                                          },
                                          child: Text(
                                            "Change Status",
                                            style: Styles.redMedium14,
                                          ),
                                        )
                                ],
                              ),
                              model!.returnRequest!.requestType == "change"
                                  ? Container()
                                  : model!.returnRequest!
                                                  .reject_reason_vendor ==
                                              "null" ||
                                          model!.returnRequest!
                                                  .reject_reason_vendor ==
                                              ""
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: Dimens.ten,
                                            ),
                                            Container(
                                              height: 1,
                                              color: AppColors.greyColor
                                                  .withOpacity(0.2),
                                            ),
                                            SizedBox(
                                              height: Dimens.sixTeen,
                                            ),
                                            Text(
                                              "Cancel By Vendor ",
                                              style: Styles.blackMedium14,
                                              maxLines: 3,
                                            ),
                                            SizedBox(
                                              height: Dimens.ten,
                                            ),
                                            Text(
                                              "Descriptions:- " +
                                                  model!.returnRequest!
                                                      .reject_reason_vendor
                                                      .toString(),
                                              style: Styles.redMedium14,
                                              maxLines: 3,
                                            )
                                          ],
                                        ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              Container(
                                height: 1,
                                color: AppColors.greyColor.withOpacity(0.2),
                              ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('deliveredTo'),
                                style: Styles.grey14Regular,
                              ),
                              SizedBox(
                                height: Dimens.ten,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.home,
                                    color: AppColors.greyColor,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    model!.user!.name!,
                                    style: Styles.grey16Regular,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimens.ten,
                              ),
                              Text(
                                "${model!.addressJson!.addressLine!} ${model!.addressJson!.province!} ${model!.addressJson!.city!}, ${model!.addressJson!.postalCode!}",
                                style: Styles.grey14Regular,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              Container(
                                height: 1,
                                color: AppColors.greyColor.withOpacity(0.2),
                              ),
                              model!.returnRequest!.requestType == "return"
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('returnSummary'),
                                          style: Styles.grey14Regular,
                                        ),
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: Dimens.twentyFive,
                                    ),
                              Wrap(
                                children: [
                                  for (int i = 0;
                                      i <
                                          model!.returnRequest!.returnProducts!
                                              .length;
                                      i++)
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: model!
                                                              .returnRequest!
                                                              .returnProducts![
                                                                  i]
                                                              .variationJson!
                                                              .defaultVariationImage ==
                                                          null
                                                      ? ""
                                                      : model!
                                                          .returnRequest!
                                                          .returnProducts![i]
                                                          .variationJson!
                                                          .defaultVariationImage!,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    height: 60.0,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 60.0,
                                                    width: 60,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      child: const CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  AppColors
                                                                      .primaryColor)),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    alignment: Alignment.center,
                                                    height: 60.0,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Image.asset(
                                                      AssetConstants.error,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Dimens.ten,
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        model!
                                                            .returnRequest!
                                                            .returnProducts![i]
                                                            .productJson!
                                                            .name!,
                                                        style: Styles
                                                            .blackMedium14,
                                                        maxLines: 2,
                                                      ),
                                                      SizedBox(
                                                        height: Dimens.five,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "${model!.returnRequest!.returnProducts![i].quantity} * ",
                                                            style: Styles
                                                                .blackMedium14,
                                                            maxLines: 2,
                                                          ),
                                                          Text(
                                                            "${AppConstants.priceSign}${model!.returnRequest!.returnProducts![i].amount!}",
                                                            style: Styles
                                                                .blackMedium14,
                                                            maxLines: 2,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ]),
                                          SizedBox(
                                            height: Dimens.ten,
                                          )
                                        ],
                                      ),
                                    )
                                ],
                              ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              model!.returnRequest!.requestType == "return"
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('subTotal'),
                                              style: Styles.grey14Regular,
                                              maxLines: 2,
                                            ),
                                            Text(
                                              "${AppConstants.priceSign}${getSubTotal().round()}",
                                              style: Styles.grey14Regular,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        // SizedBox(
                                        //   height: Dimens.ten,
                                        // ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text(
                                        //       NewMarkitVendorLocalizations.of(
                                        //               context)!
                                        //           .find('deliveryCharges'),
                                        //       style: Styles.grey14Regular,
                                        //       maxLines: 2,
                                        //     ),
                                        //     Text(
                                        //       "${AppConstants.priceSign}${model!.deliveryCharge}",
                                        //       style: Styles.grey14Regular,
                                        //       maxLines: 2,
                                        //     ),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('GSTCharges'),
                                              style: Styles.grey14Regular,
                                              maxLines: 2,
                                            ),
                                            Text(
                                              "${AppConstants.priceSign}${getSubGSTTotal().round()}",
                                              style: Styles.grey14Regular,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('total'),
                                              style: Styles.redMedium16,
                                              maxLines: 2,
                                            ),
                                            Text(
                                              "${AppConstants.priceSign}${totalCalulations().round()}",
                                              style: Styles.redMedium16,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              model!.returnRequest!.requestType == "return"
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 1,
                                          color: AppColors.greyColor
                                              .withOpacity(0.2),
                                        ),
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                        Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('previousSummary'),
                                          style: Styles.grey14Regular,
                                        ),
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NewMarkitVendorLocalizations.of(
                                                context)!
                                            .find('subTotal'),
                                        style: Styles.grey14Regular,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        "${AppConstants.priceSign}${double.parse(model!.subTotal!).round()}",
                                        style: Styles.grey14Regular,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   height: Dimens.ten,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       NewMarkitVendorLocalizations.of(
                                  //               context)!
                                  //           .find('deliveryCharges'),
                                  //       style: Styles.grey14Regular,
                                  //       maxLines: 2,
                                  //     ),
                                  //     Text(
                                  //       "${AppConstants.priceSign}${double.parse(model!.deliveryCharge!).round()}",
                                  //       style: Styles.grey14Regular,
                                  //       maxLines: 2,
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: Dimens.ten,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NewMarkitVendorLocalizations.of(
                                                context)!
                                            .find('GSTCharges'),
                                        style: Styles.grey14Regular,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        "${AppConstants.priceSign}${double.parse(model!.tax!).round()}",
                                        style: Styles.grey14Regular,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimens.sixTeen,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NewMarkitVendorLocalizations.of(
                                                context)!
                                            .find('total'),
                                        style: Styles.redMedium16,
                                        maxLines: 2,
                                      ),
                                      Text(
                                        "${AppConstants.priceSign}${double.parse(model!.totalAmount!).round() - double.parse(model!.deliveryCharge!).round()}",
                                        style: Styles.redMedium16,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dimens.sixTeen,
                                  ),
                                  Container(
                                    height: 1,
                                    color: AppColors.greyColor.withOpacity(0.2),
                                  ),
                                  SizedBox(
                                    height: Dimens.sixTeen,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    NewMarkitVendorLocalizations.of(context)!
                                        .find('paymentStatus'),
                                    style: Styles.blackMedium14,
                                  ),
                                  SizedBox(
                                    height: Dimens.ten,
                                  ),
                                  Text(
                                    model!.paymentType!,
                                    style: Styles.grey16Regular,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              Container(
                                height: 1,
                                color: AppColors.greyColor.withOpacity(0.2),
                              ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              Text(
                                "${model!.returnRequest!.requestType!.capitalizeFirst} Reason",
                                style: Styles.blackMedium14,
                              ),
                              SizedBox(
                                height: Dimens.ten,
                              ),
                              model!.returnRequest!.returnReason == null
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${model!.returnRequest!.returnReason!.text}",
                                          style: Styles.redMedium14,
                                        ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                      ],
                                    ),
                              Text(
                                "Description:- ${model!.returnRequest!.reason}",
                                style: Styles.grey14Medium,
                                maxLines: 5,
                              ),
                              SizedBox(
                                height: Dimens.ten,
                              ),
                              (model!.returnRequest!.images == "null" ||
                                      model!.returnRequest!.images == "")
                                  ? Container()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                        Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('reasonImages'),
                                          style: Styles.blackMedium14,
                                        ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        model!.returnRequest!.images!
                                                .contains(",")
                                            ? Wrap(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          model!.returnRequest!
                                                              .images!
                                                              .split(",")
                                                              .length;
                                                      i++)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  child:
                                                                      ImageZoomView(
                                                                    url: model!
                                                                        .returnRequest!
                                                                        .images!
                                                                        .split(
                                                                            ",")[i],
                                                                  )));
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: model!
                                                              .returnRequest!
                                                              .images!
                                                              .split(",")[i],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 80.0,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            height: 80.0,
                                                            width: 80,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              shape: BoxShape
                                                                  .rectangle,
                                                            ),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              child: const CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      AppColors
                                                                          .primaryColor)),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 80.0,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Image.asset(
                                                              AssetConstants
                                                                  .error,
                                                              width: 60,
                                                              height: 60,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                ImageZoomView(
                                                              url: model!
                                                                  .returnRequest!
                                                                  .images,
                                                            )));
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl: model!
                                                        .returnRequest!.images!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 80.0,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 80.0,
                                                      width: 80,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        child: const CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    AppColors
                                                                        .primaryColor)),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 80.0,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.error,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              Container(
                                height: 1,
                                color: AppColors.greyColor.withOpacity(0.2),
                              ),
                              SizedBox(
                                height: Dimens.sixTeen,
                              ),
                              (model!.returnRequest!.delivery_image == "null" ||
                                      model!.returnRequest!.delivery_image ==
                                          "")
                                  ? Container()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                        Text(
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('deliveredImage'),
                                          style: Styles.blackMedium14,
                                        ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        model!.returnRequest!.delivery_image!
                                                .contains(",")
                                            ? Wrap(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          model!.returnRequest!
                                                              .delivery_image!
                                                              .split(",")
                                                              .length;
                                                      i++)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  child:
                                                                      ImageZoomView(
                                                                    url: model!
                                                                        .returnRequest!
                                                                        .delivery_image!
                                                                        .split(
                                                                            ",")[i],
                                                                  )));
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: model!
                                                              .returnRequest!
                                                              .delivery_image!
                                                              .split(",")[i],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 80.0,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            height: 80.0,
                                                            width: 80,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              shape: BoxShape
                                                                  .rectangle,
                                                            ),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              child: const CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      AppColors
                                                                          .primaryColor)),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 80.0,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Image.asset(
                                                              AssetConstants
                                                                  .error,
                                                              width: 60,
                                                              height: 60,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .fade,
                                                            child:
                                                                ImageZoomView(
                                                              url: model!
                                                                  .returnRequest!
                                                                  .delivery_image!,
                                                            )));
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl: model!
                                                        .returnRequest!
                                                        .delivery_image!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 80.0,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 80.0,
                                                      width: 80,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        child: const CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    AppColors
                                                                        .primaryColor)),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 80.0,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.error,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                              SizedBox(
                                height: Dimens.twentyFour,
                              ),
                              model!.returnRequest!.status != "Pending"
                                  ? Container()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        isLoader
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                alignment: Alignment.center,
                                                child:
                                                    const CircularProgressIndicator(
                                                  color: AppColors.primaryColor,
                                                ),
                                              )
                                            : FormSubmitWidget(
                                                opacity: 1,
                                                disableColor:
                                                    AppColors.primaryColor,
                                                padding: Dimens.edgeInsets0,
                                                text:
                                                    NewMarkitVendorLocalizations
                                                            .of(context)!
                                                        .find('acceptOrder'),
                                                textStyle:
                                                    Styles.buttonWhiteTextStyle,
                                                startColor:
                                                    AppColors.primaryColor,
                                                endColor:
                                                    AppColors.primaryColor,
                                                iconColor: Colors.white,
                                                onTap: () {
                                                  whichApiCall = "changeStatus";
                                                  setState(() {
                                                    isLoader = true;
                                                  });
                                                  ApiCall.changeOrderStatus(
                                                      "Accept",
                                                      widget.id.toString(),
                                                      widget.rId.toString(),
                                                      "",
                                                      "",
                                                      token,
                                                      this,
                                                      context);
                                                },
                                              ),
                                        SizedBox(
                                          height: Dimens.sixTeen,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child:
                                                        ReturnDeclineOrderScreen(
                                                      id: widget.id,
                                                      rId: widget.rId,
                                                    ))).then((value) {
                                              if (value != null) {
                                                Navigator.pop(context, true);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            alignment: Alignment.center,
                                            child: Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('declineOrder'),
                                              style: Styles.boldBlue16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: Dimens.twentyFour,
                              ),
                            ],
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    width: Get.width,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              NewMarkitVendorLocalizations.of(context)!
                                  .find('orderDetails'),
                              style: Styles.boldBlack16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
    Utility.errorMessage(message, context);

    setState(() {
      isScreenLoader = false;

      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "details") {
      details = ReturnOrdersDetails.fromJson(data);
      if (orderTypeModel.isNotEmpty) {
        orderTypeModel.clear();
      }
      model = details.data!;
      if (model!.returnRequest!.requestType == "return") {
        for (int i = 0; i < orderRetrunType.length; i++) {
          if (model!.returnRequest!.status == orderRetrunType[i].name) {
          } else {
            orderTypeModel.add(orderRetrunType[i]);
          }
        }
      } else {
        for (int i = 0; i < orderType.length; i++) {
          if (model!.returnRequest!.status == orderType[i].name) {
          } else {
            orderTypeModel.add(orderType[i]);
          }
        }
      }
      setState(() {});
      //   whichApiCall = "statusList";
      //   ApiCall.getStatusListApi(model!.id.toString(), token, this, context);
      // } else if (whichApiCall == "statusList") {
      //   listModel = ChangeStatusList.fromJson(data);
      //   orderTypeModel = listModel.data!;
      // }
    } else {
      Utility.successMessage(data['message'], context);
      whichApiCall = "details";
      ApiCall.returnOrderDetails(
          widget.id.toString(), widget.rId.toString(), token, this, context);
    }
    setState(() {
      isScreenLoader = false;
      isLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }

  void orderTypeBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.white54,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('orderType'),
                            style: Styles.boldWhite16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if (orderIndex != null) {
                              changeState(orderTypeModel[orderIndex].name!);
                            } else {
                              Utility.errorMessage(
                                  "Please select status", context);
                            }
                          },
                          child: Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('done'),
                            style: Styles.boldWhite14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[400],
                    width: MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: orderTypeModel.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                orderIndex = index;

                                for (int i = 0;
                                    i < orderTypeModel.length;
                                    i++) {
                                  orderTypeModel[i].isSelected = false;
                                }
                                orderTypeModel[index].isSelected = true;
                                setState(() {});
                              },
                              child: Container(
                                color: Colors.grey.withAlpha(2),
                                padding: const EdgeInsets.all(16),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        orderIndex = index;

                                        for (int i = 0;
                                            i < orderTypeModel.length;
                                            i++) {
                                          orderTypeModel[i].isSelected = false;
                                        }
                                        orderTypeModel[index].isSelected = true;
                                        setState(() {});
                                      },
                                      child: Text(
                                        orderTypeModel[index].name!,
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
                                    const Spacer(),
                                    orderTypeModel[index].isSelected == false
                                        ? Icon(
                                            Icons.check_circle_rounded,
                                            size: 25,
                                            color: Colors.grey.withOpacity(0.5),
                                          )
                                        : const Icon(
                                            Icons.check_circle_rounded,
                                            size: 25,
                                            color: AppColors.redColor,
                                          )
                                  ],
                                ),
                              ),
                            );
                          }))
                ],
              ),
            );
          });
        });
  }

  changeState(String name) {
    if (name == "Delivered") {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: PickedUpScreen(
                id: model!.id,
                name: "Delivered",
                orderTypeId: widget.rId,
                type: "request",
              ))).then((value) {
        if (value != null) {
          ApiCall.returnOrderDetails(widget.id.toString(),
              widget.rId.toString(), token, this, context);
        }
      });
    } else {
      whichApiCall = "changeStatus";
      setState(() {
        isScreenLoader = true;
      });

      ApiCall.changeOrderStatus(name, model!.id.toString(),
          widget.rId.toString(), "", "", token, this, context);
    }
  }

  double getSubTotal() {
    double subTotal = 0.0;
    for (int i = 0; i < model!.returnRequest!.returnProducts!.length; i++) {
      subTotal = subTotal +
          (model!.returnRequest!.returnProducts![i].quantity! *
              model!.returnRequest!.returnProducts![i].amount!);
    }
    subTotalForRturn = subTotal;
    return subTotalForRturn!;
  }

  double getSubGSTTotal() {
    double gstTotal = 0.0;
    for (int i = 0; i < model!.returnRequest!.returnProducts!.length; i++) {
      gstTotal = gstTotal +
          gstAccordingToProduct(model!.returnRequest!.returnProducts![i]);
    }
    subTotalForGST = gstTotal;
    return subTotalForGST!;
  }

  double gstAccordingToProduct(ReturnProducts p) {
    double g = 0.0;
    for (int i = 0; i < p.quantity!; i++) {
      print("value   ${p.productJson!.taxValue}");
      g = g + ((p.amount! * double.parse(p.productJson!.taxValue!)) / 100);
    }
    return g;
  }

  double totalCalulations() {
    return subTotalForRturn! + subTotalForGST!;
  }
}
