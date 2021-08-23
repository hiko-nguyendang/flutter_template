import 'dart:io';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

//
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/settings/app_config.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "${AppConfig.WEB_URL}/sign-up",
            onPageFinished: (url) {
              MessageDialog.hideLoading();
            },
            onPageStarted: (url) {
              MessageDialog.showLoading();
            },
          ),
          Positioned(
            top: 15,
            left: 0,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_outlined),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
