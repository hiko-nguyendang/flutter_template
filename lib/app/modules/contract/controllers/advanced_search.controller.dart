import 'package:get/get.dart';

import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';

class OpenContractAdvancedSearchController extends GetxController {
  final lookUpController = LookUpController.to;

  Rx<OpenContractAdvanceSearchModel> _openContractAdvanceSearchModel =
      OpenContractAdvanceSearchModel().obs;

  OpenContractAdvanceSearchModel get openContractAdvanceSearchModel =>
      _openContractAdvanceSearchModel.value;


  @override
  void onInit() {
    _openContractAdvanceSearchModel.value = Get.arguments;
    update();
    super.onInit();
  }

  void onTypeChanged(bool value, int type) {
    if (value) {
      openContractAdvanceSearchModel.coffeeTypeIds.add(type);
    } else {
      openContractAdvanceSearchModel.coffeeTypeIds.remove(type);
    }
    update();
  }

  void onCommodityChanged(bool value, int commodityType) {
    if (value) {
      openContractAdvanceSearchModel.commodityTypeIds.add(commodityType);
    } else {
      openContractAdvanceSearchModel.commodityTypeIds.remove(commodityType);
    }
    update();
  }

  void onCoverMonthChanged(bool value, int coverMonthId) {
    if (value) {
      openContractAdvanceSearchModel.coverMonths.add(coverMonthId);
    } else {
      openContractAdvanceSearchModel.coverMonths.remove(coverMonthId);
    }
    update();
  }

  void onDestinationChanged(bool value, int locationId) {
    if (value) {
      openContractAdvanceSearchModel.deliveryWarehouseIds.add(locationId);
    } else {
      openContractAdvanceSearchModel.deliveryWarehouseIds.remove(locationId);
    }
    update();
  }

  void onGradeChanged(int grade) {
    openContractAdvanceSearchModel.gradeTypeId = grade;
    update();
  }

  void clearFilter() {
    openContractAdvanceSearchModel.gradeTypeId = null;
    openContractAdvanceSearchModel.deliveryWarehouseIds = [];
    openContractAdvanceSearchModel.commodityTypeIds = [];
    openContractAdvanceSearchModel.coverMonths = [];
    openContractAdvanceSearchModel.coffeeTypeIds = [];
    update();
  }

}
