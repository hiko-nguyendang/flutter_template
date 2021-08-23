import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/notification.model.dart';
import 'package:agree_n/app/modules/base/controllers/base.controller.dart';
import 'package:agree_n/app/data/repositories/notification.repository.dart';

class NotificationController extends GetxController {
  NotificationRepository repository;

  NotificationController({@required this.repository})
      : assert(repository != null);

  static NotificationController to = Get.find();
  BaseController _baseController = BaseController.to;
  RefreshController refreshController = RefreshController();

  RxList<NotificationModel> notifications = RxList<NotificationModel>();
  Rx<PaginationParam> _param = PaginationParam(
    pageSize: 10,
    pageNumber: 1,
  ).obs;
  ReadNotificationModel _readNotificationParam =
      ReadNotificationModel(isRead: true);

  RxInt _totalCount = 0.obs;
  RxBool isLoading = false.obs;

  bool get hasMore => _totalCount.value > notifications.length;

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Future<void> getNotifications({bool isReload = true}) async {
    if (isReload) {
      isLoading.value = true;
      _param.value.pageNumber = 1;
      if (notifications.isNotEmpty) {
        notifications.clear();
      }
      update();
    }

    await repository.getNotifications(_param.value).then(
      (response) {
        if (response != null) {
          _param.value.pageNumber += 1;
          notifications.addAll(response.objects);
          _totalCount.value = response.totalCount;
        } else {
          MessageDialog.showError();
        }
        isLoading.value = false;
        if (isReload) {
          refreshController.refreshCompleted();
        } else {
          refreshController.loadComplete();
        }
        update();
      },
    );
  }

  void readAll() {
    for (var item in notifications) {
      item.isUnread = false;
    }
    update();
    _baseController.resetUnreadNotification();
    repository.readAll();
  }

  void readNotification(int notificationId) {
    notifications
        .firstWhere((_) => _.notificationId == notificationId)
        .isUnread = false;
    _readNotificationParam.notificationId = notificationId;
    repository.readNotification(_readNotificationParam);
    update();
  }
}
