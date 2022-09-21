import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_vendor_app/activities/order_package/accept_order.dart';
import 'package:market_vendor_app/activities/order_package/decline_orders.dart';
import 'package:market_vendor_app/activities/order_package/delivered_order.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/styles.dart';
import '../../../utils/new_market_vendor_localizations.dart';
import '../../../utils/notification_receiver.dart';
import '../../../utils/notification_show.dart';
import '../../order_package/pending_order.dart';

class ShopingCartScreen extends StatefulWidget {
  Function(int)? callBack;
  ShopingCartScreen({required this.callBack});
  @override
  _ShopingCartScreenState createState() => _ShopingCartScreenState();
}

class _ShopingCartScreenState extends State<ShopingCartScreen>
    with TickerProviderStateMixin
    implements NotificationInterface {
  TabController? _controller;
  int _selectedIndex = 0;
  @override
  void initState() {
    NotificationShow.initPlatformState(this);

    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: [
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
            child: Column(children: [
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
                            widget.callBack!(0);
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, right: 16, left: 16, bottom: 8),
                          child: TabBar(
                            controller: _controller,
                            indicator: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(10), // Creates border
                                color: AppColors.primaryColor),
                            unselectedLabelColor: AppColors.greyColor,
                            unselectedLabelStyle: Styles.unsSelectedText12,
                            labelStyle: Styles.selectedText12,
                            tabs: [
                              Tab(
                                  child: Text(
                                      '${NewMarkitVendorLocalizations.of(context)!.find('accepted')}(2)')),
                              Tab(
                                  child: Text(
                                      '${NewMarkitVendorLocalizations.of(context)!.find('pending')}(2)')),
                              Tab(
                                  child: Text(
                                      '${NewMarkitVendorLocalizations.of(context)!.find('delivered')}(3)')),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: TabBarView(
                              controller: _controller,
                              children: [
                                AcceptOrderScreen(),
                                PedningOrderScreen(),
                                DeliveredOrderScreen(),
                              ],
                            ),
                          ),
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

  @override
  void onClick(id, type, requestId) {
    // TODO: implement onClick
  }

  @override
  void onMessageReceived(id, type) {
    // TODO: implement onMessageReceived
  }
}
