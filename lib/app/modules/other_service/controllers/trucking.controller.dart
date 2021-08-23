import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/other_service.model.dart';
import 'package:agree_n/app/data/repositories/other_service.repository.dart';

class TruckingController extends GetxController {
  final OtherServiceRepository repository;

  TruckingController({@required this.repository}) : assert(repository != null);
  static TruckingController get to => Get.find();

  RefreshController refreshController = RefreshController();
  RxList<OtherServiceModel> trucking = RxList<OtherServiceModel>();
  Rx<OtherServiceParam> _truckingParam = OtherServiceParam(
    serviceTypeId: OtherServiceTypeEnum.Trucking,
  ).obs;

  RxBool isLoading = false.obs;
  int _totalCount = 0;

  bool get hasMore => trucking.length < _totalCount;

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
      if(trucking.isNotEmpty){
        trucking.clear();
      }
      _truckingParam.value.pageNumber = 1;
    }
    await repository.getOffers(_truckingParam.value).then(
      (response) {
        isLoading.value = false;

        if (response != null) {
          List<OtherServiceModel> result = response.objects
              .map<OtherServiceModel>(
                  (item) => new OtherServiceModel.fromJson(item))
              .toList();

          trucking.addAll(result);
          _handleDistanceAndPrice();
          refreshController.loadComplete();
        } else {
          MessageDialog.showError();
        }
        update();
      },
    );
  }

  Future<void> updateFavorite(int offerId, bool isFavorite) async {
    final updateItem = trucking.firstWhere((_) => _.offerId == offerId);
    updateItem.isFavorite = !isFavorite;
    update();
    await repository.updateFavorite(offerId, isFavorite).then(
      (response) {
        if (!response) {
          updateItem.isFavorite = !updateItem.isFavorite;
          update();
        }
      },
    );
  }

  void onChat(int offerId) async {
    MessageDialog.showLoading();
    await repository.getConversation(offerId).then((response) {
      MessageDialog.hideLoading();
      if (response != null) {
        Get.toNamed(
          Routes.CHAT,
          arguments: ChatArgument(
            conversationId: response.conversationId,
          ),
        );
      }
    });
  }

  void _handleDistanceAndPrice() {
    for (var item in trucking) {
      if (item.trucking.routes == null || item.trucking.routes.isEmpty) {
        return;
      }
      List<double> values = [1.0, (item.trucking.routes.length + 1).toDouble()];
      item.valueSlider = values;
      item.routeStartLocation = item.trucking.routes.first.originCityName;
      item.routeEndLocation = item.trucking.routes.last.destinationCityName;
      item.totalPrice = 0.0;
      item.totalDistance = 0.0;
      for (var route in item.trucking.routes) {
        item.totalDistance += route.distance;
        item.totalPrice += route.price;
      }
    }
  }

  void _calculatePriceAndDistanceValue(OtherServiceModel otherService) {
    otherService.totalPrice = 0.0;
    otherService.totalDistance = 0.0;
    for (var i = otherService.valueSlider[0].toInt();
        i < otherService.valueSlider[1].toInt();
        i++) {
      otherService.totalPrice += otherService.trucking.routes[i - 1].price;
      otherService.totalDistance +=
          otherService.trucking.routes[i - 1].distance;
    }
    update();
  }

  void onSlideFlutterChanged(
      OtherServiceModel otherService, double lowerValue, double upperValue) {
    if (lowerValue.toInt() > otherService.trucking.routes.length ||
        upperValue.toInt() < 1 ||
        lowerValue == upperValue) {
      return;
    }
    otherService.valueSlider[0] = lowerValue;
    otherService.valueSlider[1] = upperValue;

    otherService.routeStartLocation = otherService.trucking.routes
        .firstWhere((_) => _.sortOrder == lowerValue)
        .originCityName;
    otherService.routeEndLocation = otherService.trucking.routes
        .firstWhere((_) => _.sortOrder == (upperValue - 1).toInt())
        .destinationCityName;
    _calculatePriceAndDistanceValue(otherService);
    update();
  }
}
