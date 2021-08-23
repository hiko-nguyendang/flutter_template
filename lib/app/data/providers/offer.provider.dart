import 'package:get/get.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/models/user.model.dart';

class OfferProvider extends GetConnect {
  Future<bool> createOffer(OfferModel offerModel) async {
    try {
      final response = await HttpHelper.post(Endpoints.OFFER, offerModel);
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<OfferListResult> offerAdvancedSearch(
      OfferAdvancedSearchModel offerAdvancedSearchModel) async {
    try {
      final response = await HttpHelper.post(
          Endpoints.OFFER_ADVANCED_SEARCH, offerAdvancedSearchModel);
      return OfferListResult.fromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<OfferModel> getOfferDetail(int offerId) async {
    try {
      final response = await HttpHelper.get("${Endpoints.OFFER}/$offerId");
      return OfferModel.fromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateOffer(OfferModel offerModel) async {
    try {
      final response = await HttpHelper.put(
          "${Endpoints.OFFER}/${offerModel.offerId}", offerModel);
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setFavoriteOffer(FavoriteOfferModel favoriteOfferModel) async {
    try {
      final response =
          await HttpHelper.post(Endpoints.FAVORITE_OFFER, favoriteOfferModel);
      return response.body;
    } catch (e) {
      return false;
    }
  }

  ///Request
  Future<OfferListResult> requestSimpleSearch(
      RequestSimpleSearchModel param) async {
    try {
      final response =
          await HttpHelper.post(Endpoints.REQUEST_SIMPLE_SEARCH, param);
      return OfferListResult.fromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<OfferListResult> offerSimpleSearch(
      OfferSimpleSearchModel param) async {
    try {
      final response =
          await HttpHelper.post(Endpoints.OFFER_SIMPLE_SEARCH, param);
      if (response != null) {
        return OfferListResult.fromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<OfferModel> getRequestDetail(int requestId) async {
    try {
      final response = await HttpHelper.get('${Endpoints.REQUEST}/$requestId');
      return OfferModel.fromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<bool> createRequest(OfferModel offerModel) async {
    try {
      final response = await HttpHelper.post(Endpoints.REQUEST, offerModel);
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<bool> upDateRequest(OfferModel createOfferParam) async {
    try {
      final response = await HttpHelper.put(
          '${Endpoints.REQUEST}/${createOfferParam.requestId}',
          createOfferParam);
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<OfferListResult> requestAdvancedSearch(
      OfferAdvancedSearchModel offerAdvancedSearch) async {
    try {
      final response = await HttpHelper.post(
          Endpoints.REQUEST_ADVANCED_SEARCH, offerAdvancedSearch);
      return OfferListResult.fromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateRequest(OfferModel offerModel, int requestId) async {
    try {
      final response =
          await HttpHelper.put("${Endpoints.OFFER}/$requestId", offerModel);
      return response.body;
    } catch (e) {
      return false;
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
