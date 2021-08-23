import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';

class MarketPulseDetailController extends GetxController {
  final DashboardRepository repository;

  MarketPulseDetailController({@required this.repository})
      : assert(repository != null);

  Rx<MarketPulseModel> marketPulse = Rx<MarketPulseModel>();

  @override
  void onInit() {
    marketPulse.value = Get.arguments;
    super.onInit();
  }

  Future<void> updateMarketPulse() async {
    MessageDialog.showLoading();
    try {
      await repository.updateMarketPulseDetail(marketPulse.value).then(
        (response) {
          MessageDialog.hideLoading();
          if (response.body != null) {
            Get.offNamed(Routes.BUYER_MARKET_PULSE);
          }
        },
      );
    } catch (e) {
      MessageDialog.hideLoading();
      MessageDialog.showMessage(LocaleKeys.Shared_ErrorMessage.tr);
      throw e;
    }
  }
}
