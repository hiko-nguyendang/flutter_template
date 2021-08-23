import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/utils/datetime_helper.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/repositories/offer.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/offer/controllers/advanced_search.controller.dart';

class BuyerOfferController extends GetxController
    with SingleGetTickerProviderMixin {
  final OfferRepository repository;

  BuyerOfferController({@required this.repository})
      : assert(repository != null);

  static BuyerOfferController to = Get.find();

  TabController buyerOfferController;
  RxInt currentTab = BuyerOfferTabEnum.OfferToday.obs;
  RxInt _totalCount = 0.obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = false.obs;
  RxBool isAdvancedSearch = false.obs;

  RefreshController refreshController = RefreshController();
  RxList<OfferModel> offers = RxList<OfferModel>();
  Rx<RequestSimpleSearchModel> _requestSimpleSearchParam =
      RequestSimpleSearchModel().obs;
  Rx<OfferSimpleSearchModel> _offerSimpleSearchParam = OfferSimpleSearchModel(
    filterTypeId: OfferFilterTypeEnum.OfferToday,
    statusId: StatusEnum.Open,
  ).obs;
  Rx<OfferAdvancedSearchModel> _offerAdvancedSearchParam =
      OfferAdvancedSearchModel().obs;

  TextEditingController textEditingControllerKeyword = TextEditingController();

  List<int> buyerTabs = [
    BuyerOfferTabEnum.OfferToday,
    BuyerOfferTabEnum.AllMyRequest,
    BuyerOfferTabEnum.Saved
  ];

  OfferAdvancedSearchModel get offerAdvancedSearchParam =>
      _offerAdvancedSearchParam.value;

  RequestSimpleSearchModel get requestSimpleSearchParam =>
      _requestSimpleSearchParam.value;

  OfferSimpleSearchModel get offerSimpleSearchParam =>
      _offerSimpleSearchParam.value;

  @override
  void onInit() {
    _initTabController();
    offerSimpleSearch();
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    buyerOfferController.dispose();
    OfferAdvancedSearchController.offerAdvancedSearchModel = null;
    super.onClose();
  }

  void _initTabController() {
    buyerOfferController = TabController(
      vsync: this,
      length: buyerTabs.length,
    );
  }

  void onBuyerTabChanged(int index) {
    isAdvancedSearch.value = false;
    currentTab.value = index;
    OfferAdvancedSearchController.offerAdvancedSearchModel = null;
    textEditingControllerKeyword.text = "";

    switch (index) {
      case BuyerOfferTabEnum.AllMyRequest:
        _requestSimpleSearchParam.value = RequestSimpleSearchModel();
        if (textEditingControllerKeyword.value.text != null)
          requestSimpleSearch();
        break;
      case BuyerOfferTabEnum.OfferToday:
        _offerSimpleSearchParam.value = OfferSimpleSearchModel(
          filterTypeId: OfferFilterTypeEnum.OfferToday,
          statusId: StatusEnum.Open,
        );
        offerSimpleSearch();
        break;
      case BuyerOfferTabEnum.Saved:
        _offerSimpleSearchParam.value = OfferSimpleSearchModel(
          filterTypeId: OfferFilterTypeEnum.Saved,
        );
        offerSimpleSearch();
        break;
    }
    update();
  }

  void onSimpleSearch(String keyWord) {
    if ((currentTab.value == BuyerOfferTabEnum.AllMyRequest &&
        AuthController.to.currentUser.isBuyer)) {
      requestSimpleSearchParam.keyword = keyWord;
      requestSimpleSearch();
    } else {
      offerSimpleSearchParam.keyword = keyWord;
      offerSimpleSearch();
    }
  }

  void onAdvancedSearch(OfferAdvancedSearchModel searchParam) async {
    textEditingControllerKeyword.text = "";
    isAdvancedSearch.value = true;
    searchParam.pageNumber = 1;
    _offerAdvancedSearchParam.value = searchParam;
    if (currentTab.value == BuyerOfferTabEnum.AllMyRequest) {
      _offerAdvancedSearchParam.value.filterTypeId = null;
      _offerAdvancedSearchParam.value.statusId = null;
      requestAdvancedSearch();
    } else if (currentTab.value == BuyerOfferTabEnum.OfferToday) {
      _offerAdvancedSearchParam.value.filterTypeId =
          OfferFilterTypeEnum.OfferToday;
      _offerAdvancedSearchParam.value.statusId = StatusEnum.Open;
      offerAdvancedSearch();
    } else {
      _offerAdvancedSearchParam.value.statusId = null;
      _offerAdvancedSearchParam.value.filterTypeId = OfferFilterTypeEnum.Saved;
      offerAdvancedSearch();
    }
    update();
  }

  Future<void> requestAdvancedSearch({bool isReload = true}) async {
    if (isReload) {
      isLoading.value = true;
      offers.clear();
      offerAdvancedSearchParam.pageNumber = 1;
      update();
    }
    await repository
        .requestAdvancedSearch(offerAdvancedSearchParam)
        .then((response) {
      if (response != null) {
        _totalCount.value = response.totalCount;
        offers.addAll(response.objects);
        offerAdvancedSearchParam.pageNumber += 1;
        _checkHasMore();
        refreshController.loadComplete();
      }
      isLoading.value = false;
    });
  }

  Future<void> requestSimpleSearch({bool isReload = true}) async {
    if (isReload) {
      isLoading.value = true;
      offers.clear();
      requestSimpleSearchParam.pageNumber = 1;
      update();
    }
    await repository
        .requestSimpleSearch(requestSimpleSearchParam)
        .then((response) {
      if (response != null) {
        _totalCount.value = response.totalCount;
        offers.addAll(response.objects);
        requestSimpleSearchParam.pageNumber += 1;
        _checkHasMore();
        refreshController.loadComplete();
      }
      isLoading.value = false;
      update();
    });
  }

  Future<void> offerAdvancedSearch({bool isReload = true}) async {
    if (isReload) {
      isLoading.value = true;
      offers.clear();
      offerAdvancedSearchParam.pageNumber = 1;
      update();
    }
    await repository
        .offerAdvancedSearch(offerAdvancedSearchParam)
        .then((response) {
      if (response != null) {
        _totalCount.value = response.totalCount;
        offers.addAll(response.objects);
        offerAdvancedSearchParam.pageNumber += 1;
        _checkHasMore();
        refreshController.loadComplete();
      }
      isLoading.value = false;
      update();
    });
  }

  Future<void> offerSimpleSearch({bool isReload = true}) async {
    if (isReload) {
      isLoading.value = true;
      if (offers.isNotEmpty) {
        offers.clear();
      }
      offerSimpleSearchParam.pageNumber = 1;
      update();
    }
    await repository.offerSimpleSearch(offerSimpleSearchParam).then((response) {
      if (response != null) {
        _totalCount.value = response.totalCount;
        offers.addAll(response.objects);
        offerSimpleSearchParam.pageNumber += 1;
        _checkHasMore();
        refreshController.loadComplete();
      }
      isLoading.value = false;
      update();
    });
  }

  void _checkHasMore() {
    hasMore.value = _totalCount.value > offers.length;
    update();
  }

  String calculatePostTime(DateTime postDate) {
    if (DateFormat('dd MM yyyy').format(postDate) ==
        DateFormat('dd MM yyyy').format(DateTime.now())) {
      return timeAgo.format(postDate, locale: Get.locale.languageCode);
    } else {
      return DateFormat('MMM, dd yyyy hh:mm a').format(postDate);
    }
  }

  String calculateDurationValidate(DateTime validateDate) {
    return DateTimeHelper.calculateDurationValidate(validateDate);
  }

  void onUpdateRequest(int requestId) async {
    final result =
        await Get.toNamed(Routes.CREATE_REQUEST, arguments: requestId);
    if (result != null) {
      final OfferModel requestUpdate =
          offers.firstWhere((_) => _.requestId == result.requestId);
      offers[offers.indexOf(requestUpdate)] = result;
      update();
    }
  }

  void onSetFavoriteOffer(OfferModel offerModel) async {
    final FavoriteOfferModel favoriteOfferModel = FavoriteOfferModel(
      offerId: offerModel.offerId,
      userId: AuthController.to.currentUser.id,
      isFavorite: !offerModel.isFavoriteOffer,
    );
    offerModel.isFavoriteOffer = !offerModel.isFavoriteOffer;
    if (currentTab.value == 2 && !offerModel.isFavoriteOffer) {
      offers.remove(offerModel);
    }
    update();
    await repository.setFavoriteOffer(favoriteOfferModel).then((response) {
      if (!response) {
        offerModel.isFavoriteOffer = !offerModel.isFavoriteOffer;
        update();
      }
    });
  }

  void onLoading() {
    if (currentTab.value == BuyerOfferTabEnum.AllMyRequest) {
      if (isAdvancedSearch.value) {
        requestAdvancedSearch(isReload: false);
      } else {
        requestSimpleSearch(isReload: false);
      }
    } else {
      if (isAdvancedSearch.value) {
        offerAdvancedSearch(isReload: false);
      } else {
        offerSimpleSearch(isReload: false);
      }
    }
  }
}
