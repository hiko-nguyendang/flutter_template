import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/modules/other_service/views/other.view.dart';
import 'package:agree_n/app/modules/other_service/views/packaging.view.dart';
import 'package:agree_n/app/modules/other_service/views/trucking.view.dart';
import 'package:agree_n/app/modules/other_service/views/saved.view.dart';
import 'package:agree_n/app/modules/other_service/views/all_offers.view.dart';
import 'package:agree_n/app/modules/other_service/views/machineries.view.dart';
import 'package:agree_n/app/modules/other_service/controllers/other.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/packaging.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/trucking.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/saved.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/all_offer.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/machineries.controller.dart';


class OtherServiceController extends GetxController
    with SingleGetTickerProviderMixin {
  TabController tabController;
  List<int> tabs = OtherServicesTabEnum.otherServicesTabs;
  List<Widget> pages = [
    OtherServiceAllOfferView(),
    OtherServiceTruckingView(),
    OtherServiceMachineriesView(),
    OtherServicePackagingView(),
    OtherServiceOtherView(),
    OtherServiceSavedView(),
  ];

  @override
  void onInit() {
    tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: Get.arguments,
    );
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onTabChanged(int index) {
    switch (index) {
      case OtherServicesTabEnum.AllOfferTab:
        AllOfferController.to.getData();
        break;
      case OtherServicesTabEnum.TruckingTab:
        TruckingController.to.getData();
        break;
      case OtherServicesTabEnum.MachineriesTab:
        MachineriesController.to.getData();
        break;
      case OtherServicesTabEnum.PackingTab:
        PackagingController.to.getData();
        break;
      case OtherServicesTabEnum.OtherTab:
        OtherController.to.getData();
        break;
      case OtherServicesTabEnum.SavedTab:
        SavedController.to.getData();
        break;
    }
  }
}
