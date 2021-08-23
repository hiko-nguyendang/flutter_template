import 'package:flutter/material.dart';

import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/providers/offer.provider.dart';

class OfferRepository {
  final OfferProvider apiClient;

  OfferRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<OfferListResult> offerAdvancedSearch(
      OfferAdvancedSearchModel advancedSearchModel) async {
    return await apiClient.offerAdvancedSearch(advancedSearchModel);
  }

  Future<bool> createOffer(OfferModel offerModel) async {
    return await apiClient.createOffer(offerModel);
  }

  Future<bool> updateOffer(OfferModel offerModel) async {
    return await apiClient.updateOffer(offerModel);
  }

  Future<OfferModel> getOfferDetail(int offerId) async {
    return await apiClient.getOfferDetail(offerId);
  }

  Future<bool> setFavoriteOffer(FavoriteOfferModel favoriteOfferModel) async {
    return await apiClient.setFavoriteOffer(favoriteOfferModel);
  }

  ///Request
  Future<bool> createRequest(OfferModel offerModel) async {
    return await apiClient.createRequest(offerModel);
  }

  Future<OfferListResult> requestSimpleSearch(
      RequestSimpleSearchModel param) async {
    return await apiClient.requestSimpleSearch(param);
  }

  Future<OfferListResult> offerSimpleSearch(
      OfferSimpleSearchModel param) async {
    return await apiClient.offerSimpleSearch(param);
  }


  Future<OfferModel> getRequestDetail(int requestId) async {
    return await apiClient.getRequestDetail(requestId);
  }

  Future<List<SupplierModel>> getSuppliers() async {
    return apiClient.getSuppliers();
  }

  Future<OfferListResult> requestAdvancedSearch(OfferAdvancedSearchModel offerAdvancedSearch) async {
    return await apiClient.requestAdvancedSearch(offerAdvancedSearch);
  }

  Future<bool> updateRequest(OfferModel createOfferParam) async {
    return await apiClient.upDateRequest(createOfferParam);
  }

  Future<List<BaseModel>> getCoverMonth(int commodityId)async {
    return await apiClient.getCoverMonth(commodityId);
  }
}
