import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NotificationHelper {
  static void showNotification(String title, String content, String routeName,
      {dynamic arguments}) {
    Get.snackbar(
      title,
      content,
      titleText: Text(
        title,
      ),
      messageText: Text(
        content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.white,
      icon: Image.asset(
        'assets/images/logo.png',
        width: 50,
        height: 50,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      borderRadius: 5,
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      duration: Duration(seconds: 5),
      onTap: (_) {
        Get.toNamed(routeName, arguments: arguments);
      },
    );
  }

  static void navigateToScreen(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }
}
