import 'package:dash_chat/dash_chat.dart';

class ChatArgument {
  String conversationId;
  String conversationName;
  int contactId;
  int offerId;
  int conversationTypeId;
  int requestId;
  int sendTo;
  bool isFromConversation;

  ChatArgument(
      {this.contactId,
      this.conversationId,
      this.conversationName,
      this.requestId,
      this.conversationTypeId,
      this.offerId,
      this.sendTo,
      this.isFromConversation});
}

class ContractArgument {
  String contractNumber;
  String pdfUrl;
  String title;

  ContractArgument({
    this.contractNumber,
    this.pdfUrl,
    this.title,
  });
}

class ContactArgument {
  int contactId;

  ContactArgument({this.contactId});
}

class MarketPulseArgument {
  int marketPulseId;

  MarketPulseArgument({this.marketPulseId});
}

class OfferArgument {
  int offerId;

  OfferArgument({this.offerId});
}

class ContractOverviewArgument {
  ChatUser chatUser;
  String conversationId;
  int sendToUserId;
  bool isReview;

  ContractOverviewArgument({
    this.chatUser,
    this.conversationId,
    this.sendToUserId,
    this.isReview,
  });
}

class FinalizeArgument {
  String conversationId;
  bool isView;

  FinalizeArgument({this.conversationId, this.isView});
}
