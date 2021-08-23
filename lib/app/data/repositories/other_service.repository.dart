import 'package:flutter/material.dart';

import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/other_service.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/providers/other_service.provider.dart';

class OtherServiceRepository {
  final OtherServiceProvider apiClient;

  OtherServiceRepository({@required this.apiClient})
      : assert(apiClient != null);

  Future<PaginationResult> getOffers(OtherServiceParam param) async {
    return await apiClient.getOffers(param);
  }

  Future<bool> updateFavorite(int offerId, bool isFavorite) async {
    return await apiClient.updateFavorite(offerId, isFavorite);
  }

  Future<ConversationDetailModel> getConversation(int offerId) async {
    return await apiClient.getConversation(offerId);
  }
}
