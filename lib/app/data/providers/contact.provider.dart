import 'dart:convert';
import 'package:get/get.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/mock/contact.mock.dart';
import 'package:agree_n/app/data/models/contact.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';

class ContactProvider extends GetConnect {

  Future<ContactResultModel> getContacts(ContactParamModel contactParam) async {
    try{
      final response =
      await HttpHelper.post(Endpoints.LIST_CONTACT, contactParam);
      return ContactResultModel.fromJson(response.body);
    }catch(e){
      return null;
    }
  }

  Future<HttpResponse> getContactRate(int contactId) async {
    await Future.delayed(Duration(seconds: 1));
    final result = ContactMock.getTenant();
    return HttpResponse(body: json.encode(result), statusCode: 200);
  }

  Future<ConversationDetailModel> getConversation(int tenantId) async {
    try{
      final response =
      await HttpHelper.get("${Endpoints.CONVERSATION}/$tenantId");
     if(response != null){
       return ConversationDetailModel.fromJson(response.body);
     }
     return null;
    }catch(e){
      return null;
    }
  }

}
