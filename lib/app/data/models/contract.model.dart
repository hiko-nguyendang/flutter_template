import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/contact.model.dart';
import 'package:agree_n/app/data/models/lookup.model.dart';

part 'contract.model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContractModel {
  int id;
  int grade;
  String tenantName;
  double quantity;
  int quantityUnit;
  double price;
  int priceUnit;
  double differentPrice;
  int currency;
  DateTime deliveryDate;
  int deliveryTerm;
  int coverMonth;
  int coffeeType;
  int contractType;
  int commodity;
  int certification;
  int location;
  double packing;
  int packingUnit;
  String specialClause;
  String contractNumber;
  String gradeName;
  String priceValue;
  String coverMonthValue;
  DateTime exchangeDate;
  double marketPrice;
  double securityMargin;
  double currencyRate;
  String cropYear;
  ContactRateModel seller;

  ContractModel(
      {this.id,
      this.tenantName,
      this.specialClause,
      this.price,
      this.differentPrice,
      this.quantity,
      this.coffeeType,
      this.deliveryDate,
      this.deliveryTerm,
      this.coverMonth,
      this.contractType,
      this.location,
      this.grade,
      this.certification,
      this.commodity,
      this.gradeName,
      this.coverMonthValue,
      this.quantityUnit,
      this.priceValue,
      this.contractNumber,
      this.currency,
      this.seller,
      this.priceUnit,
      this.exchangeDate,
      this.marketPrice,
      this.securityMargin,
      this.packing,
      this.packingUnit,
      this.cropYear,
      this.currencyRate});

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);
}

@JsonSerializable()
class ContractStatusModel {
  final String conversationId;
  final String conversationTitle;
  final int status;
  List<TermModel> terms;

  ContractStatusModel(
      {this.conversationId,
      this.conversationTitle,
      this.status,
      List<TermModel> terms})
      : terms = terms ?? [];

  factory ContractStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ContractStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractStatusModelToJson(this);
}

@JsonSerializable()
class TermModel {
  int id;
  String name;
  int status;
  final bool isRequired;
  dynamic value;
  dynamic unit;
  dynamic defaultValue;
  dynamic defaultUnit;
  @JsonKey(defaultValue: [])
  List<LookupOptionModel> options;

  //
  @JsonKey(ignore: true)
  bool isSelecting;

  bool get isNew {
    return status == null || status == TermStatusEnum.None;
  }

  bool get isInProgress {
    return status == TermStatusEnum.InProgress;
  }

  bool get isAccepted {
    return status == TermStatusEnum.Accepted;
  }

  bool get isDeclined {
    return status == TermStatusEnum.Declined;
  }

  String get displayName {
    return TermTypeIdEnum.getName(id);
  }

  int get termInputType {
    if (id == TermTypeIdEnum.ContractType ||
        id == TermTypeIdEnum.Commodities ||
        id == TermTypeIdEnum.CoffeeType ||
        id == TermTypeIdEnum.Grade ||
        id == TermTypeIdEnum.DeliveryTerms ||
        id == TermTypeIdEnum.Certification) {
      return TermInputTypeEnum.DropDown;
    }
    if (id == TermTypeIdEnum.Quantity ||
        id == TermTypeIdEnum.Price ||
        id == TermTypeIdEnum.CoverMonth ||
        id == TermTypeIdEnum.MarketPrice ||
        id == TermTypeIdEnum.Packing ||
        id == TermTypeIdEnum.SecurityMargin) {
      return TermInputTypeEnum.NumberWithOptionUnit;
    }
    if (id == TermTypeIdEnum.DeliveryDate ||
        id == TermTypeIdEnum.ExchangeDate) {
      return TermInputTypeEnum.DateTime;
    }
    if (id == TermTypeIdEnum.SpecialClause) {
      return TermInputTypeEnum.Text;
    }
    if (id == TermTypeIdEnum.CropYear) {
      return TermInputTypeEnum.Range;
    }
    return 0;
  }

