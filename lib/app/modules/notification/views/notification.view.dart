import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/data/models/notification.model.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/notification/controllers/notification.controller.dart';

class NotificationView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: _buildNotifications(),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildNotifications() {
    return GetBuilder<NotificationController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (controller.notifications.isEmpty) {
          return Center(
            child: Text(
              LocaleKeys.Notifications_EmptyList.tr,
              style: TextStyle(
                fontSize: 16,
                color: kPrimaryGreyColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: SmartRefresher(
                footer: LoadingBottomWidget(),
                enablePullDown: true,
                enablePullUp: controller.hasMore,
                onLoading: () {
                  controller.getNotifications(isReload: false);
                },
                onRefresh: () {
                  controller.getNotifications();
                },
                controller: controller.refreshController,
                child: ListView.builder(
                  primary: false,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return _buildNotificationItem(notification, controller);
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.readAll();
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: kPrimaryColor.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  LocaleKeys.Notifications_MarkAllAsRead.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationItem(
      NotificationModel notification, NotificationController controller) {
    return GestureDetector(
      onTap: () {
        if (notification.isUnread) {
          controller.readNotification(notification.notificationId);
        }
      },
      child: ShadowBox(
        margin: const EdgeInsets.symmetric(
          horizontal: kHorizontalContentPadding,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: kPrimaryGreyColor.withOpacity(0.5),
                child: notification.creatorUrlImage == null ||
                        notification.creatorUrlImage.isEmpty
                    ? Text(
                        '${notification.creatorFirstName[0]}'
                        '${notification.creatorLastName[0].toUpperCase()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: kPrimaryGreyColor, width: 0.5),
                          image: DecorationImage(
                            image: NetworkImage(notification.creatorUrlImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.displayTitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: notification.isUnread
                          ? Colors.black
                          : kPrimaryGreyColor,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 2,
                  ),
                  SizedBox(height: 5),
                  Text(
                    notification.displayMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: notification.isUnread
                          ? Colors.black
                          : kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      timeAgo.format(notification.createdDate,
                          locale: Get.locale.languageCode),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
