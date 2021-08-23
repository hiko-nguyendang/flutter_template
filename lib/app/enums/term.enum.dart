part of 'enums.dart';

abstract class TermInputTypeEnum {
  static const int Number = 1;
  static const int Text = 2;
  static const int DropDown = 3;
  static const int DateTime = 4;
  static const int NumberWithOptionUnit = 5;
  static const int Range = 6;
}

abstract class TermStatusEnum {
  static const int None = 1000;
  static const int InProgress = 1001;
  static const int Declined = 1003;
  static const int Accepted = 1002;
  static const int Skipped = 1004;
}

abstract class TermNameEnum {
  static const TenantType = 'TenantType';
  static const QuantityUnitType = 'QuantityUnitType';
  static const CertificationType = 'CertificationType';
  static const ServiceType = 'ServiceType';
  static const FileUploadType = 'FileUploadType';
  static const OfferType = 'OfferType';
  static const OfferStatus = 'OfferStatus';
  static const ContractType = 'ContractType';
  static const ContractStatus = 'ContractStatus';
  static const CropYearType = 'CropYearType';
  static const AudienceType = 'AudienceType';
  static const PriceUnitType = 'PriceUnitType';
  static const ContractTerm = 'ContractTerm';
  static const CommodityType = 'CommodityType';
  static const DeliveryTerm = 'DeliveryTerm';
  static const PackingUnitType = 'PackingUnitType';
  static const GradeType = 'GradeType';
  static const CoffeeType = 'CoffeeType';
}

abstract class TermTypeIdEnum {
  static const ContractType = 1;
  static const Commodities = 2;
  static const CoffeeType = 3;
  static const Grade = 4;
  static const Quantity = 5;
  static const QuantityUnit = 6;
  static const Packing = 7;
  static const PackingUnit = 8;
  static const DeliveryDate = 9;
  static const Price = 10;
  static const PriceUnit = 11;
  static const CoverMonth = 12;
  static const DeliveryTerms = 13;
  static const Certification = 14;
  static const ExchangeDate = 15;
  static const MarketPrice = 16;
  static const SecurityMargin = 17;
  static const SpecialClause = 18;
  static const CropYear = 19;
  static const CurrencyRate = 20;

  static String getName(int value) {
    switch (value) {
      case ContractType:
        return LocaleKeys.TermName_Contract.tr;
      case Commodities:
        return LocaleKeys.TermName_Commodity.tr;
      case CoffeeType:
        return LocaleKeys.TermName_Type.tr;
      case Grade:
        return LocaleKeys.TermName_Grade.tr;
      case Quantity:
        return LocaleKeys.TermName_Quantity.tr;
      case Price:
        return LocaleKeys.TermName_Price.tr;
      case DeliveryDate:
        return LocaleKeys.TermName_DeliveryDate.tr;
      case CoverMonth:
        return LocaleKeys.TermName_CoverMonth.tr;
      case DeliveryTerms:
        return LocaleKeys.TermName_DeliveryTerm.tr;
      case SpecialClause:
        return LocaleKeys.TermName_SpecialClause.tr;
      case SecurityMargin:
        return LocaleKeys.TermName_SecurityMargin.tr;
      case Certification:
        return LocaleKeys.CreateContract_Certification.tr;
      case MarketPrice:
        return LocaleKeys.TermName_MarketPrice.tr;
      case ExchangeDate:
        return LocaleKeys.TermName_ExchangeDate.tr;
      case Packing:
        return LocaleKeys.OtherServices_Packaging_Packing.tr;
      case CropYear:
        return LocaleKeys.TermName_CropYear.tr;
      case CurrencyRate:
        return LocaleKeys.TermName_CurrencyRate.tr;
      default:
        return "";
    }
  }
}
