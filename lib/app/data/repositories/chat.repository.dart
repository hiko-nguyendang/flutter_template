import 'dart:io';
import 'package:flutter/material.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/providers/chat.provider.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';

class ChatRepository {
  final ChatProvider apiClient;

  ChatRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<HttpResponse> getConversations(LoadParamModel searchModel) async {
    return await apiClient.getConversations(searchModel);
  }

  Future<HttpResponse> createConversations(
      CreateConversationInputModel inputModel) async {
    return await apiClient.createConversation(inputModel);
  }

  Future<DataResultModel> getMessages(
      String conversationId, int skipMessage) async {
    return await apiClient.getMessages(conversationId, skipMessage);
  }

  Future<ConversationDetailModel> getConversationDetail(
      String conversationId) async {
    return await apiClient.getConversationDetail(conversationId);
  }

  Future<String> sendMessage(
      MessageInputModel messageInputModel, String conversationId) async {
    return await apiClient.sendMessage(messageInputModel, conversationId);
  }

  Future<bool> confirmTerm(
      String conversationId, MessageInputModel messageInputModel) async {
    return await apiClient.confirmTerm(conversationId, messageInputModel);
  }

  Future<String> uploadAttachment(File fileUpload) async {
    return await apiClient.uploadAttachment(fileUpload);
  }

  Future<void> deleteConversation(String conversationId) async {
    return await apiClient.deleteConversation(conversationId);
  }
}
