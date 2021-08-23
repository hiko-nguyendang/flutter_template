import 'package:get/get.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';

class ContractProvider extends GetConnect {
  //Open Contract
  Future<HttpResponse> getOpenContractSearch(
      OpenContractAdvanceSearchModel openContractAdvanceSearchModel) async {
    return HttpHelper.post(
        Endpoints.OPEN_CONTRACT_SEARCH, openContractAdvanceSearchModel);
  }

  //Past Contract
  Future<HttpResponse> getPastContractDetailVolume(
      PastContractFilterParam pastContractFilterParam) async {
    return HttpHelper.post(
        Endpoints.PAST_CONTRACT_VOLUME_DETAIL, pastContractFilterParam);
  }

  Future<HttpResponse> getPastContractDetailPrice(
      PastContractFilterParam pastContractFilterParam) async {
    return HttpHelper.post(
        Endpoints.PAST_CONTRACT_PRICE_DETAIL, pastContractFilterParam);
  }

  Future<HttpResponse> getPastContractDetailPerformance(
      PastContractFilterParam pastContractFilterParam) async {
    return HttpHelper.post(
        Endpoints.PAST_CONTRACT_PERFORMANCE_DETAIL, pastContractFilterParam);
  }

  Future<HttpResponse> getPastContractVolume(
      PastContractFilterParam param) async {
    return HttpHelper.post(Endpoints.PAST_CONTRACT_VOLUME, param);
  }

  Future<HttpResponse> getPastContractPrice(
      PastContractFilterParam param) async {
    return HttpHelper.post(Endpoints.PAST_CONTRACT_PRICE, param);
  }

  Future<HttpResponse> getPastContractPerformance(
      PastContractFilterParam param) async {
    return HttpHelper.post(Endpoints.PAST_CONTRACT_PERFORMANCE, param);
  }

  Future<HttpResponse> createContract(CreateContractModel param) async {
    try {
      return HttpHelper.post(Endpoints.CONTRACT, param);
    } catch (e) {
      return null;
    }
  }

  Future<List<ContractStatusModel>> getContractStatus(int tenantId) async {
    try {
      final HttpResponse response =
          await HttpHelper.get('${Endpoints.CONTACT}/$tenantId/status');
      if (response.body != null) {
        final result = response.body
            .map<ContractStatusModel>(
                (model) => ContractStatusModel.fromJson(model))
            .toList();
        return result;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final response = await HttpHelper.get('${Endpoints.SUPPLIER}');
      var result = response.body
          .map<SupplierModel>((item) => SupplierModel.fromJson(item))
          .toList();
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<bool> getOTPCode(int offerNegotiationId) async {
    try {
      final response = await HttpHelper.get(
          '${Endpoints.CHAT}/$offerNegotiationId/send-verification-code');
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<String> finalizeContract(int offerNegotiationId) async {
    final param = {"offerNegotiationId": offerNegotiationId};
    try {
      final response =
          await HttpHelper.post('${Endpoints.CHAT}/finalize', param);
      return response.body;
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

  Future<bool> sendFinalizeMessage(
      MessageInputModel messageInputModel, String conversationId) async {
    try {
      final HttpResponse response = await HttpHelper.post(
          '${Endpoints.CHAT}/$conversationId/messages/send', messageInputModel);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<BaseModel>> getCoverMonth(int commodityId) async {
    try {
      final response = await HttpHelper.get(
          '${Endpoints.CONTRACT}/cover-months/$commodityId');
      var result = response.body
          .map<BaseModel>((item) => BaseModel.fromJson(item))
          .toList();
      return result;
    } catch (e) {
      return null;
    }
  }
}
