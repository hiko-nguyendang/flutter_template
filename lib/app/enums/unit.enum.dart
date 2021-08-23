part of 'enums.dart';

abstract class QuantityUnitEnum {
  static const int MT = 1;
  static const int KG = 2;

  static String getName(int value) {
    switch (value) {
      case MT:
        return LocaleKeys.Unit_MT.tr;
      case KG:
        return LocaleKeys.Unit_KG.tr;
      default:
        return '';
    }
  }

  static List<int> quantityUnits = [
    MT,
    KG,
  ];
}