  String get valueDisplayName {
    if (value == null && defaultValue == null) return '...';
    if (id == TermTypeIdEnum.CoverMonth) {
      return value;
    }
    final termValue = value != null ? value : defaultValue;
    final option = options.where(
      (_) =>
          _.id ==
          int.parse(
            termValue.toString().replaceAll(',', ''),
          ),
    );
    return option.isNotEmpty ? option.first.displayName : '...';
  }

  String get unitDisplayName {
    if (id == TermTypeIdEnum.CoverMonth) {
      if (unit == null) {
        return '...';
      } else {
        return unit;
      }
    }
    if (unit == null && defaultValue == null) {
      return '...';
    }
    final termUnit = unit != null ? unit : defaultUnit;
    final option = options.where(
      (_) =>
          _.id ==
          int.parse(
            termUnit.toString(),
          ),
    );
    if (id == TermTypeIdEnum.Packing) {
      return option.isNotEmpty ? option.first.name : '...';
    }
    return option.isNotEmpty ? option.first.displayName : '...';
  }

  String get termMessageContent {
    if (termInputType == TermInputTypeEnum.Text ||
        termInputType == TermInputTypeEnum.Number ||
        termInputType == TermInputTypeEnum.Range) {
      return value.toString();
    }

    if (termInputType == TermInputTypeEnum.DropDown) {
      return valueDisplayName;
    }

    if (termInputType == TermInputTypeEnum.DateTime) {
      return value != null
          ? DateFormat('MMMM dd, yyyy').format(
              DateTime.parse(
                value.toString(),
              ),
            )
          : '';
    }

    if (termInputType == TermInputTypeEnum.NumberWithOptionUnit) {
      if (id == TermTypeIdEnum.CoverMonth) {
        if (value == null) {
          return '$unitDisplayName/$defaultValue';
        }
        return '$unitDisplayName/${value.toString().split('/').last}';
      } else {
        if(value.toString().isEmpty){
          return "";
        }
        return '${NumberFormat('###,###.##').format(
          double.parse(
            value.toString().replaceAll(",", ""),
          ),
        )} $unitDisplayName';
      }
    }

    return '';
  }

  TermModel({
    this.id,
    this.name,
    this.options,
    this.status,
    this.isRequired,
    this.unit,
    this.value,
    this.defaultValue,
    this.defaultUnit,
    this.isSelecting = false,
  });

  factory TermModel.fromJson(Map<String, dynamic> json) =>
      _$TermModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermModelToJson(this);
}

@JsonSerializable()
class TermOptionModel {
  final dynamic optionKey;
  final String optionName;

  String get displayName {
    return optionName;
  }

  TermOptionModel({this.optionKey, this.optionName});

  factory TermOptionModel.fromJson(Map<String, dynamic> json) =>
      _$TermOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermOptionModelToJson(this);
}

@JsonSerializable()
class ProductModel {
  final int id;
  final String quantity;
  final String quality;
  final double price;
  final String unit;
  final name;

  ProductModel(
      {this.id, this.quantity, this.price, this.unit, this.name, this.quality});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class CreateContractModel {
  double quantity;
  int gradeTypeId;
  int coffeeTypeId;
  double price;
  double certificationPremium;
  int contractTypeId;
  DateTime deliveryDate;
  int deliveryWarehouseId;
  String specialClause;
  String coverMonth;
  String comment;
  int priceUnitTypeId;
  String contractNumber;
  int supplierId;
  int packingUnitTypeId;
  double packingQuantity;
  int certificationTypeId;
  int commodityTypeId;
  int quantityUnitTypeId;
  String cropYear;

  //UI Only
  @JsonKey(ignore: true)
  String supplierName;

  CreateContractModel({
    this.priceUnitTypeId,
    this.coverMonth,
    this.commodityTypeId,
    this.coffeeTypeId,
    this.price,
    this.comment,
    this.deliveryWarehouseId,
    this.contractTypeId,
    this.quantityUnitTypeId,
    this.gradeTypeId,
    this.contractNumber,
    this.deliveryDate,
    this.specialClause,
    this.certificationTypeId,
    this.quantity,
    this.packingQuantity,
    this.packingUnitTypeId,
    this.supplierName,
    this.supplierId,
    this.certificationPremium,
    this.cropYear,
  });

  factory CreateContractModel.fromJson(Map<String, dynamic> json) =>
      _$CreateContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateContractModelToJson(this);
}

@JsonSerializable()
class PastContractFilterParam {
  int type;
  int commodityTypeId;
  int fromYear;
  int toYear;
  int timeFrameTypeId;
  int contractTypeId;
  List<int> tenantIds;
  int gradeTypeId;
  List<int> destinationIds;
  int year;
  int month;
  int day;

