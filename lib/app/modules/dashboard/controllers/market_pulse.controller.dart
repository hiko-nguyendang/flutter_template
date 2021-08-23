import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';

class MarketPulseController extends GetxController {
  final DashboardRepository repository;

  MarketPulseController({@required this.repository})
      : assert(repository != null);

  TextEditingController marketPulseInputController =
      new TextEditingController();
  Rx<MarketPulseModel> latestMarketPulse = Rx<MarketPulseModel>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    if (AuthController.to.currentUser.isSupplier) {
      _getLatestMarketPulse();
    }
    super.onInit();
  }

  Future<void> _getLatestMarketPulse() async {
    isLoading.value = true;
    try {
      await repository.getLatestMarketPulse().then((response) {
        isLoading.value = false;
        if (response.body != null) {
          latestMarketPulse.value = MarketPulseModel.fromJson(response.body);
        }
        update();
      });
    } catch (e) {
      isLoading.value = false;
      update();
      throw e;
    }
  }

  Future<void> postMarketPulse() async {
    try {
      MessageDialog.showLoading();
      await repository
          .postMarketPulse(marketPulseInputController.value.text.trim())
          .then(
        (response) {
          marketPulseInputController.clear();

          MessageDialog.hideLoading();
          if (response.statusCode == APIStatus.Successfully) {
            Get.toNamed(Routes.BUYER_MARKET_PULSE);
          }
        },
      );
    } catch (e) {
      marketPulseInputController.clear();
      MessageDialog.hideLoading();
      throw e;
    }
  }
}
