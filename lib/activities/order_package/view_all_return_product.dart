import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/order_package/return_order_details.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../apiservice/api_call.dart';

import '../../../theme/styles.dart';
import '../../theme/dimens.dart';
import 'model/return_order_model.dart';
import 'my_orders_details.dart';

class ViewAllReturnOrderScreen extends StatefulWidget {
  @override
  _ViewAllReturnOrderScreenState createState() =>
      _ViewAllReturnOrderScreenState();
}

class _ViewAllReturnOrderScreenState extends State<ViewAllReturnOrderScreen>
    implements ApiInterface {
  var token;
  RetrunOrderModel model = RetrunOrderModel();
  bool isLoader = true;
  List<Data> dataModel = [];

  String searchTxt = "";
  int page = 1;
  var scrollcontroller = ScrollController();
  TextEditingController searchController = TextEditingController();

  bool isBottomLoader = false;
  @override
  void initState() {
    getToken();
    scrollcontroller.addListener(pagination);

    super.initState();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      print("yeedcdddd");
      ApiCall.getReturnOrdersApi(page.toString(), token, this, context);
    });
  }

  void pagination() {
    if (isBottomLoader == false) {
      if (scrollcontroller.position.pixels ==
          scrollcontroller.position.maxScrollExtent) {
        print(dataModel.length);
        if (model.data!.nextPageUrl != null) {
          setState(() {
            isBottomLoader = true;
            page = page + 1;
            ApiCall.getReturnOrdersApi(page.toString(), token, this, context);

            //add api for load the more data according to new page
          });
        }
      }
    }
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
            ),
            SafeArea(
              top: true,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    child: SingleChildScrollView(
                      controller: scrollcontroller,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          isLoader
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 70,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: dataModel.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 8,
                                              bottom: 8),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 180,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                          RetrunOrderDetailsScreen(
                                                        id: dataModel[index].id,
                                                        rId: dataModel[index]
                                                            .returnRequest!
                                                            .id!,
                                                      ))).then((value) {
                                                ApiCall.getHomeDataApi(
                                                    token, this, context);
                                              });
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              elevation: 2.5,
                                              color: Colors.white,
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: Dimens.ten,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(),
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
                                                              dataModel[index]
                                                                  .returnRequest!
                                                                  .requestType!
                                                                  .capitalizeFirst!,
                                                              style: Styles
                                                                  .blackMedium14,
                                                            ),
                                                            SizedBox(
                                                              width: Dimens.ten,
                                                            ),
                                                            Text(
                                                              "Items:",
                                                              style: Styles
                                                                  .grey14Regular,
                                                            ),
                                                            Text(
                                                              "${dataModel[index].returnRequest!.returnProducts!.length}",
                                                              style: Styles
                                                                  .blackMedium14,
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  Dimens.five,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dimens.sixTeen,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: Dimens.ten,
                                                        ),
                                                        CachedNetworkImage(
                                                          imageUrl: dataModel[
                                                                          index]
                                                                      .user!
                                                                      .profile ==
                                                                  null
                                                              ? ""
                                                              : dataModel[index]
                                                                  .user!
                                                                  .profile!,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            height: 60.0,
                                                            width: 60,
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
                                                            height: 60.0,
                                                            width: 60,
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
                                                            height: 60.0,
                                                            width: 60,
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
                                                              size: 40,
                                                              color: AppColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: Dimens.ten,
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "${dataModel[index].user!.name}",
                                                                style: Styles
                                                                    .boldBlack14),
                                                            SizedBox(
                                                              height:
                                                                  Dimens.ten,
                                                            ),
                                                            Text(
                                                              "Order Date: ${dataModel[index].orderDate}",
                                                              style: Styles
                                                                  .grey12Regular,
                                                              maxLines: 2,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Dimens.sixTeen,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      color: AppColors.greyColor
                                                          .withOpacity(0.2),
                                                    ),
                                                    Expanded(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  Dimens.five,
                                                            ),
                                                            Text(
                                                              "#${dataModel[index].orderNumber}",
                                                              style: Styles
                                                                  .blackMedium14,
                                                            ),
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                PageTransition(
                                                                    type: PageTransitionType
                                                                        .fade,
                                                                    child:
                                                                        OrderDetailsScreen(
                                                                      id: dataModel[
                                                                              index]
                                                                          .id!,
                                                                    ))).then(
                                                                (value) {
                                                              if (value !=
                                                                  null) {
                                                                page = 1;
                                                                setState(() {
                                                                  isLoader =
                                                                      true;
                                                                });
                                                                ApiCall.getAllRecentOrderApi(
                                                                    page.toString(),
                                                                    token,
                                                                    this,
                                                                    context);
                                                              }
                                                            });
                                                          },
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                NewMarkitVendorLocalizations.of(
                                                                        context)!
                                                                    .find(
                                                                        'viewDetails'),
                                                                style: Styles
                                                                    .blackMedium16,
                                                                maxLines: 2,
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    Dimens.ten,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                                  ]),
                                              shadowColor:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            left: 14,
                                          ),
                                          child: Container(
                                            height: 20,
                                            width: 110,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: dataModel[index]
                                                            .returnRequest!
                                                            .status! ==
                                                        "Cancelled"
                                                    ? AppColors.primaryColor
                                                    : dataModel[index]
                                                                .returnRequest!
                                                                .status! ==
                                                            "Delivered"
                                                        ? AppColors.greenColor
                                                        : AppColors.yellowColor,
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 5.0,
                                                  ),
                                                ]),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: Dimens.five,
                                                ),
                                                Text(
                                                  dataModel[index]
                                                      .returnRequest!
                                                      .status!,
                                                  style: Styles.whiteLight12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                          isBottomLoader
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : Container()
                        ],
                      ),
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
                                  .find('retrun/Exchange'),
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
    setState(() {
      isLoader = false;
      isBottomLoader = false;
    });
  }

  @override
  void onSuccess(data) {
    print(data);
    model = RetrunOrderModel.fromJson(data);
    if (isBottomLoader) {
      dataModel.addAll(model.data!.data!);
    } else {
      dataModel = model.data!.data!;
    }

    setState(() {
      isLoader = false;
      isBottomLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
