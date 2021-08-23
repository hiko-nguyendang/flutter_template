import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/other_service.model.dart';
import 'package:agree_n/app/data/repositories/other_service.repository.dart';

class PackagingController extends GetxController {
  final OtherServiceRepository repository;

  PackagingController({@required this.repository}) : assert(repository != null);
  static PackagingController get to => Get.find();

  RefreshController refreshController = RefreshController();
  SwiperController packagingSwipeController = new SwiperController();

  RxList<OtherServiceModel> packaging = RxList<OtherServiceModel>();
  Rx<OtherServiceParam> _packingParam = OtherServiceParam(
    serviceTypeId: OtherServiceTypeEnum.Packing,
  ).obs;

  RxBool isLoading = false.obs;
  int _totalCount = 0;

  bool get hasMore => packaging.length < _totalCount;

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
      if(packaging.isNotEmpty){
        packaging.clear();
      }
      _packingParam.value.pageNumber = 1;
    }
    await repository.getOffers(_packingParam.value).then(
      (response) {
        isLoading.value = false;
        if (response != null) {
          List<OtherServiceModel> result = response.objects
              .map<OtherServiceModel>(
                  (item) => new OtherServiceModel.fromJson(item))
              .toList();
          packaging.addAll(result);
          refreshController.loadComplete();
        } else {
          MessageDialog.showError();
        }
        update();
      },
    );
  }

  Future<void> updateFavorite(int offerId, bool isFavorite) async {
    final updateItem = packaging.firstWhere((_) => _.offerId == offerId);
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
    await repository.getConversation(offerId).then((response){
      MessageDialog.hideLoading();
      if(response != null){
        Get.toNamed(
          Routes.CHAT,
          arguments:
          ChatArgument(
            conversationId: response.conversationId,
          ),
        );
      }
    });
  }
}
