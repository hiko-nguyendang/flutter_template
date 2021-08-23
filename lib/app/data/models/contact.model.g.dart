// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) {
  return ContactModel(
    tenantId: json['tenantId'] as int,
    emailAddress: json['emailAddress'] as String,
    avatarUrl: json['avatarUrl'] as String,
    phoneNumber: json['phoneNumber'] as String,
    companyName: json['companyName'] as String,
    conversationId: json['conversationId'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    address: json['address'] as String,
    contactName: json['contactName'] as String,
    serviceTypeIds:
        (json['serviceTypeIds'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'tenantId': instance.tenantId,
      'emailAddress': instance.emailAddress,
      'avatarUrl': instance.avatarUrl,
      'phoneNumber': instance.phoneNumber,
      'companyName': instance.companyName,
      'contactName': instance.contactName,
      'address': instance.address,
      'conversationId': instance.conversationId,
      'serviceTypeIds': instance.serviceTypeIds,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

ContactRateModel _$ContactRateModelFromJson(Map<String, dynamic> json) {
  return ContactRateModel(
    id: json['id'] as int,
    contactTypeId: json['contactTypeId'] as int,
    contactName: json['contactName'] as String,
    numberOfContracts: json['numberOfContracts'] as int,
    contactScore: (json['contactScore'] as num)?.toDouble(),
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    contactRates: (json['contactRates'] as List)
        ?.map((e) => e == null
            ? null
            : ContactScoreModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ContactRateModelToJson(ContactRateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contactTypeId': instance.contactTypeId,
      'contactName': instance.contactName,
      'contactScore': instance.contactScore,
      'createdDate': instance.createdDate?.toIso8601String(),
      'numberOfContracts': instance.numberOfContracts,
      'contactRates': instance.contactRates,
    };

ContactScoreModel _$ContactScoreModelFromJson(Map<String, dynamic> json) {
  return ContactScoreModel(
    scoreTypeId: json['scoreTypeId'] as int,
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ContactScoreModelToJson(ContactScoreModel instance) =>
    <String, dynamic>{
      'scoreTypeId': instance.scoreTypeId,
      'value': instance.value,
    };

SearchContactModel _$SearchContactModelFromJson(Map<String, dynamic> json) {
  return SearchContactModel(
    contactTypes:
        (json['contactTypes'] as List)?.map((e) => e as int)?.toList(),
    searchTerm: json['searchTerm'] as String,
    sortBy: json['sortBy'] as int,
  );
}

Map<String, dynamic> _$SearchContactModelToJson(SearchContactModel instance) =>
    <String, dynamic>{
      'searchTerm': instance.searchTerm,
      'contactTypes': instance.contactTypes,
      'sortBy': instance.sortBy,
    };

ContactParamModel _$ContactParamModelFromJson(Map<String, dynamic> json) {
  return ContactParamModel(
    contactFilterTypeId: json['contactFilterTypeId'] as int,
    keyword: json['keyword'] as String,
    serviceTypeIds:
        (json['serviceTypeIds'] as List)?.map((e) => e as int)?.toList(),
  )
    ..pageNumber = json['pageNumber'] as int
    ..pageSize = json['pageSize'] as int;
}

Map<String, dynamic> _$ContactParamModelToJson(ContactParamModel instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'contactFilterTypeId': instance.contactFilterTypeId,
      'keyword': instance.keyword,
      'serviceTypeIds': instance.serviceTypeIds,
    };

ContactResultModel _$ContactResultModelFromJson(Map<String, dynamic> json) {
  return ContactResultModel(
    totalCount: json['totalCount'] as int,
    objects: (json['objects'] as List)
        ?.map((e) =>
            e == null ? null : ContactModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ContactResultModelToJson(ContactResultModel instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'objects': instance.objects?.map((e) => e?.toJson())?.toList(),
    };
