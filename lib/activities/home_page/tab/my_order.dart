import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/order_package/model/reason_model.dart';
import 'package:market_vendor_app/apiservice/api_call.dart';
import 'package:market_vendor_app/apiservice/api_interface.dart';

import 'package:market_vendor_app/utils/strings/app_constants.dart';
import 'package:page_transition/page_transition.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/dimens.dart';
import '../../../theme/styles.dart';
import '../../../utils/new_market_vendor_localizations.dart';
import '../../../utils/notification_receiver.dart';
import '../../../utils/notification_show.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utility.dart';
import '../../order_package/my_orders_details.dart';
import '../../order_package/return_order_details.dart';
import '../model/order_data.dart';
import '../model/order_type_model.dart';

class MyOrderScreen extends StatefulWidget {
  Function(int)? callBack;
  MyOrderScreen({required this.callBack});
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen>
    implements ApiInterface, NotificationInterface {
  List<Status> orderTypeList = [];
  ReasonModel rModel = ReasonModel();
  OrderData model = OrderData();
  List<Data> dataModel = [];

  var orderIndex = 0;
  var token;
  var orderTypeString = "0";
  bool isLoader = true;
  int page = 1;

  String searchTxt = "";
  var scrollcontroller = ScrollController();
  TextEditingController searchController = TextEditingController(text: "");
  String whichApiCall = "reasons";
  bool isBottomLoader = false;
  @override
  void initState() {
    super.initState();
    NotificationShow.initPlatformState(this);
    Utility.facebookEvent("my_order_screen");

    Status s = Status();
    s.id = 0;
    s.name = "all";
    s.image = "";
    s.isSelected = true;
    orderTypeList.add(s);

    scrollcontroller.addListener(pagination);
    getToken();

    setState(() {});
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
      ApiCall.declineReson(token, this, context);
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
            whichApiCall = "getOrders";

            ApiCall.getOrderStatusApi(page.toString(), orderTypeString,
                searchController.text, token, this, context);
            //add api for load the more data according to new page
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: [
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
            bottom: true,
            child: Column(children: [
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
                              .find('myOrders'),
                          style: Styles.boldBlack16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 16, right: 8),
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (v) {
                                    page = 1;
                                    whichApiCall = "getOrders";

                                    ApiCall.getOrderStatusApi(
                                        page.toString(),
                                        orderTypeString,
                                        v,
                                        token,
                                        this,
                                        context);
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.search,
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                      hintText: "Search",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.black),
                                      contentPadding: EdgeInsets.only(
                                          top: 4, bottom: 6, right: 5)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                orderTypeBottomSheet(context);
                              },
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 16),
                                  child: const Icon(
                                    Icons.filter_alt,
                                    color: AppColors.primaryColor,
                                    size: 40,
                                  )),
                            )
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: isLoader
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : dataModel.isEmpty
                                  ? Center(
                                      child: Text(
                                        NewMarkitVendorLocalizations.of(
                                                context)!
                                            .find('noDataFound'),
                                        style: Styles.boldBlack16,
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      controller: scrollcontroller,
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: dataModel.length,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                return Stack(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              right: 8,
                                                              top: 8,
                                                              bottom: 8),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 180,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  child:
                                                                      OrderDetailsScreen(
                                                                    id: dataModel[
                                                                            index]
                                                                        .id!,
                                                                  ))).then(
                                                              (value) {
                                                            if (value != null) {
                                                              page = 1;
                                                              whichApiCall =
                                                                  "getOrders";

                                                              ApiCall.getOrderStatusApi(
                                                                  page
                                                                      .toString(),
                                                                  orderTypeString,
                                                                  searchController
                                                                      .text,
                                                                  token,
                                                                  this,
                                                                  context);
                                                            }
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
                                                          color: Colors.white,
                                                          child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                SizedBox(
                                                                  height: Dimens
                                                                      .ten,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppColors
                                                                            .greenColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16.0),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                          "Items:",
                                                                          style:
                                                                              Styles.grey14Regular,
                                                                        ),
                                                                        Text(
                                                                          "${dataModel[index].products!.length}",
                                                                          style:
                                                                              Styles.blackMedium14,
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
                                                                  height: Dimens
                                                                      .five,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: Dimens
                                                                          .ten,
                                                                    ),
                                                                    CachedNetworkImage(
                                                                      imageUrl: dataModel[index].user!.profile ==
                                                                              null
                                                                          ? ""
                                                                          : dataModel[index]
                                                                              .user!
                                                                              .profile!,
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        height:
                                                                            60.0,
                                                                        width:
                                                                            60,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              Container(
                                                                        height:
                                                                            60.0,
                                                                        width:
                                                                            60,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.grey[200],
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          child:
                                                                              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor)),
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height:
                                                                            60.0,
                                                                        width:
                                                                            60,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.grey[200],
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .perm_identity,
                                                                          size:
                                                                              40,
                                                                          color:
                                                                              AppColors.primaryColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: Dimens
                                                                          .ten,
                                                                    ),
                                                                    Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                            "${dataModel[index].user!.name}",
                                                                            style:
                                                                                Styles.boldBlack14),
                                                                        SizedBox(
                                                                          height:
                                                                              Dimens.ten,
                                                                        ),
                                                                        Text(
                                                                          "Order Date: ${dataModel[index].orderDate}",
                                                                          style:
                                                                              Styles.grey12Regular,
                                                                          maxLines:
                                                                              2,
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
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              Dimens.ten,
                                                                        ),
                                                                        Text(
                                                                          "#${dataModel[index].orderNumber}",
                                                                          style:
                                                                              Styles.blackMedium14,
                                                                        ),
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
                                                                                  id: dataModel[index].id!,
                                                                                ))).then((value) {
                                                                          if (value !=
                                                                              null) {
                                                                            page =
                                                                                1;
                                                                            whichApiCall =
                                                                                "getOrders";

                                                                            ApiCall.getOrderStatusApi(
                                                                                page.toString(),
                                                                                orderTypeString,
                                                                                searchController.text,
                                                                                token,
                                                                                this,
                                                                                context);
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            NewMarkitVendorLocalizations.of(context)!.find('viewDetails'),
                                                                            style:
                                                                                Styles.grey14Regular,
                                                                            maxLines:
                                                                                2,
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
                                                          shadowColor: Colors
                                                              .grey
                                                              .withOpacity(0.3),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10, left: 6),
                                                      child: Container(
                                                        height: 30,
                                                        width: 110,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: dataModel[index]
                                                                            .status ==
                                                                        "Cancelled"
                                                                    ? AppColors
                                                                        .primaryColor
                                                                    : dataModel[index].status ==
                                                                            "Delivered"
                                                                        ? AppColors
                                                                            .greenColor
                                                                        : dataModel[index].status ==
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
                                                              width:
                                                                  Dimens.five,
                                                            ),
                                                            Text(
                                                              dataModel[index]
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
                                          isBottomLoader
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      )),
                        ),
                      ],
                    ),
                  ))
            ]),
          )
        ]),
      ),
    );
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
                            orderTypeString =
                                orderTypeList[orderIndex].id.toString();
                            changeState();

                            Navigator.pop(context);
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
                          itemCount: orderTypeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                orderIndex = index;

                                for (int i = 0; i < orderTypeList.length; i++) {
                                  orderTypeList[i].isSelected = false;
                                }
                                orderTypeList[index].isSelected = true;
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
                                            i < orderTypeList.length;
                                            i++) {
                                          orderTypeList[i].isSelected = false;
                                        }
                                        orderTypeList[index].isSelected = true;
                                        setState(() {});
                                      },
                                      child: Text(
                                        orderTypeList[index]
                                            .name!
                                            .capitalizeFirst!,
                                        style: Styles.boldBlack16,
                                      ),
                                    ),
                                    const Spacer(),
                                    orderTypeList[index].isSelected == false
                                        ? Container()
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

  changeState() {
    setState(() {
      isLoader = true;
      page = 1;
    });
    whichApiCall = "getOrders";

    ApiCall.getOrderStatusApi(page.toString(), orderTypeString,
        searchController.text, token, this, context);
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
    if (whichApiCall == "reasons") {
      rModel = ReasonModel.fromJson(data);
      orderTypeList.addAll(rModel.statusList!);
      print("total reason status ${orderTypeList.length}");
      whichApiCall = "getOrders";
      setState(() {});
      ApiCall.getOrderStatusApi(
          page.toString(),
          orderTypeList[0].id!.toString(),
          searchController.text,
          token,
          this,
          context);
    } else {
      model = OrderData.fromJson(data);
      if (isBottomLoader) {
        if (model.data!.data!.length > 0) {
          dataModel.addAll(model.data!.data!);
        }

        print("add data");
      } else {
        dataModel = model.data!.data!;
      }
      setState(() {
        isLoader = false;
        isBottomLoader = false;
      });
    }
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
