// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResultModel _$NotificationResultModelFromJson(
    Map<String, dynamic> json) {
  return NotificationResultModel(
    numberOfUnread: json['numberOfUnread'] as int,
    objects: (json['objects'] as List)
        ?.map((e) => e == null
            ? null
            : NotificationModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$NotificationResultModelToJson(
        NotificationResultModel instance) =>
    <String, dynamic>{
      'numberOfUnread': instance.numberOfUnread,
      'objects': instance.objects?.map((e) => e?.toJson())?.toList(),
      'totalCount': instance.totalCount,
    };

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    notificationId: json['notificationId'] as int,
    typeId: json['typeId'] as int,
    title: (json['title'] as List)
        ?.map((e) => e == null
            ? null
            : TranslateModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    message: (json['message'] as List)
        ?.map((e) => e == null
            ? null
            : TranslateModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    creatorId: json['creatorId'] as int,
    creator: json['creator'] as String,
    entityId: json['entityId'] as int,
    entityTypeId: json['entityTypeId'] as int,
    eventTypeId: json['eventTypeId'] as int,
    isUnread: json['isUnread'] as bool,
    modifiedDate: json['modifiedDate'] == null
        ? null
        : DateTime.parse(json['modifiedDate'] as String),
    creatorFirstName: json['creatorFirstName'] as String,
    creatorLastName: json['creatorLastName'] as String,
    creatorUrlImage: json['creatorUrlImage'] as String,
    numberOfUnread: json['numberOfUnread'] as int,
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'title': instance.title?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.map((e) => e?.toJson())?.toList(),
      'typeId': instance.typeId,
      'eventTypeId': instance.eventTypeId,
      'creatorId': instance.creatorId,
      'creator': instance.creator,
      'entityId': instance.entityId,
      'entityTypeId': instance.entityTypeId,
      'isUnread': instance.isUnread,
      'createdDate': instance.createdDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'creatorFirstName': instance.creatorFirstName,
      'creatorLastName': instance.creatorLastName,
      'creatorUrlImage': instance.creatorUrlImage,
      'numberOfUnread': instance.numberOfUnread,
    };

TranslateModel _$TranslateModelFromJson(Map<String, dynamic> json) {
  return TranslateModel(
    key: json['key'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$TranslateModelToJson(TranslateModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

ReadNotificationModel _$ReadNotificationModelFromJson(
    Map<String, dynamic> json) {
  return ReadNotificationModel(
    isRead: json['isRead'] as bool,
    notificationId: json['notificationId'] as int,
  );
}

Map<String, dynamic> _$ReadNotificationModelToJson(
        ReadNotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'isRead': instance.isRead,
    };
