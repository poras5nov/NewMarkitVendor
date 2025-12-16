import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';
import 'package:page_transition/page_transition.dart';

import '../../theme/app_colors.dart';
import '../../theme/dimens.dart';
import '../../theme/styles.dart';
import '../../utils/asset_constants.dart';
import '../../utils/new_market_vendor_localizations.dart';
import 'model/addproduct.dart';
import 'model/attributes_model.dart';

class PreviewScreen extends StatefulWidget {
  AddProductModel? model;
  Attributes? modelAttributes;

  PreviewScreen({Key? key, this.model, this.modelAttributes}) : super(key: key);
  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  var percent;
  List<String> attributeSelected = [];
  Attributes modelAttributesData = Attributes();
  int vPos = 0;
  var disocunt;
  @override
  void initState() {
    modelAttributesData = widget.modelAttributes!;
    calculateDiscount();

    super.initState();
  }

  calculateDiscount() {
    disocunt = (double.parse(
                widget.model!.variationsQuantity![vPos].basicPrice.toString()) -
            double.parse(widget.model!.variationsQuantity![vPos].offerPrice
                .toString())) /
        double.parse(
            widget.model!.variationsQuantity![vPos].basicPrice.toString()) *
        100;
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
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
                    ),
                    Dimens.boxHeight15,
                    widget.model!.variationsQuantity![vPos].images!
                            .contains(",")
                        ? Container(
                            child: CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 1.5,
                              enlargeCenterPage: true,
                            ),
                            items: widget
                                .model!.variationsQuantity![vPos].images!
                                .split(",")
                                .map((item) => CachedNetworkImage(
                                      imageUrl: item,
                                      imageBuilder: (context, imageProvider) =>
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
                                      placeholder: (context, url) => Container(
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
                                    ))
                                .toList(),
                          ))
                        : Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: CachedNetworkImage(
                              imageUrl: widget
                                  .model!.variationsQuantity![vPos].images!,
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
                            )),
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
                          Text(widget.model!.bransName!,
                              style: Styles.boldBlack18),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child:
                          Text(widget.model!.name!, style: Styles.boldBlack18),
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
                          Text("0", style: Styles.yellowMedium14),
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
                              "${AppConstants.priceSign}${widget.model!.variationsQuantity![vPos].offerPrice}",
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
                              "${AppConstants.priceSign}${widget.model!.variationsQuantity![vPos].basicPrice}",
                              style: Styles.pricestrickTitleGrey12),
                        ],
                      ),
                    ),
                    widget.model!.isTaxable == "yes"
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
                          widget.model!.sameSayDelivery == "yes"
                              ? Text("Same Day Delivery",
                                  style: Styles.whiteLight14)
                              : Text(
                                  "Delivery in ${widget.model!.deliveryDay!} days",
                                  style: Styles.whiteLight14),
                        ]),
                      ),
                    ),
                    Container(
                      height: 5,
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
                                      widget.model!.cash_on_delivery ==
                                                  "null" ||
                                              widget.model!.cash_on_delivery ==
                                                  "no"
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
                                      widget.model!.refundable == "null" ||
                                              widget.model!.refundable == "no"
                                          ? Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('norefundable'),
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                          : Text(
                                              "${widget.model!.refend_day} ${NewMarkitVendorLocalizations.of(context)!.find('refundable')}",
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
                                      widget.model!.warranty == "null" ||
                                              widget.model!.warranty == "no"
                                          ? Text(
                                              NewMarkitVendorLocalizations.of(
                                                      context)!
                                                  .find('nowarrenty'),
                                              textAlign: TextAlign.center,
                                              style: Styles.lightBlue14,
                                              maxLines: 2,
                                            )
                                          : Text(
                                              "${widget.model!.warranty_month} ${widget.model!.warranty_type}${NewMarkitVendorLocalizations.of(context)!.find('warrenty')}",
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
                      child: Text(widget.model!.description!,
                          style: Styles.black12),
                    ),
                    Dimens.boxHeight20,
                    Container(
                      height: 5,
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
                          for (int i = 0;
                              i < widget.model!.specifactions!.length;
                              i++)
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    widget.model!.specifactions![i].title!,
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
                                    widget.model!.specifactions![i]
                                        .specifactionValue!,
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
                    Container(
                      height: 5,
                      color: AppColors.greyColor.withOpacity(0.1),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        NewMarkitVendorLocalizations.of(context)!
                            .find('pinCodeAvailbility'),
                        style: Styles.boldBlack16,
                      ),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                        children: [
                          for (int i = 0;
                              i <
                                  widget.model!.available_pin_code!
                                      .split(",")
                                      .length;
                              i++)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 4, bottom: 4),
                                  child: Text(
                                    widget.model!.available_pin_code!
                                        .split(",")[i],
                                    style: Styles.whiteLight14,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Dimens.boxHeight20,
                    Container(
                      height: 5,
                      color: AppColors.greyColor.withOpacity(0.1),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('videoUrl'),
                            style: Styles.boldBlack16,
                          ),
                          Text(
                            ":- ${widget.model!.video_url}",
                            style: Styles.lightBlue14,
                          ),
                        ],
                      ),
                    ),
                    Dimens.boxHeight20,
                    Container(
                      height: 5,
                      color: AppColors.greyColor.withOpacity(0.1),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('seoProductTitle'),
                            style: Styles.boldBlack16,
                          ),
                          Text(
                            ":- ${widget.model!.seo_product_title}",
                            style: Styles.mediumBlack16,
                          ),
                        ],
                      ),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('seoMeta'),
                            style: Styles.boldBlack16,
                          ),
                          Text(
                            ":- ${widget.model!.seo_product_meta}",
                            style: Styles.mediumBlack16,
                          ),
                        ],
                      ),
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            NewMarkitVendorLocalizations.of(context)!
                                .find('targettedKeyword'),
                            style: Styles.boldBlack16,
                          ),
                          Text(
                            ":- ${widget.model!.targetted_keywords}",
                            style: Styles.mediumBlack16,
                          ),
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

  variationView(String value) {
    List<String> v = [];
    for (int i = 0; i < widget.model!.variationsQuantity!.length; i++) {
      for (int j = 0;
          j < widget.model!.variationsQuantity![i].attributes!.length;
          j++) {
        if (value ==
            widget.model!.variationsQuantity![i].attributes![j].attributeName) {
          v.add(widget
              .model!.variationsQuantity![i].attributes![j].attributeValue!);
        }
      }
    }

    return Wrap(
      children: [
        for (int k = 0; k < v.length; k++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      v[k],
                      style: Styles.boldWhite14,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          )
      ],
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
              height: MediaQuery.of(context).size.height / 2 - 100,
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
                            style: Styles.boldWhite16,
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
                          itemCount: widget.model!.variationsQuantity!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                changeState(index);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: widget
                                              .model!
                                              .variationsQuantity![index]
                                              .images!
                                              .split(",")[0],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 60,
                                            height: 60.0,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            alignment: Alignment.center,
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                            ),
                                            child: const Icon(Icons.error,
                                                color: Colors.black, size: 25),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    AppConstants.priceSign +
                                                        widget
                                                            .model!
                                                            .variationsQuantity![
                                                                index]
                                                            .offerPrice!
                                                            .toString(),
                                                    style: Styles
                                                        .loginPageSubTitleGrey),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    AppConstants.priceSign +
                                                        widget
                                                            .model!
                                                            .variationsQuantity![
                                                                index]
                                                            .basicPrice!
                                                            .toString(),
                                                    style: Styles
                                                        .pricestrickTitle12Grey),
                                              ],
                                            ),
                                            Wrap(
                                              children: [
                                                for (int j = 0;
                                                    j <
                                                        widget
                                                            .model!
                                                            .variationsQuantity![
                                                                index]
                                                            .attributes!
                                                            .length;
                                                    j++)
                                                  Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          widget
                                                                  .model!
                                                                  .variationsQuantity![
                                                                      index]
                                                                  .attributes![
                                                                      j]
                                                                  .attributeName! +
                                                              ":- ",
                                                          style: Styles
                                                              .boldBlack14,
                                                        ),
                                                        widget
                                                                    .model!
                                                                    .variationsQuantity![
                                                                        index]
                                                                    .attributes![
                                                                        j]
                                                                    .attributeName ==
                                                                "COLOR"
                                                            ? Text(
                                                                widget
                                                                    .model!
                                                                    .variationsQuantity![
                                                                        index]
                                                                    .attributes![
                                                                        j]
                                                                    .unit_name!,
                                                                style: Styles
                                                                    .boldBlack12,
                                                              )
                                                            : Text(
                                                                widget
                                                                    .model!
                                                                    .variationsQuantity![
                                                                        index]
                                                                    .attributes![
                                                                        j]
                                                                    .attributeValue!,
                                                                style: Styles
                                                                    .boldBlack12,
                                                              ),
                                                        widget
                                                                    .model!
                                                                    .variationsQuantity![
                                                                        index]
                                                                    .attributes![
                                                                        j]
                                                                    .unit_id ==
                                                                "0"
                                                            ? Container()
                                                            : widget
                                                                        .model!
                                                                        .variationsQuantity![
                                                                            index]
                                                                        .attributes![
                                                                            j]
                                                                        .attributeName ==
                                                                    "COLOR"
                                                                ? Container(
                                                                    width: 14,
                                                                    height: 14,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Color(
                                                                            int.parse("0xFFF${widget.model!.variationsQuantity![index].attributes![j].attributeValue!.replaceAll("#", "")}"))),
                                                                  )
                                                                : Text(
                                                                    widget
                                                                        .model!
                                                                        .variationsQuantity![
                                                                            index]
                                                                        .attributes![
                                                                            j]
                                                                        .unit_name!,
                                                                    style: Styles
                                                                        .blackMedium12,
                                                                  ),
                                                        const SizedBox(
                                                          width: 5,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
}
