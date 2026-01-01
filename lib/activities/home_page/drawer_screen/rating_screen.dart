import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/home_page/drawer_screen/model/vendor_rating_model.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/theme/dimens.dart';

import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../apiservice/api_call.dart';
import '../../../theme/styles.dart';
import '../../../utils/asset_constants.dart';
import '../../../utils/new_market_vendor_localizations.dart';
import '../../../utils/notification_receiver.dart';
import '../../../utils/notification_show.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utility.dart';
import '../../order_package/my_orders_details.dart';
import '../../order_package/return_order_details.dart';

class RatingScreen extends StatefulWidget {
  Function(int)? callBack;
  RatingScreen({required this.callBack});
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    implements ApiInterface, NotificationInterface {
  bool isLoader = true;
  VendorRatingModel model = VendorRatingModel();
  List<double> ratingArr = [];
  var token;
  int maxValue = 0;

  @override
  void initState() {
    super.initState();
    Utility.facebookEvent("rating_screen");

    NotificationShow.initPlatformState(this);

    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      ApiCall.vendorRatingApi(token, this, context);
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
                                                    model.rating!
                                                                .totalRatings ==
                                                            "null"
                                                        ? "0"
                                                        : "${double.parse(model.rating!.totalRatings!).toStringAsFixed(1)}",
                                                    style: Styles.boldBlack30,
                                                  ),
                                                  SizedBox(
                                                    height: Dimens.ten,
                                                  ),
                                                  RatingBar.builder(
                                                    ignoreGestures: true,
                                                    initialRating: model.rating!
                                                                .totalRatings ==
                                                            "null"
                                                        ? 0
                                                        : double.parse(model
                                                            .rating!
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
                                                        child: FAProgressBar(
                                                          currentValue: model
                                                                      .rating!
                                                                      .fiveStarRating ==
                                                                  "null"
                                                              ? 0
                                                              : double.parse(model
                                                                  .rating!
                                                                  .fiveStarRating!),
                                                          size: 10,
                                                          maxValue: maxValue
                                                              .toDouble(),
                                                          changeColorValue: 100,
                                                          changeProgressColor:
                                                              Colors.green,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
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
                                                      Text(
                                                        model.rating!
                                                                    .fiveStarRating ==
                                                                "null"
                                                            ? "0"
                                                            : "${double.parse(model.rating!.fiveStarRating!).round()}",
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
                                                        child: FAProgressBar(
                                                          currentValue: model
                                                                      .rating!
                                                                      .fourStarRating ==
                                                                  "null"
                                                              ? 0
                                                              : double.parse(model
                                                                  .rating!
                                                                  .fourStarRating!),
                                                          size: 10,
                                                          maxValue: maxValue
                                                              .toDouble(),
                                                          changeColorValue: 100,
                                                          changeProgressColor:
                                                              Colors.green,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
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
                                                      Text(
                                                        model.rating!
                                                                    .fourStarRating ==
                                                                "null"
                                                            ? "0"
                                                            : "${double.parse(model.rating!.fourStarRating!).round()}",
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
                                                        child: FAProgressBar(
                                                          currentValue: model
                                                                      .rating!
                                                                      .threeStarRating ==
                                                                  "null"
                                                              ? 0
                                                              : double.parse(model
                                                                  .rating!
                                                                  .threeStarRating!),
                                                          size: 10,
                                                          maxValue: maxValue
                                                              .toDouble(),
                                                          changeColorValue: 100,
                                                          changeProgressColor:
                                                              Colors.green,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
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
                                                      Text(
                                                        model.rating!
                                                                    .threeStarRating ==
                                                                "null"
                                                            ? "0"
                                                            : "${double.parse(model.rating!.threeStarRating!).round()}",
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
                                                        child: FAProgressBar(
                                                          currentValue: model
                                                                      .rating!
                                                                      .twotarRating ==
                                                                  "null"
                                                              ? 0
                                                              : double.parse(model
                                                                  .rating!
                                                                  .twotarRating!),
                                                          size: 10,
                                                          maxValue: maxValue
                                                              .toDouble(),
                                                          changeColorValue: 100,
                                                          changeProgressColor:
                                                              Colors.green,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
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
                                                      Text(
                                                        model.rating!
                                                                    .twotarRating ==
                                                                "null"
                                                            ? "0"
                                                            : "${double.parse(model.rating!.twotarRating!).round()}",
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
                                                        child: FAProgressBar(
                                                          currentValue: model
                                                                      .rating!
                                                                      .onetarRating ==
                                                                  "null"
                                                              ? 0
                                                              : double.parse(model
                                                                  .rating!
                                                                  .onetarRating!),
                                                          size: 10,
                                                          maxValue: maxValue
                                                              .toDouble(),
                                                          changeColorValue: 100,
                                                          changeProgressColor:
                                                              Colors.green,
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .withOpacity(
                                                                      0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
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
                                                      Text(
                                                        model.rating!
                                                                    .onetarRating ==
                                                                "null"
                                                            ? "0"
                                                            : "${double.parse(model.rating!.onetarRating!).round()}",
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
                                model.rating!.ratings!.isEmpty
                                    ? Text(
                                        "${NewMarkitVendorLocalizations.of(context)!.find('noRatingAvaliable')}",
                                        style: Styles.grey14Medium,
                                      )
                                    : Text(
                                        "${model.rating!.ratings!.length} ${NewMarkitVendorLocalizations.of(context)!.find('reviews')}",
                                        style: Styles.grey14Medium,
                                      ),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: model.rating!.ratings!.length,
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
                                                                .rating!
                                                                .ratings![index]
                                                                .user!
                                                                .profile ==
                                                            null
                                                        ? ""
                                                        : model
                                                            .rating!
                                                            .ratings![index]
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
                                                      Text(
                                                        "${model.rating!.ratings![index].user!.name}",
                                                        style:
                                                            Styles.boldBlack16,
                                                      ),
                                                      SizedBox(
                                                        height: Dimens.five,
                                                      ),
                                                      RatingBar.builder(
                                                        ignoreGestures: true,
                                                        initialRating: model
                                                                    .rating!
                                                                    .ratings![
                                                                        index]
                                                                    .rating ==
                                                                "null"
                                                            ? 0
                                                            : double.parse(model
                                                                .rating!
                                                                .ratings![index]
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
                                                        "${model.rating!.ratings![index].description}",
                                                        style:
                                                            Styles.lightGrey14,
                                                      ),
                                                    ],
                                                  )),
                                                  Text(
                                                    "${model.rating!.ratings![index].createdAt!.split("T")[0]}",
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
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              )
                                            ],
                                          ),
                                        ));
                                  },
                                )
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
    print(data);
    model = VendorRatingModel.fromJson(data);
    print("rating length${model.rating!.ratings!.length}");
    ratingArr.add(double.parse(model.rating!.fiveStarRating == "null"
        ? "0"
        : model.rating!.fiveStarRating!));
    ratingArr.add(double.parse(model.rating!.fourStarRating == "null"
        ? "0"
        : model.rating!.fourStarRating!));

    ratingArr.add(double.parse(model.rating!.threeStarRating == "null"
        ? "0"
        : model.rating!.threeStarRating!));

    ratingArr.add(double.parse(model.rating!.twotarRating == "null"
        ? "0"
        : model.rating!.twotarRating!));

    ratingArr.add(double.parse(model.rating!.onetarRating == "null"
        ? "0"
        : model.rating!.onetarRating!));
    maxValueMethod();
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
