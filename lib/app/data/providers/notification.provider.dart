import 'package:get/get.dart';
import 'package:agree_n/app/data/models/notification.model.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/share.model.dart';

class NotificationProvider extends GetConnect {
  Future<NotificationResultModel> getNotifications(PaginationParam param) async {
    try {
      var result = await HttpHelper.post(Endpoints.NOTIFICATION, param);
      return NotificationResultModel.fromJson(result.body);
    } catch (e) {
      return null;
    }
  }

  Future<bool> readAll() async {
    try {
      var result = await HttpHelper.post(
          '${Endpoints.NOTIFICATION}/mark-all-as-read', "");
      return result.body;
    } catch (e) {
      return false;
    }
  }

  Future<void> readNotification(
      ReadNotificationModel readNotificationParam) async {
    try {
      var result = await HttpHelper.post(
          '${Endpoints.NOTIFICATION}/read', readNotificationParam);
      return result.body;
    } catch (e) {
      throw e;
    }
  }
}
