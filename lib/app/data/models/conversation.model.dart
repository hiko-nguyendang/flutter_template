import 'package:dash_chat/dash_chat.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/settings/app_config.dart';
import 'package:agree_n/app/data/models/contract.model.dart';

part 'conversation.model.g.dart';

@JsonSerializable()
class ConversationModel {
  final String id;
  final String title;
  @JsonKey(defaultValue: AppConfig.DEFAULT_USER_AVATAR)
  final String avatarUrl;
  final DateTime lastSeen;
  String lastMessage;
  int unreadMessageCount;
  final List<int> participants;
  final bool active;
  final int statusId;

  bool get isSeen => unreadMessageCount == 0;

  ConversationModel({
    this.id,
    this.title,
    this.avatarUrl,
    this.lastSeen,
    this.lastMessage,
    this.unreadMessageCount,
    this.active,
    this.participants,
    this.statusId,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}

@JsonSerializable()
class ConversationDetailModel {
  final String conversationId;
  NegotiationOfferModel negotiationOffer;
  List<MessageModel> messages;
  final int totalMessageCount;
  final String title;
  final List<int> participants;

  ConversationDetailModel(
      {this.conversationId,
      this.negotiationOffer,
      this.messages,
      this.totalMessageCount,
      this.title,
      this.participants});

  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationDetailModelToJson(this);
}

@JsonSerializable()
class NegotiationOfferModel {
  int offerNegotiationId;
  final String contractNumber;
  final int locationCode;
  final String contractPreviewUrl;
  List<TermModel> terms;
  int status;
  final String otpNumber;

  NegotiationOfferModel(
      {this.offerNegotiationId,
      this.contractNumber,
      this.terms,
      this.status,
      this.contractPreviewUrl,
      this.locationCode,
      this.otpNumber});

  factory NegotiationOfferModel.fromJson(Map<String, dynamic> json) =>
      _$NegotiationOfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$NegotiationOfferModelToJson(this);
}

@JsonSerializable()
class ConversationSearchModel {
  ConversationSearchModel();

  factory ConversationSearchModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationSearchModelToJson(this);
}

@JsonSerializable()
class CreateConversationInputModel {
  String title;
  int offerId;
  int conversationTypeId;
  int requestId;
  int creatorId;
  List<int> participantIds;

  CreateConversationInputModel(
      {this.title,
      this.offerId,
      this.participantIds,
      this.requestId,
      this.creatorId,
      this.conversationTypeId});

  factory CreateConversationInputModel.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationInputModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateConversationInputModelToJson(this);
}

@JsonSerializable()
class MessageInputModel {
  String eventName;
  dynamic message;

  MessageInputModel({this.message, this.eventName});

  factory MessageInputModel.fromJson(Map<String, dynamic> json) =>
      _$MessageInputModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageInputModelToJson(this);
}

@JsonSerializable()
class ReplyOfferModel {
  String messageId;
  int termId;
  int termStatus;
  MessageUserModel sender;

  ReplyOfferModel({
    this.termId,
    this.termStatus,
    this.sender,
    this.messageId,
  });

  factory ReplyOfferModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyOfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyOfferModelToJson(this);
}

@JsonSerializable()
class MessageModel {
  String id;
  String text;
  String conversationId;
  List<MessageFileModel> files;
  DateTime createdDate;
  DateTime modifiedDate;
  MessageUserModel sender;
  TermMessageModel customData;

  int messageTypeId;
  int deliveryWarehouseId;
  String contractNumber;

  ChatMessage get toChatMessage {
    if (customData != null) {
      return ChatMessage(
        id: id,
        text: text,
        user: ChatUser(
          uid: sender.userId.toString(),
          avatar: sender.userAvatar,
          name: sender.fullName,
        ),
        createdAt: createdDate,
        customProperties: {
          "status": customData.termStatus,
          "type": customData.termId,
          "messageName": TermTypeIdEnum.getName(customData.termId),
        },
      );
    } else {
      return ChatMessage(
        text: text,
        image: files != null && files.isNotEmpty ? files.first.url : null,
        user: ChatUser(
          uid: sender != null ? sender.userId.toString() : '',
          avatar: sender != null ? sender.userAvatar : '',
          name: sender != null ? sender.fullName : '',
        ),
        createdAt: createdDate,
      );
    }
  }

  MessageModel(
      {this.id,
      this.text,
      this.conversationId,
      this.files,
      this.createdDate,
      this.modifiedDate,
      this.sender,
      this.customData,
      this.contractNumber,
      this.deliveryWarehouseId,
      this.messageTypeId});

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

@JsonSerializable()
class SimpleMessageModel {
  final String text;
  final List<MessageFileModel> files;
  final String conversationId;
  final MessageUserModel sender;

  SimpleMessageModel({
    this.text,
    this.files,
    this.sender,
    this.conversationId,
  });

  factory SimpleMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleMessageModelToJson(this);
}

@JsonSerializable()
class TermMessageModel {
  final int termId;
  final int termStatus;
  final String termUnit;
  final dynamic termValue;

  final String termDisplayName;
  final String termContent;

  TermMessageModel(
      {this.termId,
      this.termUnit,
      this.termStatus,
      this.termValue,
      this.termDisplayName,
      this.termContent});

  factory TermMessageModel.fromJson(Map<String, dynamic> json) =>
      _$TermMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermMessageModelToJson(this);
}

@JsonSerializable()
class MessageFileModel {
  final String url;
  final String name;

  MessageFileModel({
    this.url,
    this.name,
  });

  factory MessageFileModel.fromJson(Map<String, dynamic> json) =>
      _$MessageFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageFileModelToJson(this);
}

@JsonSerializable()
class MessageUserModel {
  int userId;
  String userAvatar;
  String userName;
  String fullName;

  MessageUserModel({
    this.userId,
    this.userAvatar,
    this.userName,
    this.fullName,
  });

  factory MessageUserModel.fromJson(Map<String, dynamic> json) =>
      _$MessageUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageUserModelToJson(this);
}
