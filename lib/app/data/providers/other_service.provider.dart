import 'package:get/get.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/models/other_service.model.dart';

class OtherServiceProvider extends GetConnect {
  Future<PaginationResult> getOffers(OtherServiceParam param) async {
    try {
      final response = await HttpHelper.post(
          '${Endpoints.OTHER_SERVICE}/advance-search-offers', param);
      return PaginationResult.fromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateFavorite(int offerId, bool isFavorite) async {
    final param = {"OtherServiceOfferId": offerId, "IsFavorite": !isFavorite};
    try {
      final response =
          await HttpHelper.post('${Endpoints.OTHER_SERVICE}/favorite', param);
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<ConversationDetailModel> getConversation(int offerId) async {
    try{
      final response =
      await HttpHelper.get("${Endpoints.CHAT}/other-services/offers/$offerId");
      if(response != null){
        return ConversationDetailModel.fromJson(response.body);
      }
      return null;
    }catch(e){
      return null;
    }
  }
}
