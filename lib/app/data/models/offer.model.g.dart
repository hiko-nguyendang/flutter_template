// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) {
  return OfferModel(
    offerId: json['offerId'] as int,
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    rating: (json['rating'] as num)?.toDouble(),
    supplierName: json['supplierName'] as String,
    price: (json['price'] as num)?.toDouble(),
    quantity: (json['quantity'] as num)?.toDouble(),
    contractTypeId: json['contractTypeId'] as int,
    specialClause: json['specialClause'] as String,
    deliveryTermId: json['deliveryTermId'] as int,
    totalPerson: json['totalPerson'] as int,
    isFavoriteOffer: json['isFavoriteOffer'] as bool,
    coverMonth: json['coverMonth'] as String,
    comment: json['comment'] as String,
    deliveryWarehouseId: json['deliveryWarehouseId'] as int,
    certificationId: json['certificationId'] as int,
    deliveryDate: json['deliveryDate'] == null
        ? null
        : DateTime.parse(json['deliveryDate'] as String),
    priceUnitTypeId: json['priceUnitTypeId'] as int,
    validityDate: json['validityDate'] == null
        ? null
        : DateTime.parse(json['validityDate'] as String),
    userId: json['userId'] as int,
    packingQuantity: (json['packingQuantity'] as num)?.toDouble(),
    tenantId: json['tenantId'] as int,
    audienceTypeId: json['audienceTypeId'] as int,
    coffeeTypeId: json['coffeeTypeId'] as int,
    commodityId: json['commodityId'] as int,
    gradeTypeId: json['gradeTypeId'] as int,
    packingUnitTypeId: json['packingUnitTypeId'] as int,
    people: (json['people'] as List)?.map((e) => e as String)?.toList(),
    quantityUnitTypeId: json['quantityUnitTypeId'] as int,
    audienceTenantIds:
        (json['audienceTenantIds'] as List)?.map((e) => e as int)?.toList(),
    requestId: json['requestId'] as int,
    conversationId: json['conversationId'] as String,
  );
}

Map<String, dynamic> _$OfferModelToJson(OfferModel instance) =>
    <String, dynamic>{
      'offerId': instance.offerId,
      'requestId': instance.requestId,
      'userId': instance.userId,
      'tenantId': instance.tenantId,
      'supplierName': instance.supplierName,
      'createdDate': instance.createdDate?.toIso8601String(),
      'rating': instance.rating,
      'commodityId': instance.commodityId,
      'contractTypeId': instance.contractTypeId,
      'quantity': instance.quantity,
      'quantityUnitTypeId': instance.quantityUnitTypeId,
      'packingQuantity': instance.packingQuantity,
      'packingUnitTypeId': instance.packingUnitTypeId,
      'gradeTypeId': instance.gradeTypeId,
      'coffeeTypeId': instance.coffeeTypeId,
      'price': instance.price,
      'priceUnitTypeId': instance.priceUnitTypeId,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'validityDate': instance.validityDate?.toIso8601String(),
      'coverMonth': instance.coverMonth,
      'audienceTypeId': instance.audienceTypeId,
      'deliveryTermId': instance.deliveryTermId,
      'deliveryWarehouseId': instance.deliveryWarehouseId,
      'specialClause': instance.specialClause,
      'comment': instance.comment,
      'certificationId': instance.certificationId,
      'isFavoriteOffer': instance.isFavoriteOffer,
      'totalPerson': instance.totalPerson,
      'people': instance.people,
      'audienceTenantIds': instance.audienceTenantIds,
      'conversationId': instance.conversationId,
    };

