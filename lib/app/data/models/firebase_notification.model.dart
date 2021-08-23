import 'package:json_annotation/json_annotation.dart';

part 'firebase_notification.model.g.dart';

@JsonSerializable(explicitToJson: true)
class FirebaseNotificationModel {
  final String type;
  final dynamic payload;

  FirebaseNotificationModel({
    this.type,
    this.payload,
  });

  factory FirebaseNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$FirebaseNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseNotificationModelToJson(this);
}


