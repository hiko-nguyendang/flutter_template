import 'package:flutter/material.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/data/models/contact.model.dart';
import 'package:agree_n/app/data/providers/contact.provider.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';

class ContactRepository {
  final ContactProvider apiClient;

  ContactRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<HttpResponse> getContactRate(int contactId) async {
    return await apiClient.getContactRate(contactId);
  }

  Future<ContactResultModel> getContacts(ContactParamModel contactParam) async {
    return await apiClient.getContacts(contactParam);
  }

  Future<ConversationDetailModel> getConversation(int tenantId) async {
    return await apiClient.getConversation(tenantId);
  }
}
