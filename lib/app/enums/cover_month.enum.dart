part of 'enums.dart';

abstract class CoverMonthEnum {
  static const String F = "F";
  static const String H = "H";
  static const String K = "K";
  static const String N = "N";
  static const String U = "U";
  static const String X = "X";
  static const String Z = "Z";

  static String getCode(int value) {
    switch (value) {
      case 1:
        return 'F';
      case 3:
        return 'H';
      case 5:
        return 'K';
      case 7:
        return 'N';
      case 9:
        return 'U';
      case 11:
        return 'X';
      case 12:
        return 'Z';
      default:
        return '';
    }
  }

  static List<String> coverMonthCodes = [F, H, K, N, U, X, Z];
}
