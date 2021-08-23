part of 'enums.dart';

abstract class OtherServicesTabEnum {
  static const int AllOfferTab = 0;
  static const int TruckingTab = 1;
  static const int MachineriesTab = 2;
  static const int PackingTab = 3;
  static const int OtherTab = 4;
  static const int SavedTab = 5;

  static String getName(int value) {
    switch (value) {
      case AllOfferTab:
        return LocaleKeys.OtherServices_AllOfferTab.tr;
      case TruckingTab:
        return LocaleKeys.OtherServices_TruckingTab.tr;
      case MachineriesTab:
        return LocaleKeys.OtherServices_MachineriesTab.tr;
      case PackingTab:
        return LocaleKeys.OtherServices_PackingTab.tr;
      case OtherTab:
        return LocaleKeys.OtherServices_OtherTab.tr;
      case SavedTab:
        return LocaleKeys.OtherServices_SavedTab.tr;
      default:
        return '';
    }
  }

  static List<int> otherServicesTabs = [
    AllOfferTab,
    TruckingTab,
    MachineriesTab,
    PackingTab,
    OtherTab,
    SavedTab
  ];
}

abstract class OtherServiceStatusEnum {
  static const int New = 2200;
  static const int Used = 2201;

  static String getName(int value) {
    switch (value) {
      case New:
        return LocaleKeys.MachineStatus_New.tr;
      case Used:
        return LocaleKeys.MachineStatus_Used.tr;
      default:
        return '';
    }
  }
}

abstract class MachineryStatusEnum {
  static const int New = 1600;
  static const int Used = 1601;

  static String getName(int value) {
    switch (value) {
      case New:
        return LocaleKeys.MachineStatus_New.tr;
      case Used:
        return LocaleKeys.MachineStatus_Used.tr;
      default:
        return '';
    }
  }
}

abstract class MeasuringUnitEnum {
  static const int CM = 2300;

  static String getName(int value) {
    switch (value) {
      case CM:
        return LocaleKeys.MeasuringUnit_CM.tr;
      default:
        return '';
    }
  }
}

abstract class TreatmentEnum {
  static const int VOT = 1;

  static String getName(int value) {
    switch (value) {
      case VOT:
        return LocaleKeys.Treatment_VOT.tr;
      default:
        return '';
    }
  }
}

abstract class JustBagTypeEnum{
  static const int VOTJustBag = 2100;

  static String getName(int value){
    switch (value){
      case VOTJustBag:
        return LocaleKeys.JustBagType_VOT.tr;
      default:
        return '';
    }
  }
}

abstract class BagTypeEnum {
  static const int BTwill = 2400;

  static String getName(int value) {
    switch (value) {
      case BTwill:
        return LocaleKeys.BagType_BTwill.tr;
      default:
        return '';
    }
  }
}
abstract class OtherServicePackingUnitEnum{
  static const int Bag = 2000;

  static String getName(int value) {
    switch (value) {
      case Bag:
        return LocaleKeys.OtherServices_Bag.tr;
      default:
        return '';
    }
  }
}

abstract class OtherServiceTypeEnum {
  static const int Trucking = 200;
  static const int Machinery = 201;
  static const int Packing = 202;
  static const int Other = 203;
}

abstract class TruckingPriceUnitType{
  static const int VNDKG = 2600;
  static const int VNTRIP = 2601;

  static String getName(int value){
    if(value == 0){
      return "";
    }
    return 'OtherServices_TruckingPrice_$value'.tr;
  }
}