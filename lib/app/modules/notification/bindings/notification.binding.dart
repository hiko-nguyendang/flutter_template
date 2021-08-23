import 'package:get/get.dart';

import 'package:agree_n/app/data/providers/notification.provider.dart';
import 'package:agree_n/app/data/repositories/notification.repository.dart';
import 'package:agree_n/app/modules/notification/controllers/notification.controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(
        repository: NotificationRepository(
          apiClient: NotificationProvider(),
        ),
      ),
    );
  }
}
