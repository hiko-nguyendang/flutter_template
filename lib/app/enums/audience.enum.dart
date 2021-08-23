part of 'enums.dart';

abstract class AudienceEnum {
  static const int Public = 801;
  static const int NonPublic = 800;

  static String getName(int value) {
    switch (value) {
      case Public:
        return LocaleKeys.Shared_Public.tr;
      case NonPublic:
        return LocaleKeys.Shared_NonPublic.tr;
      default:
        return '';
    }
  }

  static List<int> listAudiences = [Public, NonPublic];
}
