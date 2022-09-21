import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/home_page/model/order_model.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../apiservice/api_call.dart';

import '../../../theme/styles.dart';
import '../../theme/dimens.dart';
import 'decline_orders.dart';
import 'my_orders_details.dart';

class AcceptOrderScreen extends StatefulWidget {
  @override
  _AcceptOrderScreenState createState() => _AcceptOrderScreenState();
}

class _AcceptOrderScreenState extends State<AcceptOrderScreen>
    implements ApiInterface {
  var token;
  bool isLoader = false;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;

      // ApiCall.getProductsApi(token, this, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 16, right: 16),
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              onChanged: (v) {},
              decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 24,
                    color: Colors.black,
                  ),
                  hintText: "Search",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.only(top: 4, bottom: 6, right: 5)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: isLoader
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 2,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 8, right: 8, top: 8, bottom: 8),
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      elevation: 2.5,
                                      color: Colors.white,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: Dimens.ten,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.greenColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Items:",
                                                      style:
                                                          Styles.grey14Regular,
                                                    ),
                                                    Text(
                                                      "2",
                                                      style:
                                                          Styles.blackMedium14,
                                                    ),
                                                    SizedBox(
                                                      width: Dimens.five,
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
                                                Image.asset(
                                                  "assets/images/dummy.png",
                                                  width: 60,
                                                  height: 60,
                                                ),
                                                SizedBox(
                                                  width: Dimens.ten,
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Poras dhiman",
                                                        style:
                                                            Styles.boldBlack14),
                                                    SizedBox(
                                                      height: Dimens.ten,
                                                    ),
                                                    Text(
                                                      "Order Date: 5 March, 2022 10:21am ",
                                                      style:
                                                          Styles.grey12Regular,
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
                                                  children: [
                                                    SizedBox(
                                                      width: Dimens.ten,
                                                    ),
                                                    Text(
                                                      "#45678901234",
                                                      style:
                                                          Styles.blackMedium14,
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        NewMarkitVendorLocalizations
                                                                .of(context)!
                                                            .find(
                                                                'viewDetails'),
                                                        style: Styles
                                                            .grey14Regular,
                                                        maxLines: 2,
                                                      ),
                                                      SizedBox(
                                                        width: Dimens.ten,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ))
                                          ]),
                                      shadowColor: Colors.grey.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 6),
                                  child: Container(
                                    height: 20,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.greenColor,
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
                                          NewMarkitVendorLocalizations.of(
                                                  context)!
                                              .find('inProgress'),
                                          style: Styles.whiteLight14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
            ),
          ),
        ],
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
  void onSuccess(data) {
    setState(() {
      isLoader = false;
    });
  }

  @override
  void onTokenExpired() {
    // TODO: implement onTokenExpired
  }
}
