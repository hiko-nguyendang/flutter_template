// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_notification.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseNotificationModel _$FirebaseNotificationModelFromJson(
    Map<String, dynamic> json) {
  return FirebaseNotificationModel(
    type: json['type'] as String,
    payload: json['payload'],
  );
}

Map<String, dynamic> _$FirebaseNotificationModelToJson(
        FirebaseNotificationModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
    };
