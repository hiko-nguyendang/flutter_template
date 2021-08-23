import 'dart:io';
import 'package:get/get.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';

class ChatProvider extends GetConnect {
  Future<HttpResponse> createConversation(
      CreateConversationInputModel inputModel) async {
    return await HttpHelper.post(
        '${Endpoints.CHAT}/create', inputModel.toJson());
  }

  Future<HttpResponse> getConversations(LoadParamModel loadParamModel) async {
    return await HttpHelper.post(Endpoints.CHAT, loadParamModel.toJson());
  }

  Future<DataResultModel> getMessages(
      String conversationId, int skipMessage) async {
    try {
      final HttpResponse response = await HttpHelper.get(
          '${Endpoints.CHAT}/$conversationId/messages?skip=$skipMessage');
      if (response.statusCode == 200) {
        final DataResultModel dataResultModel =
            DataResultModel.fromJson(response.body);

        return dataResultModel;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ConversationDetailModel> getConversationDetail(
      String conversationId) async {
    try {
      final HttpResponse response =
          await HttpHelper.get('${Endpoints.CHAT}/$conversationId');
      if (response.body != null) {
        return ConversationDetailModel.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> sendMessage(
      MessageInputModel messageInputModel, String conversationId) async {
    try {
      final HttpResponse response = await HttpHelper.post(
          '${Endpoints.CHAT}/$conversationId/messages/send', messageInputModel);
      if (response.body != null) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> confirmTerm(
      String conversationId, MessageInputModel messageInputModel) async {
    try {
      final response = await HttpHelper.put(
          '${Endpoints.CHAT}/$conversationId/terms/reply', messageInputModel);
      if (response.body == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadAttachment(File fileUpload) async {
    try {
      final response = await HttpHelper.uploadFile(
          '${Endpoints.UPLOAD}/${FileUploadTypeEnum.MessageAttachment}',
          file: fileUpload);
      return response.body;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      final response =
          await HttpHelper.delete('${Endpoints.CHAT}/$conversationId');
      return response.body;
    } catch (e) {
      return null;
    }
  }
}
