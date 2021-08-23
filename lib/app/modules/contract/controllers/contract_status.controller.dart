import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';

class ContractStatusController extends GetxController {
  final ContractRepository repository;

  ContractStatusController({@required this.repository})
      : assert(repository != null);

  static ContractStatusController to = Get.find();
  RxList<ContractStatusModel> contractsStatus = RxList<ContractStatusModel>();
  RefreshController refreshController = RefreshController();
  RxBool isLoading = false.obs;
  int tenantId;

  @override
  void onInit() {
    tenantId = Get.arguments;
    if (tenantId != null) {
      getContractsStatus(tenantId);
    }
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Future getContractsStatus(int tenantId, {bool isReload = true}) async {
    if (isReload) {
      isLoading.value = true;
      if (contractsStatus.isNotEmpty) {
        contractsStatus.clear();
      }
    }
    try {
      await repository.getContractStatus(tenantId).then((response) {
        contractsStatus.addAll(response);
        refreshController.loadComplete();
        isLoading.value = false;
      });
    } catch (e) {
      MessageDialog.showError(message: LocaleKeys.Shared_ErrorMessage.tr);
      isLoading.value = false;
      throw e;
    }
    update();
  }
}
