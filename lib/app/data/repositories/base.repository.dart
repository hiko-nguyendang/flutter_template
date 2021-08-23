import 'package:flutter/material.dart';

import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/providers/base.provider.dart';
import 'package:agree_n/app/data/models/notification.model.dart';

class BaseRepository{
  final BaseProvider apiClient;

  BaseRepository({@required this.apiClient})
      : assert(apiClient != null);

  Future<NotificationResultModel> getNotifications(
      PaginationParam param) async {
    return await apiClient.getNotifications(param);
  }
}