import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:market_vendor_app/activities/home_page/tab/my_order.dart';
import 'package:market_vendor_app/utils/notification_receiver.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles.dart';
import '../../utils/globals.dart' as globals;
import '../../utils/notification_show.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/utility.dart';
import '../add_services/add_product_and_service_view.dart';

import 'drawer_screen/rating_screen.dart';
import 'drawer_view.dart';
import 'model/profile_model.dart';
import 'tab/bell_screen.dart';
import 'tab/home_screen.dart';
import 'tab/setting_screen.dart';
import 'tab/shoping_cart_screen.dart';
import 'tab/verified_screen.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    implements NotificationInterface {
  final iconList = <IconData>[
    Icons.home,
    Icons.shopping_bag_outlined,
    Icons.star,
    Icons.account_circle,
  ];
  var profileData;
  ProfileModel model = ProfileModel();
  getData() {
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);

      print(model.data!.documents!.length);

      setState(() {});
    });
  }

  bool isReject = false;
  var token;
  @override
  void initState() {
    super.initState();
    Utility.facebookEvent("home_screen");

    NotificationShow.initPlatformState(this);
    getToken();
    getData();
  }

  getToken() {
    SharedPref.getLoginToken().then((value) {
      token = value;
    });
  }

  var _bottomNavIndex = 0;
  AnimationController? _animationController;
  Animation<double>? animation;
  String totalorder = "";
  String totalRevenue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerViewScreen(
        model: model,
        token: token,
        totalOrder: totalorder,
        totalRevenue: totalRevenue,
        callBack: (v) {
          _bottomNavIndex = v;
          setState(() {});
        },
      ),
      body: Container(
          child: _bottomNavIndex == 0
              ? HomeScreen(
                  totalOrders: (v) {
                    totalorder = v;
                    setState(() {});
                  },
                  totalRevenue: (v) {
                    totalRevenue = v;
                    setState(() {});
                  },
                )
              : _bottomNavIndex == 1
                  ? MyOrderScreen(
                      callBack: (v) {
                        _bottomNavIndex = v;
                        getData();
                        setState(() {});
                      },
                    )
                  : _bottomNavIndex == 2
                      ? RatingScreen(
                          callBack: (v) {
                            _bottomNavIndex = v;
                            getData();
                            setState(() {});
                          },
                        )
                      : _bottomNavIndex == 3
                          ? MyAccountSettingScreen(
                              callBack: (v) {
                                _bottomNavIndex = v;
                                getData();
                                setState(() {});
                              },
                            )
                          : AddProductAndServiceScreen(
                              isProductScreen: false,
                            )),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          size: 24,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _bottomNavIndex = -1;
          });
          _animationController!.reset();
          _animationController!.forward();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? AppColors.primaryColor : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 24,
                color: color,
              ),
              const SizedBox(height: 4),
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        splashColor: Colors.white,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        onTap: (index) => setState(() => _bottomNavIndex = index),
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
