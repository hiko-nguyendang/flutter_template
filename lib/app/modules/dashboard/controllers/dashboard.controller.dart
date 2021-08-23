import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';

class DashboardController extends GetxController {
  DashboardRepository repository;

  DashboardController({@required this.repository}) : assert(repository != null);

  RefreshController refreshController = RefreshController();
  Rx<DashboardModel> dashboardData = DashboardModel().obs;

  RxBool isLoading = false.obs;

  RxBool isSubmittingPulse = false.obs;

  BuyerDashboardModel get buyerDashboard =>
      dashboardData.value.buyerDashboardInfo;

  SupplierDashboardModel get supplierDashboard =>
      dashboardData.value.supplierDashboardInfo;

  @override
  void onInit() {
    getDashboardData();
    super.onInit();
  }

  Future<void> getDashboardData() async {
    isLoading.value = true;
    try {
      repository.getDashboardData().then(
        (response) {
          isLoading.value = false;
          if (response.body != null) {
            final result = DashboardModel.fromJson(response.body);
            dashboardData.value = result;
          }
          refreshController.refreshCompleted();
        },
      );
    } catch (e) {
      isLoading.value = false;
      throw e;
    }
  }
}
