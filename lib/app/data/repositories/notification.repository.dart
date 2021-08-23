import 'package:flutter/material.dart';

import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/notification.model.dart';
import 'package:agree_n/app/data/providers/notification.provider.dart';

class NotificationRepository {
  final NotificationProvider apiClient;

  NotificationRepository({@required this.apiClient})
      : assert(apiClient != null);

  Future<NotificationResultModel> getNotifications(
      PaginationParam param) async {
    return await apiClient.getNotifications(param);
  }

  Future<bool> readAll() async {
    return await apiClient.readAll();
  }

  Future<void> readNotification(
      ReadNotificationModel readNotificationParam) async {
    return await apiClient.readNotification(readNotificationParam);
  }
}
