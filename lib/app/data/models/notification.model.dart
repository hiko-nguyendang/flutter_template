import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationResultModel {
  final int numberOfUnread;
  final List<NotificationModel> objects;
  final int totalCount;

  NotificationResultModel({this.numberOfUnread, this.objects, this.totalCount});

  factory NotificationResultModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResultModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationModel {
  final int notificationId;
  final List<TranslateModel> title;
  final List<TranslateModel> message;
  final int typeId;
  final int eventTypeId;
  final int creatorId;
  final String creator;
  final int entityId;
  final int entityTypeId;
  bool isUnread;
  final DateTime createdDate;
  final DateTime modifiedDate;
  final String creatorFirstName;
  final String creatorLastName;
  final String creatorUrlImage;
  final int numberOfUnread;

  String get displayTitle {
    if (title == null || title.isEmpty) {
      return "";
    } else {
      final titleWithCurrentLanguage =
          title.firstWhere((_) => _.key == Get.locale.languageCode);
      return titleWithCurrentLanguage.value;
    }
  }

  String get displayMessage {
    if (message == null || message.isEmpty) {
      return "";
    } else {
      final messageWithCurrentLanguage =
          message.firstWhere((_) => _.key == Get.locale.languageCode);
      return messageWithCurrentLanguage.value;
    }
  }

  NotificationModel(
      {this.notificationId,
      this.typeId,
      this.title,
      this.message,
      this.createdDate,
      this.creatorId,
      this.creator,
      this.entityId,
      this.entityTypeId,
      this.eventTypeId,
      this.isUnread,
      this.modifiedDate,
      this.creatorFirstName,
      this.creatorLastName,
      this.creatorUrlImage,
      this.numberOfUnread});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}

@JsonSerializable()
class TranslateModel {
  final String key;
  final String value;

  TranslateModel({this.key, this.value});

  factory TranslateModel.fromJson(Map<String, dynamic> json) =>
      _$TranslateModelFromJson(json);

  Map<String, dynamic> toJson() => _$TranslateModelToJson(this);
}

@JsonSerializable()
class ReadNotificationModel {
  int notificationId;
  bool isRead;

  ReadNotificationModel({this.isRead, this.notificationId});

  factory ReadNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$ReadNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReadNotificationModelToJson(this);
}
