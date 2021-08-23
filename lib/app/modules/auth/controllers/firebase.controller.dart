import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/notification.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/utils/firebase_helper.dart';
import 'package:agree_n/app/data/models/notification.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/models/firebase_notification.model.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/base/controllers/base.controller.dart';

class FireBaseController extends GetxController {
  static FireBaseController get to => Get.find<FireBaseController>();
  BaseController _baseController = BaseController.to;

  //
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Rx<FirebaseNotificationModel> notificationModel =
      Rx<FirebaseNotificationModel>();
  RxBool _isShowNotification = true.obs;

  set isShowNotification(value) => _isShowNotification.value = value;

  get isShowNotification => _isShowNotification.value;

  Future<void> initFirebase(int userId) async {
    await Firebase.initializeApp();

    await _firebaseMessaging.getToken().then(
      (String token) {
        if (token == null) {
          return;
        }
        debugPrint("FireBase Token: $token");
        // Subscribe Firebase Topic
        _subscribeFirebaseTopic(userId);
      },
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        debugPrint('A new getInitialMessage event was published!');
      }
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        _onReceivedNotification(message);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        _onMessageOpenApp(message);
      },
    );
  }

  void _subscribeFirebaseTopic(int userId) async {
    final String topicId = FirebaseHelper.getTopicByUserId(userId);
    debugPrint(topicId);
    _firebaseMessaging.subscribeToTopic(topicId);
    _firebaseMessaging.subscribeToTopic(
        UserRoleEnum.getName(AuthController.to.currentUser.roleId));
  }

  void unsubscribeFirebaseTopic(int userId) async {
    final String topicId = FirebaseHelper.getTopicByUserId(userId);
    _firebaseMessaging.unsubscribeFromTopic(topicId);
    _firebaseMessaging.unsubscribeFromTopic(
        UserRoleEnum.getName(AuthController.to.currentUser.roleId));
  }

  void _onMessageOpenApp(RemoteMessage message) {
    String type;
    SimpleMessageModel messageData;
    var payload;

    notificationModel.value = FirebaseNotificationModel.fromJson(message.data);
    type = notificationModel.value.type;
    payload = notificationModel.value.payload;

    if (type != FirebaseNotificationType.System) {
      messageData = SimpleMessageModel.fromJson(json.decode(payload));
    }

    //Handle follow app cases
    if (type == FirebaseNotificationType.System) {
      NotificationHelper.navigateToScreen(
        Routes.NOTIFICATION,
      );
    }
    if (type == FirebaseNotificationType.FinalizePending) {
      NotificationHelper.navigateToScreen(
        Routes.FINALIZE_CONTRACT,
        arguments: messageData.conversationId,
      );
    }

    if (type == FirebaseNotificationType.SimpleChat) {
      NotificationHelper.navigateToScreen(
        Routes.CHAT,
        arguments: ChatArgument(
          conversationId: messageData.conversationId,
        ),
      );
    }

    if (type == FirebaseNotificationType.TermChat) {
      NotificationHelper.navigateToScreen(
        Routes.CHAT,
        arguments: ChatArgument(
          conversationId: messageData.conversationId,
        ),
      );
    }
    update();
  }

  void _onReceivedNotification(RemoteMessage message) {
    String type;
    SimpleMessageModel messageData;
    var payload;

    notificationModel.value = FirebaseNotificationModel.fromJson(message.data);
    type = notificationModel.value.type;
    payload = notificationModel.value.payload;

    if (FirebaseNotificationType.System != type && isShowNotification) {
      messageData = SimpleMessageModel.fromJson(json.decode(payload));
    }

    //Handle follow app cases
    if (FirebaseNotificationType.System == type && isShowNotification) {
      _systemMessage(payload);
    }
    if (FirebaseNotificationType.FinalizePending == type &&
        isShowNotification) {
      _finalizeMessage(message.notification.title, messageData);
    }

    if (FirebaseNotificationType.SimpleChat == type && isShowNotification) {
      _chatMessage(message.notification.title, messageData);
    }

    if (FirebaseNotificationType.TermChat == type && isShowNotification) {
      _termMessage(payload, message.notification.title, messageData);
    }
    update();
  }

  void _termMessage(payload, String title, SimpleMessageModel messageData) {
    TermMessageModel messageModel =
        TermMessageModel.fromJson(json.decode(payload)['customData']);
    NotificationHelper.showNotification(
      title,
      "${TermTypeIdEnum.getName(messageModel.termId)}: ${messageData.text}",
      Routes.CHAT,
      arguments: ChatArgument(
        conversationId: messageData.conversationId,
      ),
    );
  }

  void _chatMessage(String title, SimpleMessageModel messageData) {
    NotificationHelper.showNotification(
      title,
      messageData.text,
      Routes.CHAT,
      arguments: ChatArgument(
        conversationId: messageData.conversationId,
      ),
    );
  }

  void _finalizeMessage(String title, SimpleMessageModel messageData) {
    NotificationHelper.showNotification(
      title,
      LocaleKeys.Chat_FinalizeContract.tr,
      Routes.FINALIZE_CONTRACT,
      arguments: messageData.conversationId,
    );
  }

  void _systemMessage(payload) {
    _baseController.updateUnreadNotification();
    NotificationModel data = NotificationModel.fromJson(json.decode(payload));
    NotificationHelper.showNotification(
      data.displayTitle,
      data.displayMessage,
      Routes.NOTIFICATION,
    );
  }
}
