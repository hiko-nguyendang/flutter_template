import 'package:json_annotation/json_annotation.dart';

import 'package:agree_n/app/enums/enums.dart';

part 'dashboard.model.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardModel {
  final int userId;
  final int tenantTypeId;
  final BuyerDashboardModel buyerDashboardInfo;
  final SupplierDashboardModel supplierDashboardInfo;

  DashboardModel(
      {this.buyerDashboardInfo,
      this.supplierDashboardInfo,
      this.tenantTypeId,
      this.userId});

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);
}

@JsonSerializable()
class BuyerDashboardModel {
  final int lastAccessOpenOfferNumber;
  final DateTime lastAccessDateTime;
  final int openPurchaseContractNumber;
  final int pastContractNumber;
  final DateTime currentCropYearStartDate;

  BuyerDashboardModel(
      {this.lastAccessOpenOfferNumber,
      this.lastAccessDateTime,
      this.openPurchaseContractNumber,
      this.pastContractNumber,
      this.currentCropYearStartDate});

  factory BuyerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$BuyerDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyerDashboardModelToJson(this);
}

@JsonSerializable()
class SupplierDashboardModel {
  final int openOfferNumber;
  final int openSaleContractNumber;
  final int pastContractNumber;
  final DateTime currentCropYearStartDate;
  final DateTime lastAccessDateTime;

  SupplierDashboardModel(
      {this.openOfferNumber,
      this.openSaleContractNumber,
      this.pastContractNumber,
      this.currentCropYearStartDate,
      this.lastAccessDateTime});

  factory SupplierDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierDashboardModelToJson(this);
}

class MarketPriceModel {
  String name;
  double last;
  double change;
  double changePercent;
  double volume;
  double high;
  double low;
  double open;
  double previous;
  double opInt;
  double bid;
  double bidSize;
  double ask;
  double askSize;
  String time;
  String month;
  double oIC;

  String get coverMonth {
    final coverMonthCode =
        CoverMonthEnum.getCode(int.parse(month.split('/')[0]));
    final coverYear = month.split('/')[1];
    return '$coverMonthCode$coverYear';
  }

  double get arabicaOIPercent {
    return opInt / MarketPriceEnum.ArabicaMaxOI;
  }

  double get arabicaVolumePercent {
    return volume / MarketPriceEnum.ArabicaMaxVolume;
  }

  double get robustaOIPercent {
    return opInt / MarketPriceEnum.RobustaMaxOI;
  }

  double get robustaVolumePercent {
    return volume / MarketPriceEnum.RobustaMaxVolume;
  }
}

class CoffeePriceModel {
  String period;
  String priceMatch;
  String changeValue;
  String percent;
  String amount;
  String maxValue;
  String minValue;
  String openTime;
  String yesterdayValue;
  String openContractValue;

  CoffeePriceModel(
      {this.period,
      this.priceMatch,
      this.changeValue,
      this.percent,
      this.amount,
      this.maxValue,
      this.minValue,
      this.openTime,
      this.yesterdayValue,
      this.openContractValue});
}

@JsonSerializable(explicitToJson: true)
class MarketPulseResult{
  final List<MarketPulseModel> objects;
  final int totalCount;

  MarketPulseResult({this.objects, this.totalCount});

  factory MarketPulseResult.fromJson(Map<String, dynamic> json) =>
      _$MarketPulseResultFromJson(json);

  Map<String, dynamic> toJson() => _$MarketPulseResultToJson(this);
}

@JsonSerializable()
class MarketPulseModel {
  final int id;
  final String userName;
  final String userImage;
  String message;
  DateTime createdDate;
  final int userId;

  MarketPulseModel({
    this.id,
    this.message,
    this.userId,
    this.userImage,
    this.userName,
    this.createdDate,
  });

  factory MarketPulseModel.fromJson(Map<String, dynamic> json) =>
      _$MarketPulseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketPulseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MarketRateModel {
  final ExrateListModel ExrateList;

  MarketRateModel({this.ExrateList});

  factory MarketRateModel.fromJson(Map<String, dynamic> json) =>
      _$MarketRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarketRateModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExrateListModel {
  final List<ExchangeRateModel> Exrate;

  ExrateListModel({this.Exrate});

  factory ExrateListModel.fromJson(Map<String, dynamic> json) =>
      _$ExrateListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExrateListModelToJson(this);
}

@JsonSerializable()
class ExchangeRateModel {
  String CurrencyCode;
  String CurrencyName;
  String Buy;
  String Transfer;
  String Sell;

  String get buyValue {
    if (Buy == '-') {
      return Buy;
    } else {
      final buyDecimal = Buy.split('.')[1];
      if (buyDecimal == '00') {
        return Buy.split('.')[0];
      } else {
        return Buy;
      }
    }
  }

  String get sellValue {
    if (Sell == '-') {
      return Sell;
    } else {
      final sellDecimal = Sell.split('.')[1];
      if (sellDecimal == '00') {
        return Sell.split('.')[0];
      } else {
        return Sell;
      }
    }
  }

  String get transferValue {
    if (Transfer == '-') {
      return Transfer;
    } else {
      final transferDecimal = Transfer.split('.')[1];
      if (transferDecimal == '00') {
        return Transfer.split('.')[0];
      } else {
        return Transfer;
      }
    }
  }

  ExchangeRateModel(
      {this.CurrencyCode,
      this.CurrencyName,
      this.Buy,
      this.Transfer,
      this.Sell});

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateModelToJson(this);
}

@JsonSerializable()
class WeatherModel {
  final String country;
  final String urlWeatherImage;

  WeatherModel({this.country, this.urlWeatherImage});

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}
