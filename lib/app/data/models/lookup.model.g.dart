// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarehouseModel _$WarehouseModelFromJson(Map<String, dynamic> json) {
  return WarehouseModel(
    id: json['id'] as int,
    tenantId: json['tenantId'] as int,
    name: json['name'] as String,
    locationId: json['locationId'] as int,
    capacity: (json['capacity'] as num)?.toDouble(),
    capacityUnitTypeId: json['capacityUnitTypeId'] as int,
  );
}

Map<String, dynamic> _$WarehouseModelToJson(WarehouseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'name': instance.name,
      'locationId': instance.locationId,
      'capacity': instance.capacity,
      'capacityUnitTypeId': instance.capacityUnitTypeId,
    };

WarehouseResultModel _$WarehouseResultModelFromJson(Map<String, dynamic> json) {
  return WarehouseResultModel(
    tenantId: json['tenantId'] as int,
    warehouses: (json['warehouses'] as List)
            ?.map((e) => e == null
                ? null
                : WarehouseModel.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$WarehouseResultModelToJson(
        WarehouseResultModel instance) =>
    <String, dynamic>{
      'tenantId': instance.tenantId,
      'warehouses': instance.warehouses,
    };

CoverMonthModel _$CoverMonthModelFromJson(Map<String, dynamic> json) {
  return CoverMonthModel(
    name: json['name'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$CoverMonthModelToJson(CoverMonthModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

AppLookupModel _$AppLookupModelFromJson(Map<String, dynamic> json) {
  return AppLookupModel(
    id: json['id'] as int,
    name: json['name'] as String,
    displayName: json['displayName'] as String,
    description: json['description'] as String,
    defaultValue: json['defaultValue'] as int,
    values: (json['values'] as List)
            ?.map((e) => e == null
                ? null
                : LookupOptionModel.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$AppLookupModelToJson(AppLookupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'defaultValue': instance.defaultValue,
      'values': instance.values?.map((e) => e?.toJson())?.toList(),
    };

LookupOptionModel _$LookupOptionModelFromJson(Map<String, dynamic> json) {
  return LookupOptionModel(
    id: json['id'] as int,
    termId: json['termId'] as int,
    name: json['name'] as String,
    displayName: json['displayName'] as String,
    description: json['description'] as String,
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$LookupOptionModelToJson(LookupOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'termId': instance.termId,
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'code': instance.code,
    };

CropYearModel _$CropYearModelFromJson(Map<String, dynamic> json) {
  return CropYearModel(
    cropYear: json['cropYear'] as String,
    cropYearName: json['cropYearName'] as String,
  );
}

Map<String, dynamic> _$CropYearModelToJson(CropYearModel instance) =>
    <String, dynamic>{
      'cropYear': instance.cropYear,
      'cropYearName': instance.cropYearName,
    };
