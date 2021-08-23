import 'package:flutter/material.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/providers/contract.provider.dart';

class ContractRepository {
  final ContractProvider apiClient;

  ContractRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<HttpResponse> getOpenContractSearch(
      OpenContractAdvanceSearchModel openContractAdvanceSearchModel) async {
    return await apiClient
        .getOpenContractSearch(openContractAdvanceSearchModel);
  }

  Future<HttpResponse> getPastContractDetailVolume(
      PastContractFilterParam pastContractFilterParam) async {
    return await apiClient.getPastContractDetailVolume(pastContractFilterParam);
  }

  Future<HttpResponse> getPastContractDetailPrice(
      PastContractFilterParam pastContractFilterParam) async {
    return await apiClient.getPastContractDetailPrice(pastContractFilterParam);
  }

  Future<HttpResponse> getPastContractDetailPerformance(
      PastContractFilterParam pastContractFilterParam) async {
    return await apiClient
        .getPastContractDetailPerformance(pastContractFilterParam);
  }

  Future<HttpResponse> createContract(CreateContractModel param) async {
    return await apiClient.createContract(param);
  }

  Future<List<ContractStatusModel>> getContractStatus(int tenantId) async {
    return await apiClient.getContractStatus(tenantId);
  }

  Future<List<SupplierModel>> getSuppliers() async {
    return apiClient.getSuppliers();
  }

  Future<HttpResponse> getPastContractVolume(
      PastContractFilterParam param) async {
    return await apiClient.getPastContractVolume(param);
  }

  Future<HttpResponse> getPastContractPrice(
      PastContractFilterParam param) async {
    return await apiClient.getPastContractPrice(param);
  }

  Future<HttpResponse> getPastContractPerformance(
      PastContractFilterParam param) async {
    return await apiClient.getPastContractPerformance(param);
  }

  Future<bool> getOTPCode(int offerNegotiationId) async {
    return await apiClient.getOTPCode(offerNegotiationId);
  }

  Future<String> finalizeContract(int offerNegotiationId) async {
    return await apiClient.finalizeContract(offerNegotiationId);
  }

  Future<ConversationDetailModel> getConversationDetail(
      String conversationId) async {
    return await apiClient.getConversationDetail(conversationId);
  }

  Future<bool> sendFinalizeMessage(
      MessageInputModel messageInputModel, String conversationId) async {
    return await apiClient.sendFinalizeMessage(messageInputModel, conversationId);
  }

  Future<List<BaseModel>> getCoverMonth(int commodityId)async {
    return await apiClient.getCoverMonth(commodityId);
  }
}
