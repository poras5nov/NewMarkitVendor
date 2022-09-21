import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market_vendor_app/activities/catgeory_package/category_screen.dart';
import 'package:market_vendor_app/activities/home_page/model/HomeModel.dart';
import 'package:market_vendor_app/activities/order_package/decline_orders.dart';
import 'package:market_vendor_app/activities/order_package/model/return_order_details.dart';
import 'package:market_vendor_app/activities/order_package/view_all_return_product.dart';
import 'package:market_vendor_app/activities/product_details/product_info.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:market_vendor_app/utils/new_market_vendor_localizations.dart';
import 'package:market_vendor_app/utils/notification_receiver.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import '../../../apiservice/api_call.dart';
import '../../../apiservice/key_string.dart';
import '../../../theme/dimens.dart';
import '../../../theme/styles.dart';
import '../../../utils/asset_constants.dart';
import '../../../utils/notification_show.dart';
import '../../../utils/strings/app_constants.dart';
import '../../../utils/utility.dart';
import '../../../widgets/form_submit_widget.dart';
import '../../add_services/add_product_and_service_view.dart';
import '../../catgeory_package/sub_category_screen.dart';
import '../../edit_profile/EditProfile.dart';
import '../../order_package/my_orders_details.dart';
import '../../order_package/return_order_details.dart';
import '../../order_package/view_all_recent_order.dart';
import '../drawer_view.dart';
import '../view_all_prodcut.dart';

class HomeScreen extends StatefulWidget {
  Function(String)? totalOrders;
  Function(String)? totalRevenue;

