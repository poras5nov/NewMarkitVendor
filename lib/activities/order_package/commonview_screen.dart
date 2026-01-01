import 'package:flutter/material.dart';
import 'package:market_vendor_app/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const CommonViewScreen({required this.title, required this.url, super.key});

  @override
  State<CommonViewScreen> createState() => _CommonViewScreenState();
}

class _CommonViewScreenState extends State<CommonViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: AppColors.primaryColor,
          shadowColor: Colors.transparent,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          title: Text(widget.title),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              Colors.white,
            ],
          )),
          child: WebViewWidget(controller: controller),
        ),
      );
}
