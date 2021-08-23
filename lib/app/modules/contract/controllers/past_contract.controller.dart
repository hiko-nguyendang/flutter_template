import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_price.widget.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_volume.widget.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_performance.widget.dart';

class PastContractController extends GetxController
    with SingleGetTickerProviderMixin {
  final ContractRepository repository;

  PastContractController({@required this.repository})
      : assert(repository != null);

  static PastContractController to = Get.find();
  TabController tabController;
  RxInt currentTab = PastContractTabEnum.Volume.obs;
  List<SupplierModel> suppliers = List<SupplierModel>();
  RxBool isLoading = false.obs;

  List<int> pastContractTabs = [
    PastContractTabEnum.Volume,
    PastContractTabEnum.Price,
    PastContractTabEnum.Performance
  ];

  List<Widget> pastContractPages = [
    PastContractsVolume(),
    PastContractsPrice(),
    PastContractsPerformance(),
  ];

  @override
  void onInit() {
    _initTabController();
    if (AuthController.to.currentUser.isBuyer) {
      _getSuppliers();
    }
    super.onInit();
  }

  void _initTabController() {
    tabController = TabController(
      vsync: this,
      length: pastContractTabs.length,
    );
  }

  Future<void> _getSuppliers() async {
    isLoading.value = true;
    await repository.getSuppliers().then(
      (value) {
        isLoading.value = false;
        suppliers.addAll(value);
      },
    );
    update();
  }
}
