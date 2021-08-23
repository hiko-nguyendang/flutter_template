part of 'enums.dart';

abstract class NegotiationStatusType {
  static const int PreValidated = 1100;
  static const int InProgress = 1101;
  static const int AllTermAccepted = 1102;
  static const int FinalizePending = 1103;
  static const int Finalized = 1104;

  static String getName(int value) {
    switch (value) {
      case InProgress:
        return LocaleKeys.Contract_InProgress.tr;
        break;
      case PreValidated:
        return LocaleKeys.Contract_PreValidated.tr;
        break;
      case AllTermAccepted:
        return LocaleKeys.Contract_AllTermAccepted.tr;
        break;
      case FinalizePending:
        return LocaleKeys.Contract_FinalizePending.tr;
        break;
      case Finalized:
        return LocaleKeys.Contract_Finalized.tr;
        break;
      default:
        return "";
        break;
    }
  }
}

abstract class NegotiationTypeEnum{
  static const int OfferNegotiation = 1700;
  static const int RequestNegotiation = 1701;
}

abstract class ConversationStatusEnum{
  static const int Open = 2800;
  static const int Close = 2801;
  static const int Finalized = 2802;
}