  HomeScreen({required this.totalOrders, required this.totalRevenue});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements ApiInterface, NotificationInterface {
  var profileData;
  var token;
  HomeModel model = HomeModel();
  bool isLoader = true;
  String whichApiCall = "getDetails";

  @override
  void initState() {
    super.initState();
    NotificationShow.initPlatformState(this);

    getProfile();
    getToken();
  }

  getProfile() {
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      //print(profileData['profile']);
      setState(() {});
    });
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      ApiCall.getVendorDetails(token, this, context);
    });
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    whichApiCall = "getDetails";
    ApiCall.getVendorDetails(token, this, context);

    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // drawer: DrawerViewScreen(),
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
                    margin: const EdgeInsets.only(top: 80),
                    child: isLoader
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : RefreshIndicator(
                            backgroundColor: AppColors.primaryColor,
                            color: Colors.white,
                            onRefresh: _pullRefresh,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Overview",
                                              style: Styles.boldBlack14,
                                            ),
                                            // Text(
                                            //   "Last monthly",
                                            //   style:
                                            //       Styles.loginPageSubTitleGrey,
                                            // ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.topColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "Total Orders",
                                                          style: Styles
                                                              .primary14Medium,
                                                        ),
                                                        Text(
                                                          "${model.totalOrders}",
                                                          style: Styles
                                                              .boldBlack16,
                                                        ),
                                                      ]),
                                                )),
                                            SizedBox(
                                              width: Dimens.five,
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .revenuBackColor
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Total revenue',
                                                          style: Styles
                                                              .darkGrey14Medium,
                                                        ),
                                                        Text(
                                                          AppConstants
                                                                  .priceSign +
                                                              NumberFormat
                                                                  .compactCurrency(
                                                                decimalDigits:
                                                                    2,
                                                                symbol:
                                                                    '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                              ).format(double
                                                                  .parse(model
                                                                      .totalRevenue!)),
                                                          style: Styles
                                                              .boldBlack16,
                                                        ),
                                                      ]),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimens.ten,
                                        ),
                                        // Row(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: [
                                        //     Text(
                                        //       '0',
                                        //       style: Styles.boldDarkGreen14,
                                        //     ),
                                        //     Text(
                                        //       ' People viewed your products',
                                        //       style: Styles.mediumDarkGreen14,
                                        //     ),
                                        //   ],
                                        // ),
                                        // SizedBox(
                                        //   height: Dimens.five,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  model.returnOrders!.isEmpty
                                      ? Container()
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: Dimens.sixTeen,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.all(16),
                                              color: AppColors
                                                  .resentOrderBackColor,
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      NewMarkitVendorLocalizations
                                                              .of(context)!
                                                          .find(
                                                              'retrun/Exchange'),
                                                      style: Styles.boldBlack16,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 180,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: model
                                                          .returnOrders!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Stack(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 8,
                                                                      bottom:
                                                                          8),
                                                              width: model.returnOrders!
                                                                          .length ==
                                                                      1
                                                                  ? MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      32
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      60,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          type: PageTransitionType.fade,
                                                                          child: RetrunOrderDetailsScreen(
                                                                            id: model.returnOrders![index].id,
                                                                            rId:
                                                                                model.returnOrders![index].returnRequest!.id!,
                                                                          ))).then((value) {
                                                                    ApiCall.getHomeDataApi(
                                                                        token,
                                                                        this,
                                                                        context);
                                                                  });
                                                                },
                                                                child: Card(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16.0),
                                                                  ),
                                                                  elevation:
                                                                      2.5,
                                                                  color: Colors
                                                                      .white,
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              Dimens.ten,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: Dimens.five,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Text(
                                                                                  "Type:",
                                                                                  style: Styles.grey14Regular,
                                                                                ),
                                                                                Text(
                                                                                  model.returnOrders![index].returnRequest!.requestType!.capitalizeFirst!,
                                                                                  style: Styles.blackMedium14,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: Dimens.ten,
                                                                                ),
                                                                                Text(
                                                                                  "Items:",
                                                                                  style: Styles.grey14Regular,
                                                                                ),
                                                                                Text(
                                                                                  "${model.returnOrders![index].returnRequest!.returnProducts!.length}",
                                                                                  style: Styles.blackMedium14,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: Dimens.five,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              Dimens.sixTeen,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              width: Dimens.ten,
                                                                            ),
                                                                            CachedNetworkImage(
                                                                              imageUrl: model.returnOrders![index].user!.profile == null ? "" : model.returnOrders![index].user!.profile!,
                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                height: 60.0,
                                                                                width: 60,
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.rectangle,
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              placeholder: (context, url) => Container(
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
                                                                                  child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
                                                                                ),
                                                                              ),
                                                                              errorWidget: (context, url, error) => Container(
                                                                                alignment: Alignment.center,
                                                                                height: 60.0,
                                                                                width: 60,
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.grey[200],
                                                                                  shape: BoxShape.rectangle,
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                child: const Icon(
                                                                                  Icons.perm_identity,
                                                                                  size: 40,
                                                                                  color: AppColors.primaryColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: Dimens.ten,
                                                                            ),
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(model.returnOrders![index].user!.name!, style: Styles.boldBlack14),
                                                                                SizedBox(
                                                                                  height: Dimens.ten,
                                                                                ),
                                                                                Text(
                                                                                  "Order Date: ${model.returnOrders![index].orderDate}",
                                                                                  style: Styles.grey12Regular,
                                                                                  maxLines: 2,
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              Dimens.sixTeen,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              1,
                                                                          color: AppColors
                                                                              .greyColor
                                                                              .withOpacity(0.2),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: Dimens.five,
                                                                                ),
                                                                                Text(
                                                                                  "#${model.returnOrders![index].orderNumber}",
                                                                                  style: Styles.blackMedium14,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    PageTransition(
                                                                                        type: PageTransitionType.fade,
                                                                                        child: RetrunOrderDetailsScreen(
                                                                                          id: model.returnOrders![index].id,
                                                                                          rId: model.returnOrders![index].returnRequest!.id!,
                                                                                        ))).then((value) {
                                                                                  ApiCall.getHomeDataApi(token, this, context);
                                                                                });
                                                                              },
                                                                              child: Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Text(
                                                                                    NewMarkitVendorLocalizations.of(context)!.find('viewDetails'),
                                                                                    style: Styles.blackMedium16,
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
                                                                  shadowColor: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.3),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                                left: 6,
                                                              ),
                                                              child: Container(
                                                                height: 20,
                                                                width: 110,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: model.returnOrders![index].returnRequest!.status == "Cancelled"
                                                                        ? AppColors.primaryColor
                                                                        : model.returnOrders![index].returnRequest!.status! == "Delivered"
                                                                            ? AppColors.greenColor
                                                                            : AppColors.yellowColor,
                                                                    borderRadius: BorderRadius.circular(3.0),
                                                                    boxShadow: const [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey,
                                                                        blurRadius:
                                                                            5.0,
                                                                      ),
                                                                    ]),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: Dimens
                                                                          .five,
                                                                    ),
                                                                    Text(
                                                                      model
                                                                          .returnOrders![
                                                                              index]
                                                                          .returnRequest!
                                                                          .status!,
                                                                      style: Styles
                                                                          .whiteLight12,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
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
                                                                    PageTransitionType
                                                                        .fade,
                                                                child:
                                                                    ViewAllReturnOrderScreen()))
                                                        .then((value) {
                                                      ApiCall.getHomeDataApi(
                                                          token, this, context);
                                                    });
                                                  },
                                                  child: Text(
                                                      NewMarkitVendorLocalizations
                                                              .of(context)!
                                                          .find('viewAll'),
                                                      style: Styles.boldRed14),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                  SizedBox(height: Dimens.ten),
                                  model.orders!.isEmpty
                                      ? Container()
                                      : Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: Dimens.sixTeen,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.all(16),
                                              color: AppColors
                                                  .resentOrderBackColor,
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      NewMarkitVendorLocalizations
                                                              .of(context)!
                                                          .find('recentOrders'),
                                                      style: Styles.boldBlack16,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 180,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          model.orders!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          width: model.orders!
                                                                      .length ==
                                                                  1
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  32
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  60,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType
                                                                          .fade,
                                                                      child:
                                                                          OrderDetailsScreen(
                                                                        id: model
                                                                            .orders![index]
                                                                            .id,
                                                                      ))).then(
                                                                  (value) {
                                                                ApiCall
                                                                    .getHomeDataApi(
                                                                        token,
                                                                        this,
                                                                        context);
                                                              });
                                                            },
                                                            child: Card(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.0),
                                                              ),
                                                              elevation: 2.5,
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          Dimens
                                                                              .ten,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: Dimens.five,
                                                                            ),
                                                                            Text(
                                                                              "#${model.orders![index].orderNumber}",
                                                                              style: Styles.blackMedium14,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              "Items:",
                                                                              style: Styles.grey14Regular,
                                                                            ),
                                                                            Text(
                                                                              "${model.orders![index].products!.length}",
                                                                              style: Styles.blackMedium14,
                                                                            ),
                                                                            SizedBox(
                                                                              width: Dimens.five,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: Dimens
                                                                          .sixTeen,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              Dimens.ten,
                                                                        ),
                                                                        CachedNetworkImage(
                                                                          imageUrl: model.orders![index].user!.profile == null
                                                                              ? ""
                                                                              : model.orders![index].user!.profile!,
                                                                          imageBuilder: (context, imageProvider) =>
                                                                              Container(
                                                                            height:
                                                                                60.0,
                                                                            width:
                                                                                60,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.rectangle,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              image: DecorationImage(
                                                                                image: imageProvider,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          placeholder: (context, url) =>
                                                                              Container(
                                                                            height:
                                                                                60.0,
                                                                            width:
                                                                                60,
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.grey[200],
                                                                              shape: BoxShape.rectangle,
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              width: 30,
                                                                              height: 30,
                                                                              child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
                                                                            ),
                                                                          ),
                                                                          errorWidget: (context, url, error) =>
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            height:
                                                                                60.0,
                                                                            width:
                                                                                60,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.grey[200],
                                                                              shape: BoxShape.rectangle,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.perm_identity,
                                                                              size: 40,
                                                                              color: AppColors.primaryColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              Dimens.ten,
                                                                        ),
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(model.orders![index].user!.name!,
                                                                                style: Styles.boldBlack14),
                                                                            SizedBox(
                                                                              height: Dimens.ten,
                                                                            ),
                                                                            Text(
                                                                              "Order Date: ${model.orders![index].orderDate}",
                                                                              style: Styles.grey12Regular,
                                                                              maxLines: 2,
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: Dimens
                                                                          .sixTeen,
                                                                    ),
                                                                    Container(
                                                                      height: 1,
                                                                      color: AppColors
                                                                          .greyColor
                                                                          .withOpacity(
                                                                              0.2),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            // SizedBox(
                                                                            //   width:
                                                                            //       Dimens.ten,
                                                                            // ),
                                                                            // Text(
                                                                            //     NewMarkitVendorLocalizations.of(context)!.find('accept'),
                                                                            //     style: Styles.boldGreen14),
                                                                            // SizedBox(
                                                                            //   width:
                                                                            //       Dimens.sixTeen,
                                                                            // ),
                                                                            // GestureDetector(
                                                                            //   onTap:
                                                                            //       () {
                                                                            //     Navigator.push(
                                                                            //         context,
                                                                            //         PageTransition(
                                                                            //             type: PageTransitionType.fade,
                                                                            //             child: DeclineOrderScreen(
                                                                            //               id: model.orders![index].id,
                                                                            //             ))).then((value) {
                                                                            //       if (value != null) {
                                                                            //         ApiCall.getHomeDataApi(token, this, context);
                                                                            //       }
                                                                            //     });
                                                                            //   },
                                                                            //   child:
                                                                            //       Text(NewMarkitVendorLocalizations.of(context)!.find('decline'), style: Styles.boldRed14),
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                                context,
                                                                                PageTransition(
                                                                                    type: PageTransitionType.fade,
                                                                                    child: OrderDetailsScreen(
                                                                                      id: model.orders![index].id,
                                                                                    ))).then((value) {
                                                                              ApiCall.getHomeDataApi(token, this, context);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                NewMarkitVendorLocalizations.of(context)!.find('viewDetails'),
                                                                                style: Styles.blackMedium16,
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
                                                              shadowColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3),
                                                            ),
                                                          ),
                                                        );
                                                      }),
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
                                                                    PageTransitionType
                                                                        .fade,
                                                                child:
                                                                    ViewAllRecentOrderScreen()))
                                                        .then((value) {
                                                      ApiCall.getHomeDataApi(
                                                          token, this, context);
                                                    });
                                                  },
                                                  child: Text(
                                                      NewMarkitVendorLocalizations
                                                              .of(context)!
                                                          .find('viewAll'),
                                                      style: Styles.boldRed14),
                                                ),
                                              ]),
                                            ),
                                          ],
                                        ),
                                  model.categories!.isNotEmpty
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              left: 16, right: 16, top: 24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    NewMarkitVendorLocalizations
                                                            .of(context)!
                                                        .find('categories'),
                                                    style: Styles.boldBlack16,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  child:
                                                                      CategoryScreen()))
                                                          .then((value) {
                                                        ApiCall.getHomeDataApi(
                                                            token,
                                                            this,
                                                            context);
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          NewMarkitVendorLocalizations
                                                                  .of(context)!
                                                              .find('viewAll'),
                                                          style: Styles
                                                              .redMedium14,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              GridView.count(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                // Create a grid with 2 columns. If you change the scrollDirection to
                                                // horizontal, this produces 2 rows.
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20,
                                                // width / height: fixed for *all* items
                                                childAspectRatio: 1.25,
                                                // Generate 100 widgets that display their index in the List.
                                                children: List.generate(
                                                    model.categories!.length > 6
                                                        ? 6
                                                        : model.categories!
                                                            .length, (index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  SubCategoryScreen(
                                                                id: model
                                                                    .categories![
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                name: model
                                                                    .categories![
                                                                        index]
                                                                    .name!,
                                                              ))).then((value) {
                                                        ApiCall.getHomeDataApi(
                                                            token,
                                                            this,
                                                            context);
                                                      });
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        child: Stack(
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl: model
                                                                  .categories![
                                                                      index]
                                                                  .thumbnailUrl!,
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                height: 120.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
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
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                height: 120.0,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  child: const CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          AppColors
                                                                              .primaryColor)),
                                                                ),
                                                              ),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 120,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.error,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 120,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                ),
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                child: Text(
                                                                  model
                                                                      .categories![
                                                                          index]
                                                                      .name!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: Styles
                                                                      .boldWhite16,
                                                                  maxLines: 2,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: Dimens.twentyFour,
                                  ),
                                  model.data!.isNotEmpty
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    NewMarkitVendorLocalizations
                                                            .of(context)!
                                                        .find('recentProduct'),
                                                    style: Styles.boldBlack16,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  child:
                                                                      ViewAllProductScreen()))
                                                          .then((value) {
                                                        ApiCall.getHomeDataApi(
                                                            token,
                                                            this,
                                                            context);
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          NewMarkitVendorLocalizations
                                                                  .of(context)!
                                                              .find('viewAll'),
                                                          style: Styles
                                                              .redMedium14,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              GridView.count(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                // Create a grid with 2 columns. If you change the scrollDirection to
                                                // horizontal, this produces 2 rows.
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 4,
                                                // Generate 100 widgets that display their index in the List.
                                                children: List.generate(
                                                    model.data!.length > 4
                                                        ? 4
                                                        : model.data!.length,
                                                    (index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  ProductInfoScreen(
                                                                data:
                                                                    model.data![
                                                                        index],
                                                              ))).then((value) {
                                                        ApiCall.getHomeDataApi(
                                                            token,
                                                            this,
                                                            context);
                                                      });
                                                    },
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: model
                                                                .data![index]
                                                                .default_image!,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              height: 80.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                shape: BoxShape
                                                                    .rectangle,
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
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              height: 80.0,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                child: const CircularProgressIndicator(
                                                                    valueColor: AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        AppColors
                                                                            .primaryColor)),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                              ),
                                                              child: const Icon(
                                                                Icons.error,
                                                                size: 40,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              model.data![index]
                                                                  .name!,
                                                              style: Styles
                                                                  .boldBlack14,
                                                              maxLines: 2,
                                                              textScaleFactor:
                                                                  1.0,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppConstants
                                                                        .priceSign +
                                                                    model
                                                                        .data![
                                                                            index]
                                                                        .variations![
                                                                            0]
                                                                        .offerPrice!
                                                                        .toString(),
                                                                style: Styles
                                                                    .boldBlack14,
                                                                textScaleFactor:
                                                                    1.0,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                AppConstants
                                                                        .priceSign +
                                                                    model
                                                                        .data![
                                                                            index]
                                                                        .variations![
                                                                            0]
                                                                        .basicPrice!
                                                                        .toString(),
                                                                style: Styles
                                                                    .pricestrickTitle12Grey,
                                                                textScaleFactor:
                                                                    1.0,
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.star,
                                                                color: AppColors
                                                                    .yellowColor,
                                                                size: 20,
                                                              ),
                                                              Text(
                                                                "${model.data![index].product_rating}",
                                                                style: Styles
                                                                    .yellowMedium12,
                                                                textScaleFactor:
                                                                    1.0,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        )
                                      : model.categories!.isNotEmpty
                                          ? Container()
                                          : Center(
                                              child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .revenuBackColor
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle),
                                                  child: const Icon(
                                                    Icons.shopping_bag_outlined,
                                                    color: AppColors
                                                        .revenuBackColor,
                                                    size: 40,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimens.ten,
                                                ),
                                                Text(
                                                  'No product yet!',
                                                  style:
                                                      Styles.darkGrey18Medium,
                                                ),
                                                SizedBox(
                                                  height: Dimens.ten,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 16, right: 16),
                                                  child: Text(
                                                      "No product added yet. when you will add any product, it will appear here.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Styles
                                                          .loginPageSubTitleGrey),
                                                ),
                                                SizedBox(
                                                  height: Dimens.ten,
                                                ),
                                                Container(
                                                  width: 150,
                                                  child: FormSubmitWidget(
                                                    opacity: 1,
                                                    disableColor:
                                                        AppColors.primaryColor,
                                                    padding: Dimens.edgeInsets0,
                                                    text: "+ Add ",
                                                    textStyle:
                                                        Styles.buttonLight,
                                                    startColor:
                                                        AppColors.primaryColor,
                                                    endColor:
                                                        AppColors.primaryColor,
                                                    iconColor:
                                                        AppColors.primaryColor,
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              type:
                                                                  PageTransitionType
                                                                      .fade,
                                                              child:
                                                                  AddProductAndServiceScreen(
                                                                isProductScreen:
                                                                    true,
                                                              )));
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimens.ten,
                                                ),
                                              ],
                                            ))
                                ],
                              ),
                            ),
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Container(
                                height: 40.0,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                padding: const EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  AssetConstants.drawerImg,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            profileData != null
                                ? Text(
                                    "Hi,${profileData['data']['name'] ?? ""}",
                                    style: Styles.boldBlack16,
                                  )
                                : Container(),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // const Icon(
                            //   Icons.notifications_none,
                            //   size: 30,
                            // ),
                            // const SizedBox(
                            //   width: 5,
                            // ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: EditProfileView()))
                                    .then((value) {
                                  SharedPref.getProfileData().then((value) {
                                    profileData = json.decode(value);
                                    //print(profileData['profile']);
                                    setState(() {});
                                  });
                                  setState(() {});
                                });
                              },
                              child: CachedNetworkImage(
                                imageUrl: profileData == null
                                    ? ""
                                    : (profileData['data']['profile']
                                                    .toString() ==
                                                "null" ||
                                            profileData['data']['profile']
                                                    .toString() ==
                                                "")
                                        ? ""
                                        : profileData['data']['profile'],
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
                                  height: 50.0,
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.primaryColor)),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.perm_identity,
                                    size: 40,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
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
    });
  }

  @override
  void onSuccess(data) {
    if (whichApiCall == "getDetails") {
      whichApiCall = "homeData";
      var d = jsonEncode(data);
      SharedPref.saveProfileData(d);
      getProfile();
      if (data['data']['businesses']['is_verified'].toString() == "Yes") {
        ApiCall.getHomeDataApi(token, this, context);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/VerifiedScreen', (Route<dynamic> route) => false);
      }
    } else {
      model = HomeModel.fromJson(data);
      print(model.data!.length);
      widget.totalRevenue!(NumberFormat.compactCurrency(
        decimalDigits: 2,
        symbol:
            '', // if you want to add currency symbol then pass that in this else leave it empty.
      ).format(double.parse(model.totalRevenue!)));
      widget.totalOrders!(model.totalOrders!);
      setState(() {
        isLoader = false;
      });

      if (SharedPref.getOrderId() != null) {
        callScreenAfterNotificationClick(
            int.parse(SharedPref.getOrderId()),
            SharedPref.getOrderType(),
            SharedPref.getRequestOrderId() == null
                ? 0
                : int.parse(SharedPref.getRequestOrderId()));
      }
    }
  }

  callScreenAfterNotificationClick(var id, var type, var requestId) {
    if (type == "new") {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: OrderDetailsScreen(
                id: id,
              ))).then((value) {
        whichApiCall = "homeData";

        ApiCall.getHomeDataApi(token, this, context);
      });
    } else {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: RetrunOrderDetailsScreen(
                id: id,
                rId: requestId,
              ))).then((value) {
        whichApiCall = "homeData";

        ApiCall.getHomeDataApi(token, this, context);
      });
    }
    SharedPref.setOrderID("");
    SharedPref.setOrderType("");
    SharedPref.setRequestOrderId("");
  }

  @override
  void onTokenExpired() {}

  @override
  void onClick(id, type, requestId) {
    callScreenAfterNotificationClick(id, type, requestId);
  }

  @override
  void onMessageReceived(id, type) {
    print(id);
  }
}
