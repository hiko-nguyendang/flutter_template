part of 'enums.dart';

abstract class ScoreTypeEnum {
  static const int Quality = 1;
  static const int TimelyDelivery = 2;
  static const int Cooperation = 3;
  static const int Documentation = 4;
  static const int OverallPerformance = 5;

  static String getName(int value) {
    switch (value) {
      case Quality:
        return LocaleKeys.Quality_SoreType.tr;
      case TimelyDelivery:
        return LocaleKeys.TimeDelivery_SoreType.tr;
      case Cooperation:
        return LocaleKeys.Cooperation_SoreType.tr;
      case Documentation:
        return LocaleKeys.Documentation_SoreType.tr;
      case OverallPerformance:
        return LocaleKeys.OverallPerformance_SoreType.tr;
      default:
        return '';
    }
  }
}
