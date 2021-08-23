part of 'enums.dart';

abstract class MonthEnum {
  static const int Jan = 1;
  static const int Feb = 2;
  static const int Mar = 3;
  static const int Apr = 4;
  static const int May = 5;
  static const int Jun = 6;
  static const int Jul = 7;
  static const int Aug = 8;
  static const int Sep = 9;
  static const int Oct = 10;
  static const int Nov = 11;
  static const int Dec = 12;

  static String getName(int val) {
    switch (val) {
      case Jan:
        return 'Jan';
      case Feb:
        return 'Feb';
      case Mar:
        return 'Mar';
      case Apr:
        return 'Apr';
      case May:
        return 'May';
      case Jun:
        return 'Jun';
      case Jul:
        return 'Jul';
      case Aug:
        return 'Aug';
      case Sep:
        return 'Sep';
      case Oct:
        return 'Oct';
      case Nov:
        return 'Nov';
      case Dec:
        return 'Dec';
      default:
        return '';
    }
  }

  static List<int> buildMonths() {
    return [Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec];
  }
}
