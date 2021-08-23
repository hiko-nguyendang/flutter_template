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

class MachineriesController extends GetxController {
  final OtherServiceRepository repository;

  MachineriesController({@required this.repository})
      : assert(repository != null);
  static MachineriesController get to => Get.find();

  RefreshController refreshController = RefreshController();
  SwiperController machineriesSwipeController = new SwiperController();

  RxList<OtherServiceModel> machines = RxList<OtherServiceModel>();
  Rx<OtherServiceParam> _machineryParam = OtherServiceParam(
    serviceTypeId: OtherServiceTypeEnum.Machinery,
  ).obs;

  RxBool isLoading = false.obs;
  int _totalCount = 0;

  bool get hasMore => machines.length < _totalCount;

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
      if(machines.isNotEmpty){
        machines.clear();
      }
      _machineryParam.value.pageNumber = 1;
    }
    await repository.getOffers(_machineryParam.value).then(
      (response) {
        isLoading.value = false;
        if (response != null) {
          List<OtherServiceModel> result = response.objects
              .map<OtherServiceModel>(
                  (item) => new OtherServiceModel.fromJson(item))
              .toList();
          machines.addAll(result);
          setMoreText();
          refreshController.loadComplete();
        } else {
          MessageDialog.showError();
        }
        update();
      },
    );
  }

  Future<void> updateFavorite(int offerId, bool isFavorite) async {
    final updateItem = machines.firstWhere((_) => _.offerId == offerId);
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

  void setMoreText() {
    machines.forEach((machinery) {
      if (machinery.comments != null && machinery.comments.length > 120) {
        machinery.firstHalf = machinery.comments.substring(0, 120);
        machinery.secondHalf =
            machinery.comments.substring(120, machinery.comments.length);
        machinery.isMore = true;
      } else {
        machinery.comments == null
            ? machinery.firstHalf = ""
            : machinery.firstHalf = machinery.comments;
        machinery.secondHalf = "";
        machinery.isMore = false;
      }
    });
  }

  void updateSeeMore(OtherServiceModel machine) {
    machine.isMore = !machine.isMore;
    update();
  }
}
