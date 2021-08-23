import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';

class MarketPulseListController extends GetxController {
  final DashboardRepository repository;

  MarketPulseListController({@required this.repository})
      : assert(repository != null);

  static MarketPulseListController to = Get.find();

  RefreshController refreshController = RefreshController();
  RxList<MarketPulseModel> marketPulses = RxList<MarketPulseModel>();
  Rx<PaginationParam> _param = PaginationParam(pageSize: 10, pageNumber: 1).obs;
  RxBool isLoading = false.obs;
  int _totalCount = 0;
  bool get hasMore => _totalCount > marketPulses.length;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
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
            MarketPulseResult result =
                MarketPulseResult.fromJson(response.body);
            marketPulses.addAll(result.objects);
            _totalCount = result.totalCount;
            _param.value.pageNumber += 1;
            refreshController.loadComplete();
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
    }
    update();
  }

  Future<void> deleteMarketPulse(int id) async {
    try {
      MessageDialog.showLoading();
      await repository.deleteMarketPulse(id).then((response) {
        MessageDialog.hideLoading();
        if (response.body != null) {
          final result = response.body;
          if (result) {
            final int itemIndex = marketPulses
                .indexOf(marketPulses.firstWhere((_) => _.id == id));
            marketPulses.removeAt(itemIndex);
            update();
          }
        }
      });
    } catch (e) {
      MessageDialog.hideLoading();
      throw e;
    }
  }

  void deleteItem(int id) {
    MessageDialog.confirm(
      LocaleKeys.MarketPulse_DeleteConfirmMessage.tr,
      confirmButtonText: LocaleKeys.Shared_Delete.tr,
      confirmButtonColor: kDangerColor,
      cancelButtonText: LocaleKeys.Shared_Cancel.tr,
      onConfirmed: () async {
        deleteMarketPulse(id);
      },
    );
  }
}
