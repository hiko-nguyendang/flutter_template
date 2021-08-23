import 'package:json_annotation/json_annotation.dart';

part 'share.model.g.dart';

@JsonSerializable()
class PaginationParam {
  int pageNumber;
  int pageSize;

  PaginationParam({this.pageNumber = 1, this.pageSize = 10});

  factory PaginationParam.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PaginationResult {
  List<dynamic> objects;
  int totalCount;

  PaginationResult({this.objects, this.totalCount});

  factory PaginationResult.fromJson(Map<String, dynamic> json) =>
      _$PaginationResultFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResultToJson(this);
}

@JsonSerializable()
class LoadParamModel {
  DataSourceLoadOptions loadOptions;
  dynamic customParams;

  LoadParamModel({this.customParams, this.loadOptions});

  factory LoadParamModel.fromJson(Map<String, dynamic> json) =>
      _$LoadParamModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoadParamModelToJson(this);
}

@JsonSerializable()
class DataSourceLoadOptions {
  String searchExpr;
  String searchOperation;
  String searchValue;
  int skip;
  int take;

  DataSourceLoadOptions(
      {this.searchExpr,
      this.searchOperation,
      this.searchValue,
      this.skip = 0,
      this.take = 10});

  factory DataSourceLoadOptions.fromJson(Map<String, dynamic> json) =>
      _$DataSourceLoadOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$DataSourceLoadOptionsToJson(this);
}

@JsonSerializable()
class DataResultModel {
  dynamic data;
  int totalCount;
  int groupCount;

  DataResultModel({this.data, this.totalCount, this.groupCount});

  factory DataResultModel.fromJson(Map<String, dynamic> json) =>
      _$DataResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataResultModelToJson(this);
}

@JsonSerializable()
class BaseModel{
  final String key;
  final String value;

  BaseModel({this.key, this.value});

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}