import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';

class SupplierMarketPulseListController extends GetxController {
  final DashboardRepository repository;

  SupplierMarketPulseListController({@required this.repository})
      : assert(repository != null);

  static SupplierMarketPulseListController to = Get.find();

  RefreshController refreshController = RefreshController();
  RxList<MarketPulseModel> marketPulses = RxList<MarketPulseModel>();
  Rx<PaginationParam> _param = PaginationParam(pageSize: 10, pageNumber: 1).obs;
  RxBool isLoading = false.obs;
  int _totalCount = 0;
  bool get hasMore => _totalCount > marketPulses.length;

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData({bool isReload = true}) async {
    if (isReload) {
      isLoading.value = true;
      _param.value.pageNumber = 1;
      marketPulses.clear();
    }
    try {
      await repository.getAllMarketPulse(_param.value).then(
        (response) {
          isLoading.value = false;
          if (response.body != null) {
            MarketPulseResult result = MarketPulseResult.fromJson(response.body);
            marketPulses.addAll(result.objects);
            _totalCount = result.totalCount;
            _param.value.pageNumber += 1;
            refreshController.loadComplete();
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      throw e;
    }
    update();
  }
}
