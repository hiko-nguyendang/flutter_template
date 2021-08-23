import 'package:agree_n/app/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:agree_n/app/data/models/share.model.dart';

part 'offer.model.g.dart';

@JsonSerializable()
class OfferModel {
  int offerId;
  final int requestId;
  int userId;
  int tenantId;
  String supplierName;
  DateTime createdDate;
  double rating;
  int commodityId;
  int contractTypeId;
  double quantity;
  int quantityUnitTypeId;
  double packingQuantity;
  int packingUnitTypeId;
  int gradeTypeId;
  int coffeeTypeId;
  double price;
  int priceUnitTypeId;
  DateTime deliveryDate;
  DateTime validityDate;
  String coverMonth;
  int audienceTypeId;
  int deliveryTermId;
  int deliveryWarehouseId;
  String specialClause;
  String comment;
  int certificationId;
  bool isFavoriteOffer;
  int totalPerson;
  List<String> people;
  List<int> audienceTenantIds;
  String conversationId;

  //UI Only
  @JsonKey(ignore: true)
  String supplierNames;

  OfferModel(
      {int offerId,
      this.createdDate,
      this.rating,
      this.supplierName,
      this.price,
      this.quantity,
      this.contractTypeId,
      this.specialClause,
      this.deliveryTermId,
      this.totalPerson,
      this.isFavoriteOffer,
      this.coverMonth,
      this.comment,
      this.deliveryWarehouseId,
      this.certificationId,
      this.deliveryDate,
      this.priceUnitTypeId,
      this.validityDate,
      int userId,
      this.packingQuantity,
      int tenantId,
      this.audienceTypeId,
      this.coffeeTypeId,
      this.commodityId,
      this.gradeTypeId,
      this.packingUnitTypeId,
      this.people,
      this.quantityUnitTypeId,
      List<int> audienceTenantIds,
      int requestId,
      this.conversationId})
      : audienceTenantIds = audienceTenantIds ?? [],
        userId = userId ?? 0,
        tenantId = tenantId ?? 0,
        offerId = offerId ?? 0,
        requestId = requestId ?? 0;

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferModelToJson(this);
}

@JsonSerializable()
class OfferListResult {
  final List<OfferModel> objects;
  final int totalCount;

  OfferListResult({this.objects, this.totalCount});

  factory OfferListResult.fromJson(Map<String, dynamic> json) =>
      _$OfferListResultFromJson(json);

  Map<String, dynamic> toJson() => _$OfferListResultToJson(this);
}

@JsonSerializable()
class OfferAdvancedSearchModel extends PaginationParam {
  int filterTypeId;
  String keyword;
  List<int> quantityUnitTypeIds;
  int startQuantity;
  int endQuantity;
  int gradeTypeId;
  List<int> contractTypeIds;
  List<int> warehouseIds;
  DateTime validityStartDate;
  DateTime validityEndDate;
  DateTime deliveryStartDate;
  DateTime deliveryEndDate;
  int deliveryTermId;
  List<int> audienceTypeIds;
  List<int> coverMonths;
  int statusId;

  OfferAdvancedSearchModel(
      {List<int> coverMonths,
      List<int> contractTypeIds,
      List<int> quantityUnitTypeIds,
      List<int> audienceTypeIds,
      List<int> locationIds,
      this.gradeTypeId,
      this.deliveryTermId,
      this.deliveryEndDate,
      this.deliveryStartDate,
      int endQuantity,
      int startQuantity,
      this.validityEndDate,
      this.validityStartDate,
      this.filterTypeId,
      this.keyword,
      this.statusId})
      : quantityUnitTypeIds = quantityUnitTypeIds ?? [],
        coverMonths = coverMonths ?? [],
        contractTypeIds = contractTypeIds ?? [],
        audienceTypeIds = audienceTypeIds ?? [],
        warehouseIds = locationIds ?? [],
        endQuantity = endQuantity ?? QuantityEnum.QuantityMax.toInt(),
        startQuantity = startQuantity ?? QuantityEnum.QuantityMin.toInt();

  factory OfferAdvancedSearchModel.fromJson(Map<String, dynamic> json) =>
      _$OfferAdvancedSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferAdvancedSearchModelToJson(this);
}

@JsonSerializable()
class RequestSimpleSearchModel extends PaginationParam {
  int requestStatusId;
  String keyword;

  RequestSimpleSearchModel({this.requestStatusId, this.keyword});

  factory RequestSimpleSearchModel.fromJson(Map<String, dynamic> json) =>
      _$RequestSimpleSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestSimpleSearchModelToJson(this);
}

@JsonSerializable()
class OfferSimpleSearchModel extends PaginationParam {
  String keyword;
  int filterTypeId;
  int statusId;

  OfferSimpleSearchModel({this.keyword, this.filterTypeId, this.statusId});

  factory OfferSimpleSearchModel.fromJson(Map<String, dynamic> json) =>
      _$OfferSimpleSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferSimpleSearchModelToJson(this);
}

@JsonSerializable()
class FavoriteOfferModel {
  int offerId;
  int userId;
  bool isFavorite;

  FavoriteOfferModel({this.offerId, this.userId, this.isFavorite});

  factory FavoriteOfferModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteOfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteOfferModelToJson(this);
}
