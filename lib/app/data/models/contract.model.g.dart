// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractModel _$ContractModelFromJson(Map<String, dynamic> json) {
  return ContractModel(
    id: json['id'] as int,
    tenantName: json['tenantName'] as String,
    specialClause: json['specialClause'] as String,
    price: (json['price'] as num)?.toDouble(),
    differentPrice: (json['differentPrice'] as num)?.toDouble(),
    quantity: (json['quantity'] as num)?.toDouble(),
    coffeeType: json['coffeeType'] as int,
    deliveryDate: json['deliveryDate'] == null
        ? null
        : DateTime.parse(json['deliveryDate'] as String),
    deliveryTerm: json['deliveryTerm'] as int,
    coverMonth: json['coverMonth'] as int,
    contractType: json['contractType'] as int,
    location: json['location'] as int,
    grade: json['grade'] as int,
    certification: json['certification'] as int,
    commodity: json['commodity'] as int,
    gradeName: json['gradeName'] as String,
    coverMonthValue: json['coverMonthValue'] as String,
    quantityUnit: json['quantityUnit'] as int,
    priceValue: json['priceValue'] as String,
    contractNumber: json['contractNumber'] as String,
    currency: json['currency'] as int,
    seller: json['seller'] == null
        ? null
        : ContactRateModel.fromJson(json['seller'] as Map<String, dynamic>),
    priceUnit: json['priceUnit'] as int,
    exchangeDate: json['exchangeDate'] == null
        ? null
        : DateTime.parse(json['exchangeDate'] as String),
    marketPrice: (json['marketPrice'] as num)?.toDouble(),
    securityMargin: (json['securityMargin'] as num)?.toDouble(),
    packing: (json['packing'] as num)?.toDouble(),
    packingUnit: json['packingUnit'] as int,
    cropYear: json['cropYear'] as String,
    currencyRate: (json['currencyRate'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ContractModelToJson(ContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'grade': instance.grade,
      'tenantName': instance.tenantName,
      'quantity': instance.quantity,
      'quantityUnit': instance.quantityUnit,
      'price': instance.price,
      'priceUnit': instance.priceUnit,
      'differentPrice': instance.differentPrice,
      'currency': instance.currency,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'deliveryTerm': instance.deliveryTerm,
      'coverMonth': instance.coverMonth,
      'coffeeType': instance.coffeeType,
      'contractType': instance.contractType,
      'commodity': instance.commodity,
      'certification': instance.certification,
      'location': instance.location,
      'packing': instance.packing,
      'packingUnit': instance.packingUnit,
      'specialClause': instance.specialClause,
      'contractNumber': instance.contractNumber,
      'gradeName': instance.gradeName,
      'priceValue': instance.priceValue,
      'coverMonthValue': instance.coverMonthValue,
      'exchangeDate': instance.exchangeDate?.toIso8601String(),
      'marketPrice': instance.marketPrice,
      'securityMargin': instance.securityMargin,
      'currencyRate': instance.currencyRate,
      'cropYear': instance.cropYear,
      'seller': instance.seller?.toJson(),
    };

ContractStatusModel _$ContractStatusModelFromJson(Map<String, dynamic> json) {
  return ContractStatusModel(
    conversationId: json['conversationId'] as String,
    conversationTitle: json['conversationTitle'] as String,
    status: json['status'] as int,
    terms: (json['terms'] as List)
        ?.map((e) =>
            e == null ? null : TermModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ContractStatusModelToJson(
        ContractStatusModel instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'conversationTitle': instance.conversationTitle,
      'status': instance.status,
      'terms': instance.terms,
    };

TermModel _$TermModelFromJson(Map<String, dynamic> json) {
  return TermModel(
    id: json['id'] as int,
    name: json['name'] as String,
    options: (json['options'] as List)
            ?.map((e) => e == null
                ? null
                : LookupOptionModel.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    status: json['status'] as int,
    isRequired: json['isRequired'] as bool,
    unit: json['unit'],
    value: json['value'],
    defaultValue: json['defaultValue'],
    defaultUnit: json['defaultUnit'],
  );
}

Map<String, dynamic> _$TermModelToJson(TermModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'isRequired': instance.isRequired,
      'value': instance.value,
      'unit': instance.unit,
      'defaultValue': instance.defaultValue,
      'defaultUnit': instance.defaultUnit,
      'options': instance.options,
    };

TermOptionModel _$TermOptionModelFromJson(Map<String, dynamic> json) {
  return TermOptionModel(
    optionKey: json['optionKey'],
    optionName: json['optionName'] as String,
  );
}

Map<String, dynamic> _$TermOptionModelToJson(TermOptionModel instance) =>
    <String, dynamic>{
      'optionKey': instance.optionKey,
      'optionName': instance.optionName,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] as int,
    quantity: json['quantity'] as String,
    price: (json['price'] as num)?.toDouble(),
    unit: json['unit'] as String,
    name: json['name'],
    quality: json['quality'] as String,
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'quality': instance.quality,
      'price': instance.price,
      'unit': instance.unit,
      'name': instance.name,
    };

CreateContractModel _$CreateContractModelFromJson(Map<String, dynamic> json) {
  return CreateContractModel(
    priceUnitTypeId: json['priceUnitTypeId'] as int,
    coverMonth: json['coverMonth'] as String,
    commodityTypeId: json['commodityTypeId'] as int,
    coffeeTypeId: json['coffeeTypeId'] as int,
    price: (json['price'] as num)?.toDouble(),
    comment: json['comment'] as String,
    deliveryWarehouseId: json['deliveryWarehouseId'] as int,
    contractTypeId: json['contractTypeId'] as int,
    quantityUnitTypeId: json['quantityUnitTypeId'] as int,
    gradeTypeId: json['gradeTypeId'] as int,
    contractNumber: json['contractNumber'] as String,
    deliveryDate: json['deliveryDate'] == null
        ? null
        : DateTime.parse(json['deliveryDate'] as String),
    specialClause: json['specialClause'] as String,
    certificationTypeId: json['certificationTypeId'] as int,
    quantity: (json['quantity'] as num)?.toDouble(),
    packingQuantity: (json['packingQuantity'] as num)?.toDouble(),
    packingUnitTypeId: json['packingUnitTypeId'] as int,
    supplierId: json['supplierId'] as int,
    certificationPremium: (json['certificationPremium'] as num)?.toDouble(),
    cropYear: json['cropYear'] as String,
  );
}

Map<String, dynamic> _$CreateContractModelToJson(
        CreateContractModel instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'gradeTypeId': instance.gradeTypeId,
      'coffeeTypeId': instance.coffeeTypeId,
      'price': instance.price,
      'certificationPremium': instance.certificationPremium,
      'contractTypeId': instance.contractTypeId,
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'deliveryWarehouseId': instance.deliveryWarehouseId,
      'specialClause': instance.specialClause,
      'coverMonth': instance.coverMonth,
      'comment': instance.comment,
      'priceUnitTypeId': instance.priceUnitTypeId,
      'contractNumber': instance.contractNumber,
      'supplierId': instance.supplierId,
      'packingUnitTypeId': instance.packingUnitTypeId,
      'packingQuantity': instance.packingQuantity,
      'certificationTypeId': instance.certificationTypeId,
      'commodityTypeId': instance.commodityTypeId,
      'quantityUnitTypeId': instance.quantityUnitTypeId,
      'cropYear': instance.cropYear,
    };

PastContractFilterParam _$PastContractFilterParamFromJson(
    Map<String, dynamic> json) {
  return PastContractFilterParam(
    type: json['type'] as int,
    commodityTypeId: json['commodityTypeId'] as int,
    fromYear: json['fromYear'] as int,
    toYear: json['toYear'] as int,
    timeFrameTypeId: json['timeFrameTypeId'] as int,
    contractTypeId: json['contractTypeId'] as int,
    tenantIds: (json['tenantIds'] as List)?.map((e) => e as int)?.toList(),
    gradeTypeId: json['gradeTypeId'] as int,
    destinationIds:
        (json['destinationIds'] as List)?.map((e) => e as int)?.toList(),
    year: json['year'] as int,
    month: json['month'] as int,
    day: json['day'] as int,
  );
}

Map<String, dynamic> _$PastContractFilterParamToJson(
        PastContractFilterParam instance) =>
    <String, dynamic>{
      'type': instance.type,
      'commodityTypeId': instance.commodityTypeId,
      'fromYear': instance.fromYear,
      'toYear': instance.toYear,
      'timeFrameTypeId': instance.timeFrameTypeId,
      'contractTypeId': instance.contractTypeId,
      'tenantIds': instance.tenantIds,
      'gradeTypeId': instance.gradeTypeId,
      'destinationIds': instance.destinationIds,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
    };

PastContractSeriesModel _$PastContractSeriesModelFromJson(
    Map<String, dynamic> json) {
  return PastContractSeriesModel(
    name: json['name'] as String,
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PastContractSeriesModelToJson(
        PastContractSeriesModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

PastContractsVolumeViewModel _$PastContractsVolumeViewModelFromJson(
    Map<String, dynamic> json) {
  return PastContractsVolumeViewModel(
    periodName: json['periodName'] as String,
    quantity: json['quantity'] as int,
  );
}

Map<String, dynamic> _$PastContractsVolumeViewModelToJson(
        PastContractsVolumeViewModel instance) =>
    <String, dynamic>{
      'periodName': instance.periodName,
      'quantity': instance.quantity,
    };

OpenContractModel _$OpenContractModelFromJson(Map<String, dynamic> json) {
  return OpenContractModel(
    id: json['id'] as int,
    contractNumber: json['contractNumber'] as String,
    vendorName: json['vendorName'] as String,
    quantity: (json['quantity'] as num)?.toDouble(),
    quantityUnitType: json['quantityUnitType'] as String,
    quality: json['quality'] as String,
    contractDate: json['contractDate'] == null
        ? null
        : DateTime.parse(json['contractDate'] as String),
    deadLine: json['deadLine'] == null
        ? null
        : DateTime.parse(json['deadLine'] as String),
    overDueDay: json['overDueDay'] as int,
    price: (json['price'] as num)?.toDouble(),
    finalPrice: (json['finalPrice'] as num)?.toDouble(),
    deliveryBags: (json['deliveryBags'] as num)?.toDouble(),
    certCode: json['certCode'] as String,
    crop: json['crop'] as int,
    contractTypeId: json['contractTypeId'] as int,
    pendingNW: (json['pendingNW'] as num)?.toDouble(),
    deliveryNetWt: (json['deliveryNetWt'] as num)?.toDouble(),
    priceUnitType: json['priceUnitType'] as String,
    specialClause: json['specialClause'] as String,
    remark: json['remark'] as String,
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$OpenContractModelToJson(OpenContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contractNumber': instance.contractNumber,
      'vendorName': instance.vendorName,
      'quantity': instance.quantity,
      'quantityUnitType': instance.quantityUnitType,
      'quality': instance.quality,
      'contractDate': instance.contractDate?.toIso8601String(),
      'deadLine': instance.deadLine?.toIso8601String(),
      'overDueDay': instance.overDueDay,
      'price': instance.price,
      'finalPrice': instance.finalPrice,
      'deliveryBags': instance.deliveryBags,
      'certCode': instance.certCode,
      'crop': instance.crop,
      'contractTypeId': instance.contractTypeId,
      'pendingNW': instance.pendingNW,
      'deliveryNetWt': instance.deliveryNetWt,
      'priceUnitType': instance.priceUnitType,
      'specialClause': instance.specialClause,
      'remark': instance.remark,
      'totalCount': instance.totalCount,
    };

OpenContractAdvanceSearchModel _$OpenContractAdvanceSearchModelFromJson(
    Map<String, dynamic> json) {
  return OpenContractAdvanceSearchModel(
    openContractFilterTypeId: json['openContractFilterTypeId'] as int,
    keyword: json['keyword'] as String,
    tenantId: json['tenantId'] as int,
    gradeTypeId: json['gradeTypeId'] as int,
    contractTypeIds:
        (json['contractTypeIds'] as List)?.map((e) => e as int)?.toList(),
    commodityTypeIds:
        (json['commodityTypeIds'] as List)?.map((e) => e as int)?.toList(),
    coverMonths: (json['coverMonths'] as List)?.map((e) => e as int)?.toList(),
    deliveryWarehouseIds:
        (json['deliveryWarehouseIds'] as List)?.map((e) => e as int)?.toList(),
    coffeeTypeIds:
        (json['coffeeTypeIds'] as List)?.map((e) => e as int)?.toList(),
    sort: (json['sort'] as List)
        ?.map((e) => e == null
            ? null
            : SortCriteriaModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..pageNumber = json['pageNumber'] as int
    ..pageSize = json['pageSize'] as int;
}

Map<String, dynamic> _$OpenContractAdvanceSearchModelToJson(
        OpenContractAdvanceSearchModel instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'openContractFilterTypeId': instance.openContractFilterTypeId,
      'keyword': instance.keyword,
      'tenantId': instance.tenantId,
      'gradeTypeId': instance.gradeTypeId,
      'contractTypeIds': instance.contractTypeIds,
      'commodityTypeIds': instance.commodityTypeIds,
      'coverMonths': instance.coverMonths,
      'deliveryWarehouseIds': instance.deliveryWarehouseIds,
      'coffeeTypeIds': instance.coffeeTypeIds,
      'sort': instance.sort,
    };

OpenContractDataResultModel _$OpenContractDataResultModelFromJson(
    Map<String, dynamic> json) {
  return OpenContractDataResultModel(
    totalCount: json['totalCount'] as int,
    objects: (json['objects'] as List)
        ?.map((e) => e == null
            ? null
            : OpenContractModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OpenContractDataResultModelToJson(
        OpenContractDataResultModel instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'objects': instance.objects,
    };

OpenContractSortParam _$OpenContractSortParamFromJson(
    Map<String, dynamic> json) {
  return OpenContractSortParam(
    isDescVendorName: json['isDescVendorName'] as bool,
    isDescContractNumber: json['isDescContractNumber'] as bool,
    isDescQuantity: json['isDescQuantity'] as bool,
    isDescQuality: json['isDescQuality'] as bool,
    isDescContractDate: json['isDescContractDate'] as bool,
    isDescDeadline: json['isDescDeadline'] as bool,
    isDescOverdue: json['isDescOverdue'] as bool,
    isDescDeliveryBag: json['isDescDeliveryBag'] as bool,
    isDescDeliveryNet: json['isDescDeliveryNet'] as bool,
    isDescPendingNW: json['isDescPendingNW'] as bool,
    isDescPrice: json['isDescPrice'] as bool,
    isDescFinalPrice: json['isDescFinalPrice'] as bool,
    isDescPriceUnitCode: json['isDescPriceUnitCode'] as bool,
    isDescCertCode: json['isDescCertCode'] as bool,
    isDescCrop: json['isDescCrop'] as bool,
    isDescRemark: json['isDescRemark'] as bool,
  );
}

Map<String, dynamic> _$OpenContractSortParamToJson(
        OpenContractSortParam instance) =>
    <String, dynamic>{
      'isDescVendorName': instance.isDescVendorName,
      'isDescContractNumber': instance.isDescContractNumber,
      'isDescQuantity': instance.isDescQuantity,
      'isDescQuality': instance.isDescQuality,
      'isDescContractDate': instance.isDescContractDate,
      'isDescDeadline': instance.isDescDeadline,
      'isDescOverdue': instance.isDescOverdue,
      'isDescDeliveryBag': instance.isDescDeliveryBag,
      'isDescDeliveryNet': instance.isDescDeliveryNet,
      'isDescPendingNW': instance.isDescPendingNW,
      'isDescPrice': instance.isDescPrice,
      'isDescFinalPrice': instance.isDescFinalPrice,
      'isDescPriceUnitCode': instance.isDescPriceUnitCode,
      'isDescCertCode': instance.isDescCertCode,
      'isDescCrop': instance.isDescCrop,
      'isDescRemark': instance.isDescRemark,
    };

PastContractDetailModel _$PastContractDetailModelFromJson(
    Map<String, dynamic> json) {
  return PastContractDetailModel(
    value: (json['value'] as num)?.toDouble(),
    tenantName: json['tenantName'] as String,
    unit: json['unit'] as String,
  );
}

Map<String, dynamic> _$PastContractDetailModelToJson(
        PastContractDetailModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'tenantName': instance.tenantName,
      'unit': instance.unit,
    };

SortCriteriaModel _$SortCriteriaModelFromJson(Map<String, dynamic> json) {
  return SortCriteriaModel(
    selector: json['selector'] as String,
    desc: json['desc'] as bool,
  );
}

Map<String, dynamic> _$SortCriteriaModelToJson(SortCriteriaModel instance) =>
    <String, dynamic>{
      'selector': instance.selector,
      'desc': instance.desc,
    };

ContractPerformanceSeriesModel _$ContractPerformanceSeriesModelFromJson(
    Map<String, dynamic> json) {
  return ContractPerformanceSeriesModel(
    name: json['name'] as String,
    overall: (json['overall'] as num)?.toDouble(),
    quality: (json['quality'] as num)?.toDouble(),
    timeDelivery: (json['timeDelivery'] as num)?.toDouble(),
    cooperation: (json['cooperation'] as num)?.toDouble(),
    documentation: (json['documentation'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ContractPerformanceSeriesModelToJson(
        ContractPerformanceSeriesModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'overall': instance.overall,
      'quality': instance.quality,
      'timeDelivery': instance.timeDelivery,
      'cooperation': instance.cooperation,
      'documentation': instance.documentation,
    };
