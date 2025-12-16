import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/home_page/drawer_screen/model/vendor_rating_model.dart';
import 'package:market_vendor_app/activities/product_details/model/ProductRatingModel.dart';
import 'package:market_vendor_app/activities/product_details/report_screen.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/theme/dimens.dart';

import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../apiservice/api_call.dart';
import '../../../theme/styles.dart';
import '../../../utils/asset_constants.dart';
import '../../../utils/new_market_vendor_localizations.dart';
import '../../../utils/notification_receiver.dart';
import '../../../utils/notification_show.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utility.dart';
import '../../utils/image_zoom.dart';
import '../order_package/my_orders_details.dart';
import '../order_package/return_order_details.dart';

class ProductRatingScreen extends StatefulWidget {
  String? productId;
  ProductRatingScreen({required this.productId});
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<ProductRatingScreen>
    implements ApiInterface, NotificationInterface {
  bool isLoader = true;
  ProductRatingModel model = ProductRatingModel();
  List<double> ratingArr = [];
  var token;
  int maxValue = 0;

  int pageNo = 1;
  String ratingNo = '';
  bool isFirstTime = true;
  var scrollcontroller = ScrollController();
  bool isBottomLoader = false;

  @override
  void initState() {
    super.initState();
    Utility.facebookEvent("product_rating_screen");

    NotificationShow.initPlatformState(this);
    scrollcontroller.addListener(pagination);
    isFirstTime = true;
    getToken();
  }

  void pagination() {
    if (isBottomLoader == false) {
      if (scrollcontroller.position.pixels ==
          scrollcontroller.position.maxScrollExtent) {
        if (model.allReviews!.nextPageUrl!.isNotEmpty) {
          setState(() {
            isFirstTime = false;
            isBottomLoader = true;
            pageNo = pageNo + 1;
            ApiCall.productRatingApi(pageNo.toString(), ratingNo,
                widget.productId!, token, this, context);
            //add api for load the more data according to new page
          });
        }
      }
    }
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      print('token $token');
      ApiCall.productRatingApi(
          pageNo.toString(), ratingNo, widget.productId!, token, this, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Stack(
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
              bottom: true,
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
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
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
                                  .find('ratingReviews'),
                              style: Styles.boldBlack16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: isLoader
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 40,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : SingleChildScrollView(
                              controller: scrollcontroller,
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.all(Dimens.twenty),
                                  child: Container(
                                      height: Dimens.oneHundredFifty,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5.0,
                                            ),
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "${double.parse(model.productRatings!.totalRatings!)}",
                                                    style: Styles.boldBlack30,
                                                  ),
                                                  SizedBox(
                                                    height: Dimens.ten,
                                                  ),
                                                  RatingBar.builder(
                                                    ignoreGestures: true,
                                                    initialRating: double.parse(
                                                        model.productRatings!
                                                            .totalRatings!),
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 30,
                                                    itemPadding:
                                                        EdgeInsets.zero,
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate:
                                                        (double value) {},
                                                  )
                                                ],
                                              )),
                                          const DottedLine(
                                            dashColor: Colors.black,
                                            direction: Axis.vertical,
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: 1,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 1,
                                                        itemSize: 20,
                                                        itemPadding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (double value) {},
                                                      ),
                                                      Text(
                                                        "5",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              ratingNo = '5';
                                                              isLoader = true;
                                                              pageNo = 1;
                                                              isFirstTime =
                                                                  true;
                                                            });
                                                            getToken();
                                                          },
                                                          child: FAProgressBar(
                                                            currentValue: double
                                                                .parse(model
                                                                    .productRatings!
                                                                    .fiveStarRating!),
                                                            size: 10,
                                                            maxValue: maxValue
                                                                .toDouble(),
                                                            changeColorValue:
                                                                100,
                                                            changeProgressColor:
                                                                Colors.green,
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .withOpacity(
                                                                        0.4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            progressColor:
                                                                Colors.green,
                                                            animatedDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            direction:
                                                                Axis.horizontal,
                                                            formatValueFixed: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${double.parse(model.productRatings!.fiveStarRating!).round()}",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: 1,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 1,
                                                        itemSize: 20,
                                                        itemPadding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (double value) {},
                                                      ),
                                                      Text(
                                                        "4",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              ratingNo = '4';
                                                              isLoader = true;
                                                              pageNo = 1;
                                                              isFirstTime =
                                                                  true;
                                                            });
                                                            getToken();
                                                          },
                                                          child: FAProgressBar(
                                                            currentValue: double
                                                                .parse(model
                                                                    .productRatings!
                                                                    .fourStarRating!),
                                                            size: 10,
                                                            maxValue: maxValue
                                                                .toDouble(),
                                                            changeColorValue:
                                                                100,
                                                            changeProgressColor:
                                                                Colors.green,
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .withOpacity(
                                                                        0.4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            progressColor:
                                                                Colors.green,
                                                            animatedDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            direction:
                                                                Axis.horizontal,
                                                            formatValueFixed: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${double.parse(model.productRatings!.fourStarRating!).round()}",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: 1,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 1,
                                                        itemSize: 20,
                                                        itemPadding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (double value) {},
                                                      ),
                                                      Text(
                                                        "3",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              ratingNo = '3';
                                                              isLoader = true;
                                                              pageNo = 1;
                                                              isFirstTime =
                                                                  true;
                                                            });
                                                            getToken();
                                                          },
                                                          child: FAProgressBar(
                                                            currentValue: double
                                                                .parse(model
                                                                    .productRatings!
                                                                    .threeStarRating!),
                                                            size: 10,
                                                            maxValue: maxValue
                                                                .toDouble(),
                                                            changeColorValue:
                                                                100,
                                                            changeProgressColor:
                                                                Colors.green,
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .withOpacity(
                                                                        0.4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            progressColor:
                                                                Colors.green,
                                                            animatedDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            direction:
                                                                Axis.horizontal,
                                                            formatValueFixed: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${double.parse(model.productRatings!.threeStarRating!).round()}",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: 1,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 1,
                                                        itemSize: 20,
                                                        itemPadding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (double value) {},
                                                      ),
                                                      Text(
                                                        "2",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              ratingNo = '2';
                                                              isLoader = true;
                                                              pageNo = 1;
                                                              isFirstTime =
                                                                  true;
                                                            });
                                                            getToken();
                                                          },
                                                          child: FAProgressBar(
                                                            currentValue: double
                                                                .parse(model
                                                                    .productRatings!
                                                                    .twotarRating!),
                                                            size: 10,
                                                            maxValue: maxValue
                                                                .toDouble(),
                                                            changeColorValue:
                                                                100,
                                                            changeProgressColor:
                                                                Colors.green,
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .withOpacity(
                                                                        0.4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            progressColor:
                                                                Colors.green,
                                                            animatedDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            direction:
                                                                Axis.horizontal,
                                                            formatValueFixed: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${double.parse(model.productRatings!.twotarRating!).round()}",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    children: [
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: 1,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 1,
                                                        itemSize: 20,
                                                        itemPadding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (double value) {},
                                                      ),
                                                      Text(
                                                        "1",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              ratingNo = '1';
                                                              isLoader = true;
                                                              pageNo = 1;
                                                              isFirstTime =
                                                                  true;
                                                            });
                                                            getToken();
                                                          },
                                                          child: FAProgressBar(
                                                            currentValue: double
                                                                .parse(model
                                                                    .productRatings!
                                                                    .onetarRating!),
                                                            size: 10,
                                                            maxValue: maxValue
                                                                .toDouble(),
                                                            changeColorValue:
                                                                100,
                                                            changeProgressColor:
                                                                Colors.green,
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .withOpacity(
                                                                        0.4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            progressColor:
                                                                Colors.green,
                                                            animatedDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            direction:
                                                                Axis.horizontal,
                                                            formatValueFixed: 2,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${double.parse(model.productRatings!.onetarRating!).round()}",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  )
                                                ],
                                              ))
                                        ],
                                      )),
                                ),
                                model.allReviews!.data!.isEmpty
                                    ? Text(
                                        "${NewMarkitVendorLocalizations.of(context)!.find('noRatingAvaliable')}",
                                        style: Styles.grey14Medium,
                                      )
                                    : Text(
                                        "${model.allReviews!.data!.length} ${NewMarkitVendorLocalizations.of(context)!.find('reviews')}",
                                        style: Styles.grey14Medium,
                                      ),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: model.allReviews!.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: EdgeInsets.all(Dimens.twenty),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                                .allReviews!
                                                                .data![index]
                                                                .user ==
                                                            null
                                                        ? ''
                                                        : model
                                                                    .allReviews!
                                                                    .data![
                                                                        index]
                                                                    .user!
                                                                    .profile ==
                                                                null
                                                            ? ""
                                                            : model
                                                                .allReviews!
                                                                .data![index]
                                                                .user!
                                                                .profile!,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 50.0,
                                                      width: 50,
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
                                                      height: 50.0,
                                                      width: 50,
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
                                                      height: 50.0,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Icon(
                                                        Icons.perm_identity,
                                                        size: 30,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      model
                                                                  .allReviews!
                                                                  .data![index]
                                                                  .user ==
                                                              null
                                                          ? Text(
                                                              "${model.allReviews!.data![index].userName}",
                                                              style: Styles
                                                                  .boldBlack16,
                                                            )
                                                          : Text(
                                                              "${model.allReviews!.data![index].user!.name}",
                                                              style: Styles
                                                                  .boldBlack16,
                                                            ),
                                                      SizedBox(
                                                        height: Dimens.five,
                                                      ),
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: model
                                                                    .allReviews!
                                                                    .data![
                                                                        index]
                                                                    .rating ==
                                                                "null"
                                                            ? 0
                                                            : double.parse(model
                                                                .allReviews!
                                                                .data![index]
                                                                .rating!),
                                                        minRating: 0,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 20,
                                                        itemPadding:
                                                            EdgeInsets.zero,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate:
                                                            (double value) {},
                                                      ),
                                                      SizedBox(
                                                        height: Dimens.five,
                                                      ),
                                                      Text(
                                                        "${model.allReviews!.data![index].description}",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                      SizedBox(
                                                        height: Dimens.five,
                                                      ),
                                                      model
                                                                  .allReviews!
                                                                  .data![index]
                                                                  .links ==
                                                              ''
                                                          ? Container()
                                                          : model
                                                                  .allReviews!
                                                                  .data![index]
                                                                  .links!
                                                                  .contains(',')
                                                              ? Wrap(
                                                                  children: [
                                                                    for (int i =
                                                                            0;
                                                                        i <
                                                                            model.allReviews!.data![index].links!
                                                                                .split(
                                                                                    ',')
                                                                                .length;
                                                                        i++)
                                                                      (model.allReviews!.data![index].links!.split(',')[i].contains("png") ||
                                                                              model.allReviews!.data![index].links!.split(',')[i].contains("jpg") ||
                                                                              model.allReviews!.data![index].links!.split(',')[i].contains("jpeg") ||
                                                                              model.allReviews!.data![index].links!.split(',')[i].contains("JPG") ||
                                                                              model.allReviews!.data![index].links!.split(',')[i].contains("JPEG"))
                                                                          ? Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        PageTransition(
                                                                                            type: PageTransitionType.fade,
                                                                                            child: ImageZoomView(
                                                                                              url: model.allReviews!.data![index].links!.split(',')[i].trim(),
                                                                                              type: 'image',
                                                                                            )));
                                                                                  },
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: model.allReviews!.data![index].links!.split(',')[i].trim(),
                                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                                      height: 40.0,
                                                                                      width: 40,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.rectangle,
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
                                                                                        shape: BoxShape.rectangle,
                                                                                      ),
                                                                                      child: Container(
                                                                                        width: 30,
                                                                                        height: 30,
                                                                                        child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
                                                                                      ),
                                                                                    ),
                                                                                    errorWidget: (context, url, dynamic error) => Container(
                                                                                      alignment: Alignment.center,
                                                                                      height: 40.0,
                                                                                      width: 40,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.grey[200],
                                                                                        shape: BoxShape.rectangle,
                                                                                      ),
                                                                                      child: const Icon(
                                                                                        Icons.error,
                                                                                        size: 30,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                )
                                                                              ],
                                                                            )
                                                                          : Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Container(
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      AspectRatio(
                                                                                        aspectRatio: 8.0 / 8.0,
                                                                                        child: VideoPlayer(VideoPlayerController.networkUrl(Uri.parse(
                                                                                          model.allReviews!.data![index].links!.split(',')[i].trim(),
                                                                                        ))
                                                                                          ..initialize()),
                                                                                      ),
                                                                                      GestureDetector(
                                                                                        onTap: () {
                                                                                          Navigator.push(
                                                                                              context,
                                                                                              PageTransition(
                                                                                                  type: PageTransitionType.fade,
                                                                                                  child: ImageZoomView(
                                                                                                    url: model.allReviews!.data![index].links!.split(',')[i].trim(),
                                                                                                    type: 'video',
                                                                                                  )));
                                                                                        },
                                                                                        child: Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          alignment: Alignment.center,
                                                                                          child: Icon(
                                                                                            Icons.play_arrow,
                                                                                            size: 25,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5,
                                                                                )
                                                                              ],
                                                                            ),
                                                                  ],
                                                                )
                                                              : (model
                                                                          .allReviews!
                                                                          .data![
                                                                              index]
                                                                          .links!
                                                                          .contains(
                                                                              "png") ||
                                                                      model
                                                                          .allReviews!
                                                                          .data![
                                                                              index]
                                                                          .links!
                                                                          .contains(
                                                                              "jpg") ||
                                                                      model
                                                                          .allReviews!
                                                                          .data![
                                                                              index]
                                                                          .links!
                                                                          .contains(
                                                                              "jpeg") ||
                                                                      model
                                                                          .allReviews!
                                                                          .data![
                                                                              index]
                                                                          .links!
                                                                          .contains(
                                                                              "JPG") ||
                                                                      model
                                                                          .allReviews!
                                                                          .data![
                                                                              index]
                                                                          .links!
                                                                          .contains(
                                                                              "JPEG"))
                                                                  ? Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(context,
                                                                                PageTransition(type: PageTransitionType.fade, child: ImageZoomView(url: model.allReviews!.data![index].links!, type: 'image')));
                                                                          },
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                model.allReviews!.data![index].links!,
                                                                            imageBuilder: (context, imageProvider) =>
                                                                                Container(
                                                                              height: 40.0,
                                                                              width: 40,
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
                                                                              height: 40.0,
                                                                              width: 40,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey[200],
                                                                                shape: BoxShape.rectangle,
                                                                              ),
                                                                              child: Container(
                                                                                width: 30,
                                                                                height: 30,
                                                                                child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
                                                                              ),
                                                                            ),
                                                                            errorWidget: (context, url, dynamic error) =>
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              height: 40.0,
                                                                              width: 40,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.grey[200],
                                                                                shape: BoxShape.rectangle,
                                                                              ),
                                                                              child: const Icon(
                                                                                Icons.error,
                                                                                size: 30,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              AspectRatio(
                                                                                aspectRatio: 8.0 / 8.0,
                                                                                child: VideoPlayer(VideoPlayerController.networkUrl(Uri.parse(model.allReviews!.data![index].links!))..initialize()),
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(
                                                                                      context,
                                                                                      PageTransition(
                                                                                          type: PageTransitionType.fade,
                                                                                          child: ImageZoomView(
                                                                                            url: model.allReviews!.data![index].links!,
                                                                                            type: 'video',
                                                                                          )));
                                                                                },
                                                                                child: Container(
                                                                                  width: 40,
                                                                                  height: 40,
                                                                                  alignment: Alignment.center,
                                                                                  child: Icon(
                                                                                    Icons.play_arrow,
                                                                                    size: 25,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                      Dimens.boxHeight5,
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Helpfull(${model.allReviews!.data![index].helpfulCount})",
                                                            style: Styles
                                                                .lightGrey14,
                                                          ),
                                                          SizedBox(
                                                            width: 16,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child: ReportScreen(
                                                                          reviewId: model
                                                                              .allReviews!
                                                                              .data![index]
                                                                              .id
                                                                              .toString())));
                                                            },
                                                            child: Text(
                                                                "Report(${model.allReviews!.data![index].notHelpfulCount})",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: model
                                                                              .allReviews!
                                                                              .data![
                                                                                  index]
                                                                              .notHelpfulCount! >
                                                                          0
                                                                      ? AppColors
                                                                          .primaryColor
                                                                      : null,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  decorationColor: model
                                                                              .allReviews!
                                                                              .data![
                                                                                  index]
                                                                              .notHelpfulCount! >
                                                                          0
                                                                      ? AppColors
                                                                          .primaryColor
                                                                      : null,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                                  Text(
                                                    "${model.allReviews!.data![index].createdAt!.split("T")[0]}",
                                                    style: Styles.grey14Medium,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: Dimens.ten,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                height: 1,
                                                width: MediaQuery.of(context).size.width,
                                              )
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                                isBottomLoader
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      )
                                    : Container()
                              ]),
                            ))
                ],
              ))
        ],
      )),
    );
  }

  @override
  void onFailure(message) {
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    if (ratingArr.isNotEmpty) {
      ratingArr.clear();
    }
    if (isFirstTime) {
      model = ProductRatingModel.fromJson(data);
      ratingArr.add(double.parse(model.productRatings!.fiveStarRating!));
      ratingArr.add(double.parse(model.productRatings!.fourStarRating!));

      ratingArr.add(double.parse(model.productRatings!.threeStarRating!));

      ratingArr.add(double.parse(model.productRatings!.twotarRating!));

      ratingArr.add(double.parse(model.productRatings!.onetarRating!));

      maxValueMethod();
    } else {
      model.allReviews!.data!
          .addAll(ProductRatingModel.fromJson(data).allReviews!.data!);

      setState(() {
        isBottomLoader = false;
      });
    }
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }

  maxValueMethod() {
    maxValue = ratingArr[0].round();
    for (var i = 0; i < ratingArr.length; i++) {
      // Checking for largest value in the list
      if (ratingArr[i].round() != 0) {
        if (ratingArr[i].round() > maxValue) {
          maxValue = ratingArr[i].round();
        }
      }
    }
    setState(() {
      isLoader = false;
    });
    print(maxValue);
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
