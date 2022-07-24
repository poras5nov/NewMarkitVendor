import 'package:flutter/material.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: GestureDetector(
          onTap: () {
            SharedPref.clear();
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: LoginView()));
          },
          child: const Text(
            "Logout",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        )),
      ),
    );
  }
}
