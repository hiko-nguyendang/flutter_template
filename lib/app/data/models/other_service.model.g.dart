// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_service.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagingModel _$PackagingModelFromJson(Map<String, dynamic> json) {
  return PackagingModel(
    priceUnitTypeId: json['priceUnitTypeId'] as int,
    juteBagTypeId: json['juteBagTypeId'] as int,
    packagingStatusId: json['packagingStatusId'] as int,
    quantityAvailable: (json['quantityAvailable'] as num)?.toDouble(),
    price: (json['price'] as num)?.toDouble(),
    vop: json['vop'] as bool,
    measuringUnitTypeId: json['measuringUnitTypeId'] as int,
    lengthOfBag: (json['lengthOfBag'] as num)?.toDouble(),
    widthOfBag: (json['widthOfBag'] as num)?.toDouble(),
    weightOfBag: (json['weightOfBag'] as num)?.toDouble(),
    gradeType: json['gradeType'] as String,
    treatment: json['treatment'] as String,
    bagTypeId: json['bagTypeId'] as int,
    printing: json['printing'] as String,
    noOfColors: json['noOfColors'] as int,
    stripes: json['stripes'] as String,
    moisture: (json['moisture'] as num)?.toDouble(),
    extra: json['extra'] as String,
    specialDocument: json['specialDocument'] as String,
    packing: json['packing'] as String,
    loading: json['loading'] as String,
    compliance: json['compliance'] as String,
    specialInstruction: json['specialInstruction'] as String,
  );
}

Map<String, dynamic> _$PackagingModelToJson(PackagingModel instance) =>
    <String, dynamic>{
      'juteBagTypeId': instance.juteBagTypeId,
      'packagingStatusId': instance.packagingStatusId,
      'quantityAvailable': instance.quantityAvailable,
      'price': instance.price,
      'priceUnitTypeId': instance.priceUnitTypeId,
      'vop': instance.vop,
      'measuringUnitTypeId': instance.measuringUnitTypeId,
      'lengthOfBag': instance.lengthOfBag,
      'widthOfBag': instance.widthOfBag,
      'weightOfBag': instance.weightOfBag,
      'gradeType': instance.gradeType,
      'treatment': instance.treatment,
      'bagTypeId': instance.bagTypeId,
      'printing': instance.printing,
      'noOfColors': instance.noOfColors,
      'stripes': instance.stripes,
      'moisture': instance.moisture,
      'extra': instance.extra,
      'specialDocument': instance.specialDocument,
      'packing': instance.packing,
      'loading': instance.loading,
      'compliance': instance.compliance,
      'specialInstruction': instance.specialInstruction,
    };

TruckingModel _$TruckingModelFromJson(Map<String, dynamic> json) {
  return TruckingModel(
    id: json['id'] as int,
    companyName: json['companyName'] as String,
    truckSize: (json['truckSize'] as num)?.toDouble(),
    truckNumber: json['truckNumber'] as String,
    volumeAvailable: (json['volumeAvailable'] as num)?.toDouble(),
    validityStart: json['validityStart'] == null
        ? null
        : DateTime.parse(json['validityStart'] as String),
    validityEnd: json['validityEnd'] == null
        ? null
        : DateTime.parse(json['validityEnd'] as String),
    truckSizeQuantityUnitTypeId: json['truckSizeQuantityUnitTypeId'] as int,
    type: json['type'] as int,
    routes: (json['routes'] as List)
        ?.map((e) =>
            e == null ? null : RouteModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    volumeQuantityUnitTypeId: json['volumeQuantityUnitTypeId'] as int,
  );
}

Map<String, dynamic> _$TruckingModelToJson(TruckingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'companyName': instance.companyName,
      'truckSize': instance.truckSize,
      'truckSizeQuantityUnitTypeId': instance.truckSizeQuantityUnitTypeId,
      'volumeAvailable': instance.volumeAvailable,
      'volumeQuantityUnitTypeId': instance.volumeQuantityUnitTypeId,
      'truckNumber': instance.truckNumber,
      'validityStart': instance.validityStart?.toIso8601String(),
      'validityEnd': instance.validityEnd?.toIso8601String(),
      'routes': instance.routes?.map((e) => e?.toJson())?.toList(),
    };

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) {
  return RouteModel(
    originName: json['originName'] as String,
    destinationName: json['destinationName'] as String,
    distance: (json['distance'] as num)?.toDouble(),
    price: (json['price'] as num)?.toDouble(),
    priceUnitTypeId: json['priceUnitTypeId'] as int,
    destinationPlaceId: json['destinationPlaceId'] as String,
    originPlaceId: json['originPlaceId'] as String,
    destinationCityName: json['destinationCityName'] as String,
    originCityName: json['originCityName'] as String,
    sortOrder: json['sortOrder'] as int,
  );
}

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'sortOrder': instance.sortOrder,
      'originName': instance.originName,
      'originCityName': instance.originCityName,
      'originPlaceId': instance.originPlaceId,
      'destinationName': instance.destinationName,
      'destinationCityName': instance.destinationCityName,
      'destinationPlaceId': instance.destinationPlaceId,
      'distance': instance.distance,
      'price': instance.price,
      'priceUnitTypeId': instance.priceUnitTypeId,
    };

