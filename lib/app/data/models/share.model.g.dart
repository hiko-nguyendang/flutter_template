// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParam _$PaginationParamFromJson(Map<String, dynamic> json) {
  return PaginationParam(
    pageNumber: json['pageNumber'] as int,
    pageSize: json['pageSize'] as int,
  );
}

Map<String, dynamic> _$PaginationParamToJson(PaginationParam instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
    };

PaginationResult _$PaginationResultFromJson(Map<String, dynamic> json) {
  return PaginationResult(
    objects: json['objects'] as List,
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$PaginationResultToJson(PaginationResult instance) =>
    <String, dynamic>{
      'objects': instance.objects,
      'totalCount': instance.totalCount,
    };

LoadParamModel _$LoadParamModelFromJson(Map<String, dynamic> json) {
  return LoadParamModel(
    customParams: json['customParams'],
    loadOptions: json['loadOptions'] == null
        ? null
        : DataSourceLoadOptions.fromJson(
            json['loadOptions'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoadParamModelToJson(LoadParamModel instance) =>
    <String, dynamic>{
      'loadOptions': instance.loadOptions,
      'customParams': instance.customParams,
    };

DataSourceLoadOptions _$DataSourceLoadOptionsFromJson(
    Map<String, dynamic> json) {
  return DataSourceLoadOptions(
    searchExpr: json['searchExpr'] as String,
    searchOperation: json['searchOperation'] as String,
    searchValue: json['searchValue'] as String,
    skip: json['skip'] as int,
    take: json['take'] as int,
  );
}

Map<String, dynamic> _$DataSourceLoadOptionsToJson(
        DataSourceLoadOptions instance) =>
    <String, dynamic>{
      'searchExpr': instance.searchExpr,
      'searchOperation': instance.searchOperation,
      'searchValue': instance.searchValue,
      'skip': instance.skip,
      'take': instance.take,
    };

DataResultModel _$DataResultModelFromJson(Map<String, dynamic> json) {
  return DataResultModel(
    data: json['data'],
    totalCount: json['totalCount'] as int,
    groupCount: json['groupCount'] as int,
  );
}

Map<String, dynamic> _$DataResultModelToJson(DataResultModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'groupCount': instance.groupCount,
    };

BaseModel _$BaseModelFromJson(Map<String, dynamic> json) {
  return BaseModel(
    key: json['key'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$BaseModelToJson(BaseModel instance) => <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };
