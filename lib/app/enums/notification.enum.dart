part of 'enums.dart';

abstract class NotificationType {
  static const int FromAdmin = 1;
  static const int FromUser = 2;
}

class FirebaseNotificationType {
  static const String SimpleChat = "SimpleChat";
  static const String TermChat = "TermChat";
  static const String ConfirmTerm = "ConfirmTerm";
  static const String FinalizePending = "FinalizePending";
  static const String System = "System";
}

class EventTypeEnum {
  static const int CreateContract = 1500;
  static const int CreateRequest = 1501;
  static const int CreateOffer = 1502;
  static const int UpdateRequest = 1503;
  static const int UpdateOffer = 1504;
  static const int AcceptRequest = 1505;
  static const int CreateNegotiation = 1506;
  static const int PendingFinalize = 1507;
  static const int Finalized = 1508;
  static const int PostMarketPulse = 1509;
  static const int Delivery = 1510;
}
