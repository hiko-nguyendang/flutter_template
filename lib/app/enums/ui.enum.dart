part of 'enums.dart';

abstract class BottomMenuEnum {
  static const int HomeTab = 0;
  static const int ChatTab = 1;
  static const int NotificationTab = 2;

  static String getName(int value) {
    switch (value) {
      case HomeTab:
        return LocaleKeys.BottomBar_HomeButton.tr;
        break;
      case ChatTab:
        return LocaleKeys.BottomBar_MessageButton.tr;
        break;
      case NotificationTab:
        return LocaleKeys.BottomBar_AlertButton.tr;
        break;
      default:
        return '';
    }
  }
}

abstract class BuyerOfferTabEnum {
  static const int OfferToday = 0;
  static const int AllMyRequest = 1;
  static const int Saved = 2;

  static String getName(int value) {
    switch (value) {
      case AllMyRequest:
        return LocaleKeys.BuyerOffer_AllMyRequestTab.tr;
      case OfferToday:
        return LocaleKeys.BuyerOffer_OffersTodayTab.tr;
      case Saved:
        return LocaleKeys.BuyerOffer_SavedTab.tr;
      default:
        return '';
    }
  }
}

abstract class SupplierOfferTabEnum {
  static const int AllMyOffer = 0;
  static const int PublicOffer = 1;
  static const int RequestsToday = 2;

  static String getName(int value) {
    switch (value) {
      case AllMyOffer:
        return LocaleKeys.SupplierOffer_AllMyOfferTab.tr;
      case PublicOffer:
        return LocaleKeys.SupplierOffer_PublicOffersTab.tr;
      case RequestsToday:
        return LocaleKeys.SupplierOffer_RequestsTodayTab.tr;
      default:
        return '';
    }
  }
}

abstract class OpenContractTabEnum {
  static const int ContractDetail = 0;
  static const int OtherTerms = 1;
  static const int FixationDetails = 2;

  static String getName(int value) {
    switch (value) {
      case ContractDetail:
        return LocaleKeys.OpenContract_ContractDetails.tr;
      case OtherTerms:
        return LocaleKeys.OpenContract_OtherTerms.tr;
      case FixationDetails:
        return LocaleKeys.OpenContract_FixationDetails.tr;
      default:
        return '';
    }
  }
}

abstract class QuantityEnum {
  static const double QuantityMin = 0;
  static const double QuantityMax = 100000;
}

abstract class MarketPriceEnum {
  static const double ArabicaMaxOI = 400000;
  static const double ArabicaMaxVolume = 200000;
  static const double RobustaMaxOI = 200000;
  static const double RobustaMaxVolume = 100000;
}

abstract class ContactTypeEnum {
  static const int Supplier = 1;
  static const int OtherService = 2;
}
