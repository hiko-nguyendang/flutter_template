import 'package:get/get.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';

class TermName {
  static String gradeName(int gradeTypeId) {
    if (gradeTypeId == null || LookUpController.to.grades == null) {
      return '';
    } else {
      final gradeList = LookUpController.to.grades.values;
      return gradeList.firstWhere((_) => _.id == gradeTypeId).termOptionName;
    }
  }

  static String deliveryTermName(int deliveryTermId) {
    if (deliveryTermId == null) {
      return '';
    } else {
      final deliveryList = LookUpController.to.deliveryTerms.values;
      return deliveryList
          .firstWhere((_) => _.id == deliveryTermId)
          .termOptionName;
    }
  }

  static String certificationName(int certificationId) {
    if (certificationId == null) {
      return '';
    }
    final certifications = LookUpController.to.certifications.values;
    return certifications
        .firstWhere((_) => _.id == certificationId)
        .termOptionName;
  }

  static String deliveryWarehouse(int deliveryWarehouseId) {
    if (deliveryWarehouseId == null || deliveryWarehouseId == 0) {
      return '';
    } else {
      final locationList = LookUpController.to.locations;
      return locationList.firstWhere((_) => _.id == deliveryWarehouseId).name;
    }
  }

  static String deliveryTermCode(int deliveryTermId) {
    if (deliveryTermId == null) {
      return '';
    } else {
      final deliveryTerms = LookUpController.to.deliveryTerms.values;
      return deliveryTerms
          .firstWhere((_) => _.id == deliveryTermId)
          .termOptionName;
    }
  }

  static String packingUnitName(int packingUnitTypeId) {
    if (packingUnitTypeId == null) {
      return '';
    } else {
      final packingUnits = LookUpController.to.packingUnitCodes.values;
      return packingUnits.firstWhere((_) => _.id == packingUnitTypeId).termOptionName;
    }
  }

  static String priceUnitName(int priceUnitTypeId) {
    if (priceUnitTypeId == null || priceUnitTypeId == 0) {
      return '';
    } else {
      final priceUnits = LookUpController.to.priceUnits.values;
      return priceUnits
          .firstWhere((_) => _.id == priceUnitTypeId)
          .termOptionName;
    }
  }

  static String coffeeTypeName(int coffeeTypeId) {
    if (coffeeTypeId == null) {
      return '';
    } else {
      final coffeeTypes = LookUpController.to.coffeeTypes.values;
      return coffeeTypes.firstWhere((_) => _.id == coffeeTypeId).termOptionName;
    }
  }

  static String commodityName(int commodityId) {
    if (commodityId == null || commodityId == 0) {
      return '';
    } else {
      final commodities = LookUpController.to.commodities.values;
      return commodities.firstWhere((_) => _.id == commodityId).termOptionName;
    }
  }

  static String contractTypeName(int contractTypeId) {
    if (contractTypeId == null) {
      return '';
    } else {
      final contractTypes = LookUpController.to.contractTypes.values;
      return contractTypes
          .firstWhere((_) => _.id == contractTypeId)
          .termOptionName;
    }
  }

  static String quantityUnitName(int quantityUnitTypeId) {
    if (quantityUnitTypeId == null) {
      return '';
    } else {
      final quantityUnits = LookUpController.to.quantityUnits.values;
      return quantityUnits
          .firstWhere((_) => _.id == quantityUnitTypeId)
          .termOptionName;
    }
  }

  static String audienceTypeName(int audienceTypeId) {
    if (audienceTypeId == null) {
      return '';
    } else {
      return AudienceEnum.getName(audienceTypeId);
    }
  }

  static String coverMonthName(int coverMonthId) {
    if (coverMonthId == null) {
      return '';
    } else {
      final coverMonthList = LookUpController.to.coverMonths;
      return coverMonthList.firstWhere((_) => _.id == coverMonthId).name;
    }
  }

  static String coverMonthListName(List<int> coverMonths) {
    if (coverMonths.isEmpty) {
      return LocaleKeys.Shared_CoverMonth.tr;
    } else {
      final selected = LookUpController.to.coverMonths.where(
        (_) => coverMonths.contains(_.id),
      );
      return selected.map((_) => _.name).join(', ');
    }
  }

  static String commodityListName(List<int> commodities) {
    if (commodities.isEmpty) {
      return LocaleKeys.Shared_Commodity.tr;
    } else {
      final selected = LookUpController.to.commodities.values.where(
            (_) => commodities.contains(_.id),
      );
      return selected.map((_) => _.name).join(', ');
    }
  }

  static String contractListName(List<int> contractTypes) {
    if (contractTypes.isEmpty) {
      return LocaleKeys.Shared_TypeOfContract.tr;
    } else {
      final selected = LookUpController.to.contractTypes.values.where(
            (_) => contractTypes.contains(_.id),
      );
      return selected.map((_) => _.name).join(', ');
    }
  }
}
