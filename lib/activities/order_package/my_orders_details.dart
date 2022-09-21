import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/order_package/model/change_status_list_model.dart';
import 'package:market_vendor_app/activities/order_package/picked_up.dart';

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
import '../home_page/model/order_model.dart';
import '../home_page/model/order_type_model.dart';
import 'decline_orders.dart';
import 'model/order_details.dart';

class OrderDetailsScreen extends StatefulWidget {
  int? id;
  OrderDetailsScreen({required this.id});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    implements ApiInterface {
  OrderDetails details = OrderDetails();
  OrdersData? model = OrdersData();
  ChangeStatusList listModel = ChangeStatusList();

  var token;
  bool isScreenLoader = false;
  var orderIndex;

  bool isLoader = false;
  String whichApiCall = "details";

  List<ChangeData> orderTypeModel = [];

  @override
  void initState() {
    getToken();

    super.initState();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      setState(() {
        isScreenLoader = true;
      });

      ApiCall.orderDetails(widget.id.toString(), token, this, context);
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
                                          model!.status == "Pending"
                                              ? Container()
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width: 110,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: model!
                                                                      .status ==
                                                                  "Cancelled"
                                                              ? AppColors
                                                                  .primaryColor
                                                              : model!.status ==
                                                                      "Delivered"
                                                                  ? AppColors
                                                                      .greenColor
                                                                  : model!.status ==
                                                                          "Accept"
                                                                      ? AppColors
                                                                          .yellowColor
                                                                      : AppColors
                                                                          .addNewProductDarColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      3.0),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.grey,
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
                                                            model!.status!,
                                                            style: Styles
                                                                .whiteLight12,
                                                          ),
                                                        ],
                                                      ),
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
                                            model!.orderDate!,
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
                                  model!.status != "Pending"
                                      ? Text(
                                          model!.updatedAt!.split("T")[0],
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
                                    model!.status == "Pending"
                                        ? "Not accepted yet"
                                        : model!.status!,
                                    style: Styles.grey16Regular,
                                  ),
                                  model!.status == "Pending" ||
                                          model!.status == "Cancelled" ||
                                          model!.status == "Delivered"
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            orderTypeBottomSheet(context);
                                          },
                                          child: Text(
                                            "Change status",
                                            style: Styles.redMedium14,
                                          ),
                                        )
                                ],
                              ),
                              model!.status == "Cancelled"
                                  ? Column(
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
                                        model!.cancel_by_user == "null" ||
                                                model!.cancel_by_user == ""
                                            ? Text(
                                                "Cancel By Vendor ",
                                                style: Styles.blackMedium14,
                                                maxLines: 3,
                                              )
                                            : Text(
                                                "Cancel By User ",
                                                style: Styles.blackMedium14,
                                                maxLines: 3,
                                              ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        Text(
                                          "${model!.cancel_reason!.text!}",
                                          style: Styles.grey14Regular,
                                          maxLines: 3,
                                        ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        model!.cancel_description == "null" ||
                                                model!.cancel_description == ""
                                            ? Text(
                                                "Descriptions:- " +
                                                    model!.declinedReason
                                                        .toString(),
                                                style: Styles.redMedium14,
                                                maxLines: 3,
                                              )
                                            : Text(
                                                "Descriptions:- " +
                                                    model!.cancel_description
                                                        .toString(),
                                                style: Styles.redMedium14,
                                                maxLines: 3,
                                              )
                                      ],
                                    )
                                  : Container(),
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
                              SizedBox(
                                height: Dimens.twentyFive,
                              ),
                              Wrap(
                                children: [
                                  for (int i = 0;
                                      i < model!.products!.length;
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
                                                              .products![i]
                                                              .variationJson!
                                                              .defaultVariationImage ==
                                                          null
                                                      ? ""
                                                      : model!
                                                          .products![i]
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
                                                      color: Colors.grey,
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                                        model!.products![i]
                                                            .productJson!.name!,
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
                                                            "${model!.products![i].quantity} * ",
                                                            style: Styles
                                                                .blackMedium14,
                                                            maxLines: 2,
                                                          ),
                                                          Text(
                                                            "${AppConstants.priceSign}${model!.products![i].amount!}",
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
                              Container(
                                height: 1,
                                color: AppColors.greyColor.withOpacity(0.2),
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
                              //       NewMarkitVendorLocalizations.of(context)!
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
                                    NewMarkitVendorLocalizations.of(context)!
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
                              Container(
                                height: 1,
                                color: AppColors.greyColor.withOpacity(0.2),
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
                              (model!.picked_image == "null" ||
                                      model!.picked_image == "")
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
                                              .find('packedImage'),
                                          style: Styles.blackMedium14,
                                        ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        model!.picked_image!.contains(",")
                                            ? Wrap(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          model!.picked_image!
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
                                                                        .picked_image!
                                                                        .split(
                                                                            ",")[i],
                                                                  )));
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: model!
                                                              .picked_image!
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
                                                                  .picked_image!,
                                                            )));
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        model!.picked_image!,
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
                                                        color: Colors.grey,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Image.asset(
                                                        AssetConstants.error,
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                              (model!.delivery_image == "null" ||
                                      model!.delivery_image == "")
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
                                        model!.delivery_image!.contains(",")
                                            ? Wrap(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          model!.delivery_image!
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
                                                                        .delivery_image!
                                                                        .split(
                                                                            ",")[i],
                                                                  )));
                                                        },
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: model!
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
                                                                  .delivery_image!,
                                                            )));
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        model!.delivery_image!,
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
                              model!.status != "Pending"
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
                                                  for (int i = 0;
                                                      i < orderTypeModel.length;
                                                      i++) {
                                                    if (orderTypeModel[i]
                                                            .name ==
                                                        "Accept") {
                                                      ApiCall.changeStatus(
                                                          orderTypeModel[i]
                                                              .id
                                                              .toString(),
                                                          model!.id.toString(),
                                                          "",
                                                          "",
                                                          "",
                                                          token,
                                                          this,
                                                          context);
                                                      break;
                                                    }
                                                  }
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
                                                    child: DeclineOrderScreen(
                                                      id: model!.id,
                                                      orderTypeModel:
                                                          orderTypeModel,
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
      details = OrderDetails.fromJson(data);

      model = details.data!;
      whichApiCall = "statusList";
      ApiCall.getStatusListApi(model!.id.toString(), token, this, context);
    } else if (whichApiCall == "statusList") {
      listModel = ChangeStatusList.fromJson(data);
      orderTypeModel = listModel.data!;
    } else {
      print(data);
      Utility.successMessage(data['message'], context);
      whichApiCall = "details";
      ApiCall.orderDetails(widget.id.toString(), token, this, context);
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
                              changeState(
                                  orderTypeModel[orderIndex].id.toString());
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
    var typeName = "";
    for (int i = 0; i < orderTypeModel.length; i++) {
      if (orderTypeModel[i].id.toString() == name) {
        typeName = orderTypeModel[i].name!;
      }
    }

    if (typeName == "Picked Up" || typeName == "Delivered") {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: PickedUpScreen(
                id: model!.id,
                name: typeName,
                orderTypeId: name,
                type: "new",
              ))).then((value) {
        if (value != null) {
          whichApiCall = "details";
          ApiCall.orderDetails(widget.id.toString(), token, this, context);
        } else {
          for (int i = 0; i < orderTypeModel.length; i++) {
            if (orderTypeModel[i].id.toString() == name) {
              orderTypeModel[i].isSelected = false;
              break;
            }
          }
        }
      });
    } else if (typeName == "Cancelled") {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: DeclineOrderScreen(
                id: model!.id,
                orderTypeModel: orderTypeModel,
              ))).then((value) {
        if (value != null) {
          Navigator.pop(context, true);
        } else {
          for (int i = 0; i < orderTypeModel.length; i++) {
            if (orderTypeModel[i].id.toString() == name) {
              orderTypeModel[i].isSelected = false;
              break;
            }
          }
        }
      });
    } else {
      whichApiCall = "changeStatus";
      setState(() {
        isScreenLoader = true;
      });
      ApiCall.changeStatus(
          name, model!.id.toString(), "", "", "", token, this, context);
    }
  }
}
