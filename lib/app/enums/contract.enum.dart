part of 'enums.dart';

abstract class ContractTypeEnum {
  static const int Outright = 1;
  static const int OnCall = 2;
  static const int Deposit = 3;

  static String getName(int value) {
    switch (value) {
      case OnCall:
        return LocaleKeys.ContractType_OnCall.tr;
        break;
      case Outright:
        return LocaleKeys.ContractType_Outright.tr;
        break;
      case Deposit:
        return LocaleKeys.ContractType_Deposit.tr;
        break;
      default:
        return '';
    }
  }

  static String getType(int value) {
    switch (value) {
      case OnCall:
        return 'OC';
        break;
      case Outright:
        return 'O';
        break;
      case Deposit:
        return 'D';
        break;
      default:
        return '';
    }
  }

  static List<int> listContractTypes = [OnCall, Outright, Deposit];
}

class ContractStatusEnum {
  static const int InProgress = 1;
  static const int Completed = 2;

  static String getName(int value) {
    switch (value) {
      case InProgress:
        return LocaleKeys.Contract_InProgress.tr;
        break;
      case Completed:
        return LocaleKeys.Contract_Completed.tr;
        break;
      default:
        return "abc";
        break;
    }
  }

  static String getStatusString(int value) {
    switch (value) {
      case InProgress:
        return LocaleKeys.Notifications_Contract_Waiting.tr;
      case Completed:
        return LocaleKeys.Notifications_Contract_Completed.tr;
      default:
        return '';
    }
  }
}

abstract class PastContractTabEnum {
  static const int Volume = 0;
  static const int Price = 1;
  static const int Performance = 2;

  static String getName(int value) {
    switch (value) {
      case Volume:
        return LocaleKeys.PastContract_VolumeTab.tr;
      case Price:
        return LocaleKeys.PastContract_PriceTab.tr;
      case Performance:
        return LocaleKeys.PastContract_PerformanceTab.tr;
      default:
        return '';
    }
  }
}

abstract class TimeFrameEnum {
  static const int Year = 1;
  static const int Quarter = 2;
  static const int Month = 3;

  static String getName(int value) {
    switch (value) {
      case Year:
        return LocaleKeys.TimeFrame_Year.tr;
        break;
      case Quarter:
        return LocaleKeys.TimeFrame_Quarter.tr;
      case Month:
        return LocaleKeys.TimeFrame_Month.tr;
        break;
      default:
        return '';
    }
  }
}

abstract class CriteriaEnum {
  static const int Overall = 1;
  static const int Quality = 2;
  static const int TimeDelivery = 3;
  static const int Cooperation = 4;
  static const int Documentation = 5;
}
