// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) {
  return DashboardModel(
    buyerDashboardInfo: json['buyerDashboardInfo'] == null
        ? null
        : BuyerDashboardModel.fromJson(
            json['buyerDashboardInfo'] as Map<String, dynamic>),
    supplierDashboardInfo: json['supplierDashboardInfo'] == null
        ? null
        : SupplierDashboardModel.fromJson(
            json['supplierDashboardInfo'] as Map<String, dynamic>),
    tenantTypeId: json['tenantTypeId'] as int,
    userId: json['userId'] as int,
  );
}

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'tenantTypeId': instance.tenantTypeId,
      'buyerDashboardInfo': instance.buyerDashboardInfo?.toJson(),
      'supplierDashboardInfo': instance.supplierDashboardInfo?.toJson(),
    };

BuyerDashboardModel _$BuyerDashboardModelFromJson(Map<String, dynamic> json) {
  return BuyerDashboardModel(
    lastAccessOpenOfferNumber: json['lastAccessOpenOfferNumber'] as int,
    lastAccessDateTime: json['lastAccessDateTime'] == null
        ? null
        : DateTime.parse(json['lastAccessDateTime'] as String),
    openPurchaseContractNumber: json['openPurchaseContractNumber'] as int,
    pastContractNumber: json['pastContractNumber'] as int,
    currentCropYearStartDate: json['currentCropYearStartDate'] == null
        ? null
        : DateTime.parse(json['currentCropYearStartDate'] as String),
  );
}

Map<String, dynamic> _$BuyerDashboardModelToJson(
        BuyerDashboardModel instance) =>
    <String, dynamic>{
      'lastAccessOpenOfferNumber': instance.lastAccessOpenOfferNumber,
      'lastAccessDateTime': instance.lastAccessDateTime?.toIso8601String(),
      'openPurchaseContractNumber': instance.openPurchaseContractNumber,
      'pastContractNumber': instance.pastContractNumber,
      'currentCropYearStartDate':
          instance.currentCropYearStartDate?.toIso8601String(),
    };

SupplierDashboardModel _$SupplierDashboardModelFromJson(
    Map<String, dynamic> json) {
  return SupplierDashboardModel(
    openOfferNumber: json['openOfferNumber'] as int,
    openSaleContractNumber: json['openSaleContractNumber'] as int,
    pastContractNumber: json['pastContractNumber'] as int,
    currentCropYearStartDate: json['currentCropYearStartDate'] == null
        ? null
        : DateTime.parse(json['currentCropYearStartDate'] as String),
    lastAccessDateTime: json['lastAccessDateTime'] == null
        ? null
        : DateTime.parse(json['lastAccessDateTime'] as String),
  );
}

Map<String, dynamic> _$SupplierDashboardModelToJson(
        SupplierDashboardModel instance) =>
    <String, dynamic>{
      'openOfferNumber': instance.openOfferNumber,
      'openSaleContractNumber': instance.openSaleContractNumber,
      'pastContractNumber': instance.pastContractNumber,
      'currentCropYearStartDate':
          instance.currentCropYearStartDate?.toIso8601String(),
      'lastAccessDateTime': instance.lastAccessDateTime?.toIso8601String(),
    };

MarketPulseResult _$MarketPulseResultFromJson(Map<String, dynamic> json) {
  return MarketPulseResult(
    objects: (json['objects'] as List)
        ?.map((e) => e == null
            ? null
            : MarketPulseModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$MarketPulseResultToJson(MarketPulseResult instance) =>
    <String, dynamic>{
      'objects': instance.objects?.map((e) => e?.toJson())?.toList(),
      'totalCount': instance.totalCount,
    };

MarketPulseModel _$MarketPulseModelFromJson(Map<String, dynamic> json) {
  return MarketPulseModel(
    id: json['id'] as int,
    message: json['message'] as String,
    userId: json['userId'] as int,
    userImage: json['userImage'] as String,
    userName: json['userName'] as String,
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
  );
}

Map<String, dynamic> _$MarketPulseModelToJson(MarketPulseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'userImage': instance.userImage,
      'message': instance.message,
      'createdDate': instance.createdDate?.toIso8601String(),
      'userId': instance.userId,
    };

MarketRateModel _$MarketRateModelFromJson(Map<String, dynamic> json) {
  return MarketRateModel(
    ExrateList: json['ExrateList'] == null
        ? null
        : ExrateListModel.fromJson(json['ExrateList'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MarketRateModelToJson(MarketRateModel instance) =>
    <String, dynamic>{
      'ExrateList': instance.ExrateList?.toJson(),
    };

ExrateListModel _$ExrateListModelFromJson(Map<String, dynamic> json) {
  return ExrateListModel(
    Exrate: (json['Exrate'] as List)
        ?.map((e) => e == null
            ? null
            : ExchangeRateModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExrateListModelToJson(ExrateListModel instance) =>
    <String, dynamic>{
      'Exrate': instance.Exrate?.map((e) => e?.toJson())?.toList(),
    };

ExchangeRateModel _$ExchangeRateModelFromJson(Map<String, dynamic> json) {
  return ExchangeRateModel(
    CurrencyCode: json['CurrencyCode'] as String,
    CurrencyName: json['CurrencyName'] as String,
    Buy: json['Buy'] as String,
    Transfer: json['Transfer'] as String,
    Sell: json['Sell'] as String,
  );
}

Map<String, dynamic> _$ExchangeRateModelToJson(ExchangeRateModel instance) =>
    <String, dynamic>{
      'CurrencyCode': instance.CurrencyCode,
      'CurrencyName': instance.CurrencyName,
      'Buy': instance.Buy,
      'Transfer': instance.Transfer,
      'Sell': instance.Sell,
    };

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) {
  return WeatherModel(
    country: json['country'] as String,
    urlWeatherImage: json['urlWeatherImage'] as String,
  );
}

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'country': instance.country,
      'urlWeatherImage': instance.urlWeatherImage,
    };
