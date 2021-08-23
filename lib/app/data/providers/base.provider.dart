import 'package:get/get.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/notification.model.dart';

class BaseProvider extends GetConnect{
  Future<NotificationResultModel> getNotifications(
      PaginationParam param) async {
    try {
      var result = await HttpHelper.post(Endpoints.NOTIFICATION, param);
      return NotificationResultModel.fromJson(result.body);
    } catch (e) {
      return null;
    }
  }
}