MachineriesModel _$MachineriesModelFromJson(Map<String, dynamic> json) {
  return MachineriesModel(
    machineryName: json['machineryName'] as String,
    branchName: json['branchName'] as String,
    statusId: json['statusId'] as int,
    yearOfManufacture: json['yearOfManufacture'] as int,
    price: (json['price'] as num)?.toDouble(),
    priceUnitTypeId: json['priceUnitTypeId'] as int,
  );
}

Map<String, dynamic> _$MachineriesModelToJson(MachineriesModel instance) =>
    <String, dynamic>{
      'machineryName': instance.machineryName,
      'branchName': instance.branchName,
      'statusId': instance.statusId,
      'yearOfManufacture': instance.yearOfManufacture,
      'price': instance.price,
      'priceUnitTypeId': instance.priceUnitTypeId,
    };

OthersModel _$OthersModelFromJson(Map<String, dynamic> json) {
  return OthersModel(
    productName: json['productName'] as String,
    branchName: json['branchName'] as String,
    bagSize: json['bagSize'] as String,
    composition: json['composition'] as String,
    priceDelivered: (json['priceDelivered'] as num)?.toDouble(),
    priceWithoutCredit: (json['priceWithoutCredit'] as num)?.toDouble(),
    currencyId: json['currencyId'] as int,
    currency: json['currency'] as String,
    packingUnitTypeId: json['packingUnitTypeId'] as int,
  );
}

Map<String, dynamic> _$OthersModelToJson(OthersModel instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'branchName': instance.branchName,
      'bagSize': instance.bagSize,
      'composition': instance.composition,
      'priceDelivered': instance.priceDelivered,
      'priceWithoutCredit': instance.priceWithoutCredit,
      'currencyId': instance.currencyId,
      'currency': instance.currency,
      'packingUnitTypeId': instance.packingUnitTypeId,
    };

OtherServiceModel _$OtherServiceModelFromJson(Map<String, dynamic> json) {
  return OtherServiceModel(
    offerId: json['offerId'] as int,
    tenantId: json['tenantId'] as int,
    userId: json['userId'] as int,
    tenantName: json['tenantName'] as String,
    serviceTypeId: json['serviceTypeId'] as int,
    isActive: json['isActive'] as bool,
    comments: json['comments'] as String,
    urlImages: (json['urlImages'] as List)?.map((e) => e as String)?.toList(),
    trucking: json['trucking'] == null
        ? null
        : TruckingModel.fromJson(json['trucking'] as Map<String, dynamic>),
    packaging: json['packaging'] == null
        ? null
        : PackagingModel.fromJson(json['packaging'] as Map<String, dynamic>),
    machinery: json['machinery'] == null
        ? null
        : MachineriesModel.fromJson(json['machinery'] as Map<String, dynamic>),
    other: json['other'] == null
        ? null
        : OthersModel.fromJson(json['other'] as Map<String, dynamic>),
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    modifiedDate: json['modifiedDate'] == null
        ? null
        : DateTime.parse(json['modifiedDate'] as String),
    isFavorite: json['isFavorite'] as bool,
  );
}

Map<String, dynamic> _$OtherServiceModelToJson(OtherServiceModel instance) =>
    <String, dynamic>{
      'offerId': instance.offerId,
      'tenantId': instance.tenantId,
      'userId': instance.userId,
      'tenantName': instance.tenantName,
      'serviceTypeId': instance.serviceTypeId,
      'isActive': instance.isActive,
      'comments': instance.comments,
      'urlImages': instance.urlImages,
      'trucking': instance.trucking?.toJson(),
      'packaging': instance.packaging?.toJson(),
      'machinery': instance.machinery?.toJson(),
      'other': instance.other?.toJson(),
      'createdDate': instance.createdDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'isFavorite': instance.isFavorite,
    };

OtherServiceParam _$OtherServiceParamFromJson(Map<String, dynamic> json) {
  return OtherServiceParam(
    isGetFavoriteOffers: json['isGetFavoriteOffers'] as bool,
    serviceTypeId: json['serviceTypeId'] as int,
  )
    ..pageNumber = json['pageNumber'] as int
    ..pageSize = json['pageSize'] as int;
}

Map<String, dynamic> _$OtherServiceParamToJson(OtherServiceParam instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'serviceTypeId': instance.serviceTypeId,
      'isGetFavoriteOffers': instance.isGetFavoriteOffers,
    };