  //Only UI
  @JsonKey(ignore: true)
  String supplierName;
  @JsonKey(ignore: true)
  int selectedTimeFrameName;

  PastContractFilterParam(
      {this.type,
      this.commodityTypeId,
      this.fromYear,
      this.toYear,
      this.timeFrameTypeId,
      this.selectedTimeFrameName,
      this.contractTypeId = ContractTypeEnum.Outright,
      List<int> tenantIds,
      this.supplierName,
      this.gradeTypeId,
      List<int> destinationIds,
      this.year,
      this.month,
      this.day})
      : tenantIds = tenantIds ?? [],
        destinationIds = destinationIds ?? [];

  factory PastContractFilterParam.fromJson(Map<String, dynamic> json) =>
      _$PastContractFilterParamFromJson(json);

  Map<String, dynamic> toJson() => _$PastContractFilterParamToJson(this);
}

@JsonSerializable()
class PastContractSeriesModel {
  String name;
  double value;

  PastContractSeriesModel({
    this.name,
    double value,
  }) : value = value ?? 0.0;

  factory PastContractSeriesModel.fromJson(Map<String, dynamic> json) =>
      _$PastContractSeriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PastContractSeriesModelToJson(this);
}

@JsonSerializable()
class PastContractsVolumeViewModel {
  String periodName;
  int quantity;

  PastContractsVolumeViewModel({
    this.periodName,
    this.quantity,
  });

  factory PastContractsVolumeViewModel.fromJson(Map<String, dynamic> json) =>
      _$PastContractsVolumeViewModelFromJson(json);

  Map<String, dynamic> toJson() => _$PastContractsVolumeViewModelToJson(this);
}

@JsonSerializable()
class OpenContractModel {
  final int id;
  final String contractNumber;
  final String vendorName;
  final double quantity;
  final String quantityUnitType;
  final String quality;
  final DateTime contractDate;
  final DateTime deadLine;
  final int overDueDay;
  final double price;
  final double finalPrice;
  final double deliveryBags;
  final String certCode;
  final int crop;
  final int contractTypeId;
  final double pendingNW;
  final double deliveryNetWt;
  final String priceUnitType;
  final String specialClause;
  final String remark;
  final int totalCount;

  OpenContractModel(
      {this.id,
      this.contractNumber,
      this.vendorName,
      this.quantity,
      this.quantityUnitType,
      this.quality,
      this.contractDate,
      this.deadLine,
      this.overDueDay,
      this.price,
      this.finalPrice,
      this.deliveryBags,
      this.certCode,
      this.crop,
      this.contractTypeId,
      this.pendingNW,
      this.deliveryNetWt,
      this.priceUnitType,
      this.specialClause,
      this.remark,
      this.totalCount});

  factory OpenContractModel.fromJson(Map<String, dynamic> json) =>
      _$OpenContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenContractModelToJson(this);
}

@JsonSerializable()
class OpenContractAdvanceSearchModel extends PaginationParam {
  int openContractFilterTypeId;
  String keyword;
  int tenantId;
  int gradeTypeId;
  List<int> contractTypeIds;
  List<int> commodityTypeIds;
  List<int> coverMonths;
  List<int> deliveryWarehouseIds;
  List<int> coffeeTypeIds;
  List<SortCriteriaModel> sort;

  //UI only
  @JsonKey(ignore: true)
  bool selectAllCommodity;
  @JsonKey(ignore: true)
  bool selectAllCoverMonth;
  @JsonKey(ignore: true)
  bool selectAllContractType;