OfferListResult _$OfferListResultFromJson(Map<String, dynamic> json) {
  return OfferListResult(
    objects: (json['objects'] as List)
        ?.map((e) =>
            e == null ? null : OfferModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$OfferListResultToJson(OfferListResult instance) =>
    <String, dynamic>{
      'objects': instance.objects,
      'totalCount': instance.totalCount,
    };

OfferAdvancedSearchModel _$OfferAdvancedSearchModelFromJson(
    Map<String, dynamic> json) {
  return OfferAdvancedSearchModel(
    coverMonths: (json['coverMonths'] as List)?.map((e) => e as int)?.toList(),
    contractTypeIds:
        (json['contractTypeIds'] as List)?.map((e) => e as int)?.toList(),
    quantityUnitTypeIds:
        (json['quantityUnitTypeIds'] as List)?.map((e) => e as int)?.toList(),
    audienceTypeIds:
        (json['audienceTypeIds'] as List)?.map((e) => e as int)?.toList(),
    gradeTypeId: json['gradeTypeId'] as int,
    deliveryTermId: json['deliveryTermId'] as int,
    deliveryEndDate: json['deliveryEndDate'] == null
        ? null
        : DateTime.parse(json['deliveryEndDate'] as String),
    deliveryStartDate: json['deliveryStartDate'] == null
        ? null
        : DateTime.parse(json['deliveryStartDate'] as String),
    endQuantity: json['endQuantity'] as int,
    startQuantity: json['startQuantity'] as int,
    validityEndDate: json['validityEndDate'] == null
        ? null
        : DateTime.parse(json['validityEndDate'] as String),
    validityStartDate: json['validityStartDate'] == null
        ? null
        : DateTime.parse(json['validityStartDate'] as String),
    filterTypeId: json['filterTypeId'] as int,
    keyword: json['keyword'] as String,
    statusId: json['statusId'] as int,
  )
    ..pageNumber = json['pageNumber'] as int
    ..pageSize = json['pageSize'] as int
    ..warehouseIds =
        (json['warehouseIds'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$OfferAdvancedSearchModelToJson(
        OfferAdvancedSearchModel instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'filterTypeId': instance.filterTypeId,
      'keyword': instance.keyword,
      'quantityUnitTypeIds': instance.quantityUnitTypeIds,
      'startQuantity': instance.startQuantity,
      'endQuantity': instance.endQuantity,
      'gradeTypeId': instance.gradeTypeId,
      'contractTypeIds': instance.contractTypeIds,
      'warehouseIds': instance.warehouseIds,
      'validityStartDate': instance.validityStartDate?.toIso8601String(),
      'validityEndDate': instance.validityEndDate?.toIso8601String(),
      'deliveryStartDate': instance.deliveryStartDate?.toIso8601String(),
      'deliveryEndDate': instance.deliveryEndDate?.toIso8601String(),
      'deliveryTermId': instance.deliveryTermId,
      'audienceTypeIds': instance.audienceTypeIds,
      'coverMonths': instance.coverMonths,
      'statusId': instance.statusId,
    };

RequestSimpleSearchModel _$RequestSimpleSearchModelFromJson(
    Map<String, dynamic> json) {
  return RequestSimpleSearchModel(
    requestStatusId: json['requestStatusId'] as int,
    keyword: json['keyword'] as String,
  )
    ..pageNumber = json['pageNumber'] as int
    ..pageSize = json['pageSize'] as int;
}

Map<String, dynamic> _$RequestSimpleSearchModelToJson(
        RequestSimpleSearchModel instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'requestStatusId': instance.requestStatusId,
      'keyword': instance.keyword,
    };

OfferSimpleSearchModel _$OfferSimpleSearchModelFromJson(
    Map<String, dynamic> json) {
  return OfferSimpleSearchModel(
    keyword: json['keyword'] as String,
    filterTypeId: json['filterTypeId'] as int,
    statusId: json['statusId'] as int,
  )
    ..pageNumber = json['pageNumber'] as int
    ..pageSize = json['pageSize'] as int;
}

Map<String, dynamic> _$OfferSimpleSearchModelToJson(
        OfferSimpleSearchModel instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'keyword': instance.keyword,
      'filterTypeId': instance.filterTypeId,
      'statusId': instance.statusId,
    };

FavoriteOfferModel _$FavoriteOfferModelFromJson(Map<String, dynamic> json) {
  return FavoriteOfferModel(
    offerId: json['offerId'] as int,
    userId: json['userId'] as int,
    isFavorite: json['isFavorite'] as bool,
  );
}

Map<String, dynamic> _$FavoriteOfferModelToJson(FavoriteOfferModel instance) =>
    <String, dynamic>{
      'offerId': instance.offerId,
      'userId': instance.userId,
      'isFavorite': instance.isFavorite,
    };
