import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/utils/image_zoom.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';
import 'package:page_transition/page_transition.dart';

import '../../apiservice/api_call.dart';
import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/activities/home_page/model/HomeModel.dart';

import '../../utils/utility.dart';
import 'edit_product.dart';

class ProductInfoScreen extends StatefulWidget {
  ProductData? data;

  ProductInfoScreen({Key? key, this.data}) : super(key: key);

  @override
  _ProductInfoScreenState createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen>
    implements ApiInterface {
  var percent;
  List<String> attributeSelected = [];
  ProductData model = ProductData();
  int vPos = 0;
  var token;
  var disocunt;

  @override
  void initState() {
    model = widget.data!;

    getToken();
    calculateDiscount();
    super.initState();
  }

  calculateDiscount() {
    disocunt = (double.parse(model.variations![vPos].basicPrice.toString()) -
            double.parse(model.variations![vPos].offerPrice.toString())) /
        double.parse(model.variations![vPos].basicPrice.toString()) *
        100;
    for (int i = 0; i < model.variations!.length; i++) {
      model.variations![i].isClick = false;
    }
    model.variations![vPos].isClick = true;
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SafeArea(
              top: true,
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
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
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('product_details'),
                                  style: Styles.boldBlack16,
                                ),
                              ],
                            ),
                            PopupMenuButton(
                              icon: const Icon(Icons
                                  .more_vert), //don't specify icon if you want 3 dot menu
                              color: Colors.white,
                              itemBuilder: (context) => [
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                              onSelected: (item) {
                                if (item == 0) {
                                  print("edit");
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: EditProductScreen(
                                            data: model,
                                          ))).then((value) {
                                    if (value != null) {
                                      Navigator.pop(context, true);
                                    }
                                  });
                                } else {
                                  Utility.dialogLoader(context);

                                  ApiCall.deleteProductList(model.id.toString(),
                                      token, this, context);
                                }
                              },
                            ),
                          ]),
                    ),
                    Dimens.boxHeight15,
                    model.variations![vPos].images!.contains(",")
                        ? Container(
                            child: CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 1.5,
                              enlargeCenterPage: true,
                            ),
                            items: model.variations![vPos].images!
                                .split(",")
                                .map((item) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child: ImageView(
                                                  url: item,
                                                )));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: item,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 180,
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 30,
                                            height: 30,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                          ),
                                          child: const Icon(Icons.error,
                                              color: Colors.black, size: 30),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ))
                        : Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: ImageView(
                                          url: model.variations![vPos].images!,
                                        )));
                              },
                              child: CachedNetworkImage(
                                imageUrl: model.variations![vPos].images!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 180,
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryColor)),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                  ),
                                  child: const Icon(Icons.error,
                                      color: Colors.black, size: 30),
                                ),
                              ),
                            )),
                    (model.variations![vPos].reject_reason == "null" ||
                            model.variations![vPos].reject_reason == "")
                        ? Container()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Dimens.boxHeight15,
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Reject Reason:- ${model.variations![vPos].reject_reason}",
                                    style: Styles.redMedium14,
                                    maxLines: 5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    Dimens.boxHeight15,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              NewMarkitVendorLocalizations.of(context)!
                                      .find('brandKey') +
                                  ": ",
                              style: Styles.loginPageSubTitleGrey),
                          Text(model.brand!.name!, style: Styles.boldBlack18),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(model.name!, style: Styles.boldBlack18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.yellowColor,
                            size: 20,
                          ),
                          Text("4.5", style: Styles.yellowMedium14),
                          Text(
                              " " +
                                  NewMarkitVendorLocalizations.of(context)!
                                      .find('review'),
                              style: Styles.yellowMedium14),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${disocunt.ceil()}% ",
                              style: Styles.redMedium16),
                          Text(
                              "${AppConstants.priceSign}${model.variations![vPos].offerPrice}",
                              style: Styles.boldBlack18),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("MRP ", style: Styles.grey12Regular),
                          Text(
                              "${AppConstants.priceSign}${model.variations![vPos].basicPrice}",
                              style: Styles.pricestrickTitleGrey12),
                        ],
                      ),
                    ),
                    model.isTaxable == "yes"
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Inclusive all taxes\n10% discount on delivery ",
                                    style: Styles.grey10Regular),
                              ],
                            ),
                          )
                        : Container(),
                    Dimens.boxHeight10,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: AppColors.yellowColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          SvgPicture.asset(
                            AssetConstants.car,
                            width: Dimens.twenty,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: Dimens.five,
                          ),
                          model.sameSayDelivery == "yes"
                              ? Text("Same days delivery",
                                  style: Styles.whiteLight14)
                              : Text("Delivery in ${model.deliveryDay!} days",
                                  style: Styles.whiteLight14),
                        ]),
                      ),
                    ),
                    Container(
                      height: 2,
                      color: AppColors.greyColor.withOpacity(0.1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: GestureDetector(
                        onTap: () {
                          categoryBottomSheet(context);
                        },
                        child: Container(
                          height: 50,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                NewMarkitVendorLocalizations.of(context)!
                                    .find('attributes'),
                                style: Styles.boldBlack16,
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 2,
                          color: AppColors.greyColor.withOpacity(0.1),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          AssetConstants.delivery,
                                          width: Dimens.thirty,
                                          height: Dimens.thirty,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      model.cash_on_delivery == "null" ||
                                              model.cash_on_delivery == "no"
                                          ? Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('nodelivery'),
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                          : Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('delivery'),
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                    ],
                                  ),
                                )),
                            Container(
                              width: 2,
                              height: 120,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  height: 120,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          AssetConstants.refund,
                                          width: Dimens.thirty,
                                          height: Dimens.thirty,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      model.refundable == "null" ||
                                              model.refundable == "no"
                                          ? Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('norefundable'),
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                          : Text(
                                              "${model.refend_day} ${NewMarkitVendorLocalizations.of(context)!.find('refundable')}",
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                    ],
                                  ),
                                )),
                            Container(
                              width: 2,
                              height: 120,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(
                                          AssetConstants.warranty,
                                          width: Dimens.thirty,
                                          height: Dimens.thirty,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      model.warranty == "null" ||
                                              model.warranty == "no"
                                          ? Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('nowarrenty'),
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                          : Text(
                                              "${model.warranty_month} ${model.warranty_type} ${NewMarkitVendorLocalizations.of(context)!.find('warrenty')}",
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        Container(
                          height: 2,
                          color: AppColors.greyColor.withOpacity(0.1),
                        ),
                      ],
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('product_details'),
                        style: Styles.boldBlack16,
                      ),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(model.description!, style: Styles.black12),
                    ),
                    Dimens.boxHeight20,
                    Container(
                      height: 2,
                      color: AppColors.greyColor.withOpacity(0.1),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('specifications'),
                        style: Styles.boldBlack16,
                      ),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                        children: [
                          for (int i = 0; i < model.specification!.length; i++)
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    model.specification![i].name!,
                                    style: Styles.loginPageSubTitleGrey,
                                  ),
                                ),
                                Text(
                                  ":",
                                  style: Styles.loginPageSubTitleGrey,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    model.specification![i].value!,
                                    textAlign: TextAlign.end,
                                    style: Styles.loginPageSubTitleGrey,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    Dimens.boxHeight20,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeState(int pos) {
    vPos = pos;
    calculateDiscount();
    setState(() {});
  }

  void categoryBottomSheet(
    BuildContext ctx,
  ) {
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
                                .find('attributes'),
                            style: Styles.whiteLight14,
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
                          scrollDirection: Axis.vertical,
                          itemCount: model.variations!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                changeState(index);
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: model.variations![index].isClick
                                    ? Colors.grey[300]!
                                    : Colors.transparent,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: model
                                                              .variations![
                                                                  index]
                                                              .default_variation_image ==
                                                          null
                                                      ? ""
                                                      : model.variations![index]
                                                          .default_variation_image!,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: 60,
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    width: 60,
                                                    height: 60.0,
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
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
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                    ),
                                                    child: const Icon(
                                                      Icons.error,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  AppConstants
                                                                          .priceSign +
                                                                      model
                                                                          .variations![
                                                                              index]
                                                                          .offerPrice!
                                                                          .toString(),
                                                                  style: Styles
                                                                      .loginPageSubTitleGrey),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                  AppConstants
                                                                          .priceSign +
                                                                      model
                                                                          .variations![
                                                                              index]
                                                                          .basicPrice!
                                                                          .toString(),
                                                                  style: Styles
                                                                      .pricestrickTitle12Grey),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: 25,
                                                            width: 80,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: model.variations![index].status ==
                                                                            "Pending"
                                                                        ? Colors
                                                                            .grey
                                                                        : model.variations![index].status ==
                                                                                "Approved"
                                                                            ? Colors
                                                                                .green
                                                                            : Colors
                                                                                .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15)),
                                                            child: Text(
                                                              model
                                                                  .variations![
                                                                      index]
                                                                  .status!,
                                                              style: Styles
                                                                  .whiteLight14,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          for (int i = 0;
                                                              i <
                                                                  model
                                                                      .variations![
                                                                          index]
                                                                      .attribute!
                                                                      .length;
                                                              i++)
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    model
                                                                            .variations![index]
                                                                            .attribute![i]
                                                                            .attributeName!
                                                                            .name! +
                                                                        ":- ",
                                                                    style: Styles
                                                                        .boldBlack14,
                                                                  ),
                                                                  model.variations![index].attribute![i].attributeName!
                                                                              .name ==
                                                                          "COLOR"
                                                                      ? Text(
                                                                          model.variations![index].attribute![i].unit == null
                                                                              ? ""
                                                                              : model.variations![index].attribute![i].unit!.name!,
                                                                          style:
                                                                              Styles.blackMedium12,
                                                                        )
                                                                      : Text(
                                                                          model
                                                                              .variations![index]
                                                                              .attribute![i]
                                                                              .attributeValue!,
                                                                          style:
                                                                              Styles.blackMedium12,
                                                                        ),
                                                                  model.variations![index].attribute![i].attributeName!.name ==
                                                                          "COLOR"
                                                                      ? Container(
                                                                          width:
                                                                              14,
                                                                          height:
                                                                              14,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Color(int.parse("0xFFF${model.variations![index].attribute![i].attributeValue!.replaceAll("#", "")}"))))
                                                                      : model.variations![index].attribute![i].unit == null
                                                                          ? Container()
                                                                          : Text(
                                                                              model.variations![index].attribute![i].unit!.name!,
                                                                              style: Styles.blackMedium12,
                                                                            ),
                                                                ],
                                                              ),
                                                            )
                                                        ],
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
                                    (model.variations![index].reject_reason ==
                                                "null" ||
                                            model.variations![index]
                                                    .reject_reason ==
                                                "")
                                        ? Container()
                                        : Flexible(
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Reject Reason:- ${model.variations![index].reject_reason}",
                                                style: Styles.redMedium14,
                                                maxLines: 5,
                                              ),
                                            ),
                                          ),
                                    model.variations!.length == 1
                                        ? Container()
                                        : Container(
                                            margin: const EdgeInsets.only(
                                                top: 5, left: 5, right: 5),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 1,
                                            color: Colors.grey[300],
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

  @override
  void onFailure(message) {
    Navigator.pop(context);
  }

  @override
  void onSuccess(data) {
    Navigator.pop(context);
    Timer timer = Timer(const Duration(milliseconds: 100), closePage);
  }

  closePage() {
    Navigator.pop(context, true);
  }

  @override
  void onTokenExpired() {}
}
