part of 'enums.dart';

abstract class UserRoleEnum {

  static const int Buyer = 1;
  static const int Supplier = 2;
  static const int OtherService = 3;
  static const int Admin = 4;

  static String getName(int value){
    switch (value){
      case Buyer:
        return "Buyer";
      case Supplier:
        return "Supplier";
      default:
        return '';
    }
  }
}