import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/repositories/chat.repository.dart';
import 'package:agree_n/app/data/models/firebase_notification.model.dart';
import 'package:agree_n/app/modules/auth/controllers/firebase.controller.dart';

class ConversationController extends GetxController {
  final ChatRepository repository;

  ConversationController({@required this.repository})
      : assert(repository != null);

  static ConversationController get to => Get.find();
  FireBaseController _fireBaseController = FireBaseController.to;

  RefreshController refreshController = RefreshController();
  RxList<ConversationModel> conversations = RxList<ConversationModel>();
  LoadParamModel loadParamModel = LoadParamModel(
    customParams: ConversationSearchModel(),
    loadOptions: DataSourceLoadOptions(take: 20),
  );

  RxBool isLoading = false.obs;
  int _totalCount = 0;
  int _pageIndex = 0;

  bool get hasMore => _totalCount > conversations.length;

  @override
  void onInit() {
    _fireBaseController.isShowNotification = false;
    ever(_fireBaseController.notificationModel, _onReceivedMessage);
    super.onInit();
  }

  void _onReceivedMessage(FirebaseNotificationModel notificationModel) {
    SimpleMessageModel messageModel = SimpleMessageModel.fromJson(
      json.decode(notificationModel.payload),
    );

    if (notificationModel.type != FirebaseNotificationType.System) {
      var updateConversation = conversations.firstWhere(
          (_) => _.id == messageModel.conversationId,
          orElse: () => ConversationModel());
      if (updateConversation.id == null) {
        getConversation();
      } else {
        updateConversation.lastMessage = messageModel.text;
        updateConversation.unreadMessageCount += 1;
        conversations.remove(updateConversation);
        conversations.insert(0, updateConversation);
        update();
      }
    }
  }

  Future<void> getConversation({bool isReload = true, String keyword = ''}) async {
    if (isReload) {
      _pageIndex = 0;
      isLoading.value = true;
      conversations.clear();
      loadParamModel.loadOptions.skip = 0;
      update();
    }

    try {
      loadParamModel.loadOptions.skip =
          _pageIndex * loadParamModel.loadOptions.take;
      loadParamModel.loadOptions.searchValue = keyword;
      await repository.getConversations(loadParamModel).then(
        (response) {
          if (response.statusCode == APIStatus.Successfully) {
            DataResultModel dataResultModel =
                DataResultModel.fromJson(response.body);

            List<ConversationModel> result = dataResultModel.data
                .map<ConversationModel>(
                    (item) => new ConversationModel.fromJson(item))
                .toList();
            conversations.addAll(result);
            refreshController.loadComplete();
            _totalCount = dataResultModel.totalCount;
            _pageIndex++;
          }
          isLoading.value = false;
          update();
        },
      );
    } catch (e) {
      isLoading.value = false;
      update();

      MessageDialog.showError(message: LocaleKeys.Shared_ErrorMessage.tr);
      throw e;
    }
  }

  String getLastMessageTime(DateTime messageTime) {
    if (DateFormat('dd MM yyyy').format(messageTime) !=
        DateFormat('dd MM yyyy').format(DateTime.now())) {
      return DateFormat('dd/MM/yyyy').format(messageTime);
    }

    return DateFormat('hh:mm').format(messageTime);
  }

  void deleteConversation(String conversationId) {
    conversations.removeWhere((_) => _.id == conversationId);
    repository.deleteConversation(conversationId);
    update();
  }
}
