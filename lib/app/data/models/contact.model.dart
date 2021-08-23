import 'package:agree_n/app/data/models/share.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.model.g.dart';

@JsonSerializable()
class ContactModel {
  final int tenantId;
  final String emailAddress;
  final String avatarUrl;
  final String phoneNumber;
  final String companyName;
  final String contactName;
  final String address;
  final String conversationId;
  final List<int> serviceTypeIds;
  final String firstName;
  final String lastName;

  ContactModel(
      {this.tenantId,
      this.emailAddress,
      this.avatarUrl,
      this.phoneNumber,
      this.companyName,
      this.conversationId,
      this.firstName,
      this.lastName,
      this.address,
      this.contactName,
      List<int> serviceTypeIds})
      : serviceTypeIds = serviceTypeIds ?? [];

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}

@JsonSerializable()
class ContactRateModel {
  final int id;
  final int contactTypeId;
  final String contactName;
  final double contactScore;
  final DateTime createdDate;
  int numberOfContracts;
  List<ContactScoreModel> contactRates;

  ContactRateModel(
      {this.id,
      this.contactTypeId,
      this.contactName,
      this.numberOfContracts,
      this.contactScore,
      this.createdDate,
      this.contactRates});

  factory ContactRateModel.fromJson(Map<String, dynamic> json) =>
      _$ContactRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactRateModelToJson(this);
}

@JsonSerializable()
class ContactScoreModel {
  int scoreTypeId;
  double value;

  ContactScoreModel({this.scoreTypeId, this.value});

  factory ContactScoreModel.fromJson(Map<String, dynamic> json) =>
      _$ContactScoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactScoreModelToJson(this);
}

@JsonSerializable()
class SearchContactModel {
  String searchTerm;
  List<int> contactTypes; // Coffee, Trucking, Machineries, Packing, Others
  int sortBy;

  SearchContactModel({this.contactTypes, this.searchTerm, this.sortBy});

  factory SearchContactModel.fromJson(Map<String, dynamic> json) =>
      _$SearchContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchContactModelToJson(this);
}

@JsonSerializable()
class ContactParamModel extends PaginationParam {
  int contactFilterTypeId;
  String keyword;
  List<int> serviceTypeIds;

  ContactParamModel(
      {this.contactFilterTypeId, this.keyword, List<int> serviceTypeIds})
      : serviceTypeIds = serviceTypeIds ?? [];

  factory ContactParamModel.fromJson(Map<String, dynamic> json) =>
      _$ContactParamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactParamModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ContactResultModel {
  int totalCount;
  List<ContactModel> objects;

  ContactResultModel({this.totalCount, List<ContactModel> objects})
      : objects = objects ?? [];

  factory ContactResultModel.fromJson(Map<String, dynamic> json) =>
      _$ContactResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactResultModelToJson(this);
}
