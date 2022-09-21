import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_vendor_app/activities/build_your_profile/build_your_profile_view.dart';
import 'package:market_vendor_app/activities/forgot_password/forgot_password_view.dart';
import 'package:market_vendor_app/activities/get_started/get_started_view.dart';
import 'package:market_vendor_app/activities/home_page/tab/verified_screen.dart';
import 'package:market_vendor_app/activities/login/login_view.dart';
import 'package:market_vendor_app/activities/login_with_otp/login_with_otp_view.dart';
import 'package:market_vendor_app/activities/splash/splash_view.dart';
import 'package:market_vendor_app/utils/notification_receiver.dart';
import 'package:market_vendor_app/utils/notification_show.dart';
import 'package:market_vendor_app/utils/shared_preferences.dart';

import 'activities/home_page/tab_screen.dart';
import 'utils/new_market_vendor_localizations.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements NotificationInterface {
  @override
  void initState() {
    super.initState();
    NotificationShow.initPlatformState(this);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_) {
          // ignore: prefer_const_constructors
          return MaterialApp(
            title: "New Market",
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            home: const SplashView(),
            locale: const Locale('en'),
            supportedLocales: const [
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              NewMarkitVendorLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            routes: <String, WidgetBuilder>{
              '/LoginView': (BuildContext context) => LoginView(),
              '/LoginWithOTPView': (BuildContext context) => LoginWithOTPView(),
              '/GetStartedView': (BuildContext context) => GetStartedView(),
              '/BuildYourProfileView': (BuildContext context) =>
                  BuildYourProfileView(),
              '/ForgotPasswordView': (BuildContext context) =>
                  ForgotPasswordView(),
              '/TabScreen': (BuildContext context) => TabScreen(),
              '/VerifiedScreen': (BuildContext context) => VerifiedScreen(),
            },
          );
        });
  }

  @override
  void onClick(id, type, requestId) {
    SharedPref.setOrderID(id.toString());
    SharedPref.setOrderType(type);
    SharedPref.setRequestOrderId(requestId.toString());
  }

  @override
  void onMessageReceived(id, type) {
    SharedPref.setOrderID(id);
  }
}