  OpenContractAdvanceSearchModel({
    this.openContractFilterTypeId,
    this.keyword,
    this.tenantId,
    this.gradeTypeId,
    List<int> contractTypeIds,
    List<int> commodityTypeIds,
    List<int> coverMonths,
    List<int> deliveryWarehouseIds,
    List<int> coffeeTypeIds,
    this.sort,
    this.selectAllCommodity = false,
    this.selectAllContractType = false,
    this.selectAllCoverMonth = false,
  })  : contractTypeIds = contractTypeIds ?? [],
        commodityTypeIds = commodityTypeIds ?? [],
        coverMonths = coverMonths ?? [],
        deliveryWarehouseIds = deliveryWarehouseIds ?? [],
        coffeeTypeIds = coffeeTypeIds ?? [];

  factory OpenContractAdvanceSearchModel.fromJson(Map<String, dynamic> json) =>
      _$OpenContractAdvanceSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenContractAdvanceSearchModelToJson(this);
}

@JsonSerializable()
class OpenContractDataResultModel {
  int totalCount;
  List<OpenContractModel> objects;

  OpenContractDataResultModel(
      {this.totalCount, List<OpenContractModel> objects})
      : objects = objects ?? [];

  factory OpenContractDataResultModel.fromJson(Map<String, dynamic> json) =>
      _$OpenContractDataResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenContractDataResultModelToJson(this);
}

@JsonSerializable()
class OpenContractSortParam {
  bool isDescVendorName;
  bool isDescContractNumber;
  bool isDescQuantity;
  bool isDescQuality;
  bool isDescContractDate;
  bool isDescDeadline;
  bool isDescOverdue;
  bool isDescDeliveryBag;
  bool isDescDeliveryNet;
  bool isDescPendingNW;
  bool isDescPrice;
  bool isDescFinalPrice;
  bool isDescPriceUnitCode;
  bool isDescCertCode;
  bool isDescCrop;
  bool isDescRemark;

  OpenContractSortParam(
      {List<int> contractTypes,
      this.isDescVendorName,
      this.isDescContractNumber,
      this.isDescQuantity,
      this.isDescQuality,
      this.isDescContractDate,
      this.isDescDeadline,
      this.isDescOverdue,
      this.isDescDeliveryBag,
      this.isDescDeliveryNet,
      this.isDescPendingNW,
      this.isDescPrice,
      this.isDescFinalPrice,
      this.isDescPriceUnitCode,
      this.isDescCertCode,
      this.isDescCrop,
      this.isDescRemark});

  factory OpenContractSortParam.fromJson(Map<String, dynamic> json) =>
      _$OpenContractSortParamFromJson(json);

  Map<String, dynamic> toJson() => _$OpenContractSortParamToJson(this);
}

@JsonSerializable()
class PastContractDetailModel {
  double value;
  String tenantName;
  String unit;

  PastContractDetailModel({double value, this.tenantName, String unit})
      : value = value ?? 0.0,
        unit = unit ?? "";

  factory PastContractDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PastContractDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$PastContractDetailModelToJson(this);
}

@JsonSerializable()
class SortCriteriaModel {
  String selector;
  bool desc;

  SortCriteriaModel({this.selector, this.desc});

  factory SortCriteriaModel.fromJson(Map<String, dynamic> json) =>
      _$SortCriteriaModelFromJson(json);

  Map<String, dynamic> toJson() => _$SortCriteriaModelToJson(this);
}

@JsonSerializable()
class ContractPerformanceSeriesModel {
  String name;
  double overall;
  double quality;
  double timeDelivery;
  double cooperation;
  double documentation;

  ContractPerformanceSeriesModel(
      {String name,
      double overall,
      double quality,
      double timeDelivery,
      double cooperation,
      double documentation})
      : name = name ?? "",
        overall = overall ?? 0.0,
        quality = quality ?? 0.0,
        timeDelivery = timeDelivery ?? 0.0,
        cooperation = cooperation ?? 0.0,
        documentation = documentation ?? 0.0;

  factory ContractPerformanceSeriesModel.fromJson(Map<String, dynamic> json) =>
      _$ContractPerformanceSeriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractPerformanceSeriesModelToJson(this);
}
