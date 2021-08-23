// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return ConversationModel(
    id: json['id'] as String,
    title: json['title'] as String,
    avatarUrl: json['avatarUrl'] as String ??
        'https://agreenapp.blob.core.windows.net/uploads/images/avatar-default.png',
    lastSeen: json['lastSeen'] == null
        ? null
        : DateTime.parse(json['lastSeen'] as String),
    lastMessage: json['lastMessage'] as String,
    unreadMessageCount: json['unreadMessageCount'] as int,
    active: json['active'] as bool,
    participants:
        (json['participants'] as List)?.map((e) => e as int)?.toList(),
    statusId: json['statusId'] as int,
  );
}

Map<String, dynamic> _$ConversationModelToJson(ConversationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'avatarUrl': instance.avatarUrl,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'lastMessage': instance.lastMessage,
      'unreadMessageCount': instance.unreadMessageCount,
      'participants': instance.participants,
      'active': instance.active,
      'statusId': instance.statusId,
    };

ConversationDetailModel _$ConversationDetailModelFromJson(
    Map<String, dynamic> json) {
  return ConversationDetailModel(
    conversationId: json['conversationId'] as String,
    negotiationOffer: json['negotiationOffer'] == null
        ? null
        : NegotiationOfferModel.fromJson(
            json['negotiationOffer'] as Map<String, dynamic>),
    messages: (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : MessageModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalMessageCount: json['totalMessageCount'] as int,
    title: json['title'] as String,
    participants:
        (json['participants'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$ConversationDetailModelToJson(
        ConversationDetailModel instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'negotiationOffer': instance.negotiationOffer,
      'messages': instance.messages,
      'totalMessageCount': instance.totalMessageCount,
      'title': instance.title,
      'participants': instance.participants,
    };

NegotiationOfferModel _$NegotiationOfferModelFromJson(
    Map<String, dynamic> json) {
  return NegotiationOfferModel(
    offerNegotiationId: json['offerNegotiationId'] as int,
    contractNumber: json['contractNumber'] as String,
    terms: (json['terms'] as List)
        ?.map((e) =>
            e == null ? null : TermModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: json['status'] as int,
    contractPreviewUrl: json['contractPreviewUrl'] as String,
    locationCode: json['locationCode'] as int,
    otpNumber: json['otpNumber'] as String,
  );
}

Map<String, dynamic> _$NegotiationOfferModelToJson(
        NegotiationOfferModel instance) =>
    <String, dynamic>{
      'offerNegotiationId': instance.offerNegotiationId,
      'contractNumber': instance.contractNumber,
      'locationCode': instance.locationCode,
      'contractPreviewUrl': instance.contractPreviewUrl,
      'terms': instance.terms,
      'status': instance.status,
      'otpNumber': instance.otpNumber,
    };

ConversationSearchModel _$ConversationSearchModelFromJson(
    Map<String, dynamic> json) {
  return ConversationSearchModel();
}

Map<String, dynamic> _$ConversationSearchModelToJson(
        ConversationSearchModel instance) =>
    <String, dynamic>{};

CreateConversationInputModel _$CreateConversationInputModelFromJson(
    Map<String, dynamic> json) {
  return CreateConversationInputModel(
    title: json['title'] as String,
    offerId: json['offerId'] as int,
    participantIds:
        (json['participantIds'] as List)?.map((e) => e as int)?.toList(),
    requestId: json['requestId'] as int,
    creatorId: json['creatorId'] as int,
    conversationTypeId: json['conversationTypeId'] as int,
  );
}

Map<String, dynamic> _$CreateConversationInputModelToJson(
        CreateConversationInputModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'offerId': instance.offerId,
      'conversationTypeId': instance.conversationTypeId,
      'requestId': instance.requestId,
      'creatorId': instance.creatorId,
      'participantIds': instance.participantIds,
    };

MessageInputModel _$MessageInputModelFromJson(Map<String, dynamic> json) {
  return MessageInputModel(
    message: json['message'],
    eventName: json['eventName'] as String,
  );
}

Map<String, dynamic> _$MessageInputModelToJson(MessageInputModel instance) =>
    <String, dynamic>{
      'eventName': instance.eventName,
      'message': instance.message,
    };

ReplyOfferModel _$ReplyOfferModelFromJson(Map<String, dynamic> json) {
  return ReplyOfferModel(
    termId: json['termId'] as int,
    termStatus: json['termStatus'] as int,
    sender: json['sender'] == null
        ? null
        : MessageUserModel.fromJson(json['sender'] as Map<String, dynamic>),
    messageId: json['messageId'] as String,
  );
}

Map<String, dynamic> _$ReplyOfferModelToJson(ReplyOfferModel instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'termId': instance.termId,
      'termStatus': instance.termStatus,
      'sender': instance.sender,
    };

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
    id: json['id'] as String,
    text: json['text'] as String,
    conversationId: json['conversationId'] as String,
    files: (json['files'] as List)
        ?.map((e) => e == null
            ? null
            : MessageFileModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    modifiedDate: json['modifiedDate'] == null
        ? null
        : DateTime.parse(json['modifiedDate'] as String),
    sender: json['sender'] == null
        ? null
        : MessageUserModel.fromJson(json['sender'] as Map<String, dynamic>),
    customData: json['customData'] == null
        ? null
        : TermMessageModel.fromJson(json['customData'] as Map<String, dynamic>),
    contractNumber: json['contractNumber'] as String,
    deliveryWarehouseId: json['deliveryWarehouseId'] as int,
    messageTypeId: json['messageTypeId'] as int,
  );
}

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'conversationId': instance.conversationId,
      'files': instance.files,
      'createdDate': instance.createdDate?.toIso8601String(),
      'modifiedDate': instance.modifiedDate?.toIso8601String(),
      'sender': instance.sender,
      'customData': instance.customData,
      'messageTypeId': instance.messageTypeId,
      'deliveryWarehouseId': instance.deliveryWarehouseId,
      'contractNumber': instance.contractNumber,
    };

SimpleMessageModel _$SimpleMessageModelFromJson(Map<String, dynamic> json) {
  return SimpleMessageModel(
    text: json['text'] as String,
    files: (json['files'] as List)
        ?.map((e) => e == null
            ? null
            : MessageFileModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    sender: json['sender'] == null
        ? null
        : MessageUserModel.fromJson(json['sender'] as Map<String, dynamic>),
    conversationId: json['conversationId'] as String,
  );
}

Map<String, dynamic> _$SimpleMessageModelToJson(SimpleMessageModel instance) =>
    <String, dynamic>{
      'text': instance.text,
      'files': instance.files,
      'conversationId': instance.conversationId,
      'sender': instance.sender,
    };

TermMessageModel _$TermMessageModelFromJson(Map<String, dynamic> json) {
  return TermMessageModel(
    termId: json['termId'] as int,
    termUnit: json['termUnit'] as String,
    termStatus: json['termStatus'] as int,
    termValue: json['termValue'],
    termDisplayName: json['termDisplayName'] as String,
    termContent: json['termContent'] as String,
  );
}

Map<String, dynamic> _$TermMessageModelToJson(TermMessageModel instance) =>
    <String, dynamic>{
      'termId': instance.termId,
      'termStatus': instance.termStatus,
      'termUnit': instance.termUnit,
      'termValue': instance.termValue,
      'termDisplayName': instance.termDisplayName,
      'termContent': instance.termContent,
    };

MessageFileModel _$MessageFileModelFromJson(Map<String, dynamic> json) {
  return MessageFileModel(
    url: json['url'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$MessageFileModelToJson(MessageFileModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
    };

MessageUserModel _$MessageUserModelFromJson(Map<String, dynamic> json) {
  return MessageUserModel(
    userId: json['userId'] as int,
    userAvatar: json['userAvatar'] as String,
    userName: json['userName'] as String,
    fullName: json['fullName'] as String,
  );
}

Map<String, dynamic> _$MessageUserModelToJson(MessageUserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userAvatar': instance.userAvatar,
      'userName': instance.userName,
      'fullName': instance.fullName,
    };
