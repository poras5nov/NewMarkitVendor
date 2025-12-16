import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/home_page/drawer_screen/model/vendor_rating_model.dart';
import 'package:market_vendor_app/activities/product_details/model/ProductRatingModel.dart';
import 'package:market_vendor_app/activities/product_details/model/ReportModel.dart';
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

class ReportScreen extends StatefulWidget {
  String? reviewId;
  ReportScreen({required this.reviewId});
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    implements ApiInterface, NotificationInterface {
  bool isLoader = true;
  ReportModel model = ReportModel();
  String token = '';
  @override
  void initState() {
    super.initState();
    Utility.facebookEvent("product_report_screen");

    NotificationShow.initPlatformState(this);

    getToken();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      print('token $token');
      ApiCall.ratingReportApi(widget.reviewId!, token, this, context);
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
                              'Reports',
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
                                model.feedbacks!.isEmpty
                                    ? Text(
                                        "No Report available",
                                        style: Styles.grey14Medium,
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: model.feedbacks!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding:
                                                  EdgeInsets.all(Dimens.twenty),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: model
                                                                      .feedbacks![
                                                                          index]
                                                                      .user ==
                                                                  null
                                                              ? ''
                                                              : model
                                                                          .feedbacks![
                                                                              index]
                                                                          .user!
                                                                          .profile ==
                                                                      null
                                                                  ? ""
                                                                  : model
                                                                      .feedbacks![
                                                                          index]
                                                                      .user!
                                                                      .profile!,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 50.0,
                                                            width: 50,
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
                                                            height: 50.0,
                                                            width: 50,
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
                                                            height: 50.0,
                                                            width: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .perm_identity,
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
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "${model.feedbacks![index].user!.name}",
                                                              style: Styles
                                                                  .boldBlack16,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  Dimens.five,
                                                            ),
                                                            Text(
                                                              "${model.feedbacks![index].report}",
                                                              style: Styles
                                                                  .lightGrey14,
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  Dimens.five,
                                                            ),
                                                          ],
                                                        )),
                                                        Text(
                                                          "${model.feedbacks![index].createdAt!.split("T")[0]}",
                                                          style: Styles
                                                              .grey14Medium,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dimens.ten,
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20),
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
    model = ReportModel.fromJson(data);

    setState(() {
      isLoader = false;
    });
  }

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
