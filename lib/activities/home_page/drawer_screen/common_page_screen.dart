import 'dart:io';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/styles.dart';

class CommonViewScreen extends StatefulWidget {
  var title;
  var url;

  CommonViewScreen({required this.title, required this.url});
  @override
  _CommonViewScreenState createState() => _CommonViewScreenState();
}

class _CommonViewScreenState extends State<CommonViewScreen> {
  String kAndroidUserAgent =
      'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: AppColors.topColor,
        shadowColor: Colors.transparent,
      ),
      body: Container(
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
        child: WebView(
          backgroundColor: AppColors.topColor,
          initialUrl: widget.url,
        ),
      ),
    );
  }
}
