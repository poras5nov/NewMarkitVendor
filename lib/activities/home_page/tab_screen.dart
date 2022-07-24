import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles.dart';
import '../../utils/globals.dart' as globals;
import '../../utils/shared_preferences.dart';
import '../add_services/add_product_and_service_view.dart';

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

class _TabScreenState extends State<TabScreen> {
  final iconList = <IconData>[
    Icons.home,
    Icons.shopping_bag_outlined,
    Icons.notifications_none,
    Icons.brightness_7,
  ];
  var profileData;
  ProfileModel model = ProfileModel();
  bool isReject = false;

  @override
  void initState() {
    super.initState();
    SharedPref.getProfileData().then((value) {
      profileData = json.decode(value);
      model = ProfileModel.fromJson(profileData);

      print(model.data!.documents!.length);

      setState(() {});
    });
  }

  var _bottomNavIndex = 0;
  AnimationController? _animationController;
  Animation<double>? animation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerViewScreen(),
      body: Container(
          child: _bottomNavIndex == 0
              ? HomeScreen()
              : _bottomNavIndex == 1
                  ? ShopingCartScreen()
                  : _bottomNavIndex == 2
                      ? BellScreen()
                      : _bottomNavIndex == 3
                          ? SettingScreen()
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
          if (model.data!.businesses!.isVerified.toString() == "Yes") {
            setState(() {
              _bottomNavIndex = -1;
            });
            _animationController!.reset();
            _animationController!.forward();
          } else {}
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
}
