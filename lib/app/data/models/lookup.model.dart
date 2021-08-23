import 'package:json_annotation/json_annotation.dart';
import 'package:get/get.dart';

import 'package:agree_n/app/utils/string_helper.dart';

part 'lookup.model.g.dart';

@JsonSerializable()
class WarehouseModel {
  final int id;
  final int tenantId;
  final String name;
  final int locationId;
  final double capacity;
  final int capacityUnitTypeId;

  WarehouseModel(
      {this.id,
      this.tenantId,
      this.name,
      this.locationId,
      this.capacity,
      this.capacityUnitTypeId});

  factory WarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);
}

@JsonSerializable()
class WarehouseResultModel {
  final int tenantId;
  @JsonKey(defaultValue: [])
  final List<WarehouseModel> warehouses;

  WarehouseResultModel({this.tenantId, this.warehouses});

  factory WarehouseResultModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseResultModelToJson(this);
}

@JsonSerializable()
class CoverMonthModel {
  int id;
  String name;

  CoverMonthModel({
    this.name,
    this.id,
  });

  factory CoverMonthModel.fromJson(Map<String, dynamic> json) =>
      _$CoverMonthModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoverMonthModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AppLookupModel {
  int id;
  String name;
  String displayName;
  String description;
  int defaultValue;
  @JsonKey(defaultValue: [])
  List<LookupOptionModel> values;

  AppLookupModel(
      {this.id,
      this.name,
      this.displayName,
      this.description,
      this.defaultValue,
      List<LookupOptionModel> values})
      : values = values ?? [];

  factory AppLookupModel.fromJson(Map<String, dynamic> json) =>
      _$AppLookupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppLookupModelToJson(this);
}

@JsonSerializable()
class LookupOptionModel {
  int id;
  int termId;
  String name;
  String displayName;
  String description;
  String code;

  String get termOptionName {
    if (name == null) {
      return displayName;
    }
    return 'TermOptionName_${StringHelper.stringToAscii(name)}'.tr;
  }

  LookupOptionModel(
      {this.id,
      this.termId,
      this.name,
      this.displayName,
      this.description,
      this.code});

  factory LookupOptionModel.fromJson(Map<String, dynamic> json) =>
      _$LookupOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$LookupOptionModelToJson(this);
}

@JsonSerializable()
class CropYearModel{
  final String cropYear;
  final String cropYearName;

  CropYearModel({this.cropYear, this.cropYearName});

  factory CropYearModel.fromJson(Map<String, dynamic> json) =>
      _$CropYearModelFromJson(json);

  Map<String, dynamic> toJson() => _$CropYearModelToJson(this);
}