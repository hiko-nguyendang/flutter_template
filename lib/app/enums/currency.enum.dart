part of 'enums.dart';

abstract class CurrencyCodeEnum {
  static const AUD = 'AUD';
  static const CAD = 'CAD';
  static const CHF = 'CHF';
  static const CNY = 'CNY';
  static const DKK = 'DKK';
  static const EUR = 'EUR';
  static const GBP = 'GBP';
  static const HKD = 'HKD';
  static const INR = 'INR';
  static const JPY = 'JPY';
  static const KRW = 'KRW';
  static const KWD = 'KWD';
  static const MYR = 'MYR';
  static const NOK = 'NOK';
  static const RUB = 'RUB';
  static const SAR = 'SAR';
  static const SEK = 'SEK';
  static const SGD = 'SGD';
  static const THB = 'THB';
  static const USD = 'USD';

  static List<String> currenciesCode = [
    AUD,
    CAD,
    CHF,
    CNY,
    DKK,
    EUR,
    GBP,
    HKD,
    INR,
    JPY,
    KRW,
    KWD,
    MYR,
    NOK,
    RUB,
    SAR,
    SEK,
    SGD,
    THB,
    USD,
  ];

  static String getCountryCode(String value) {
    switch (value) {
      case AUD:
        return 'AU';
      case CAD:
        return 'CA';
      case CHF:
        return 'CH';
      case CNY:
        return 'CN';
      case DKK:
        return 'DK';
      case EUR:
        return 'EU';
      case GBP:
        return 'GB';
      case HKD:
        return 'HK';
      case INR:
        return 'IN';
      case JPY:
        return 'JP';
      case KRW:
        return 'KR';
      case KWD:
        return 'KW';
      case MYR:
        return 'MY';
      case NOK:
        return 'NO';
      case RUB:
        return 'RU';
      case SAR:
        return 'SA';
      case SEK:
        return 'SE';
      case SGD:
        return 'SG';
      case THB:
        return 'TH';
      case USD:
        return 'US';
      default:
        return '';
    }
  }
}
