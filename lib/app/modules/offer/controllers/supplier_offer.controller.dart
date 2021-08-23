import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/utils/datetime_helper.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/repositories/offer.repository.dart';
import 'package:agree_n/app/modules/offer/controllers/advanced_search.controller.dart';

class SupplierOfferController extends GetxController
    with SingleGetTickerProviderMixin {
  final OfferRepository repository;

  SupplierOfferController({@required this.repository})
      : assert(repository != null);

  static SupplierOfferController to = Get.find();

  TabController supplierOfferController;
  RxInt currentTab = SupplierOfferTabEnum.AllMyOffer.obs;
  RxInt _totalCount = 0.obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = false.obs;
  RxBool isAdvancedSearch = false.obs;

  RefreshController refreshController = RefreshController();
  RxList<OfferModel> offers = RxList<OfferModel>();
  Rx<RequestSimpleSearchModel> _requestSimpleSearchParam =
      RequestSimpleSearchModel().obs;
  Rx<OfferSimpleSearchModel> _offerSimpleSearchParam = OfferSimpleSearchModel(
    filterTypeId: OfferFilterTypeEnum.AllOffer,
  ).obs;
  Rx<OfferAdvancedSearchModel> _offerAdvancedSearchParam =
      OfferAdvancedSearchModel().obs;

  TextEditingController textEditingControllerKeyword = TextEditingController();

  //Supplier
  List<int> supplierTabs = [
    SupplierOfferTabEnum.AllMyOffer,
    SupplierOfferTabEnum.PublicOffer,
    SupplierOfferTabEnum.RequestsToday
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
    supplierOfferController.dispose();
    OfferAdvancedSearchController.offerAdvancedSearchModel = null;
    super.onClose();
  }

  void _initTabController() {
    supplierOfferController = TabController(
      vsync: this,
      length: supplierTabs.length,
    );
  }

  void onSupplierTabChange(int index) {
    isAdvancedSearch.value = false;
    currentTab.value = index;
    switch (index) {
      case SupplierOfferTabEnum.AllMyOffer:
        textEditingControllerKeyword.text = "";
        _offerSimpleSearchParam.value = OfferSimpleSearchModel(
          filterTypeId: OfferFilterTypeEnum.AllOffer,
        );
        OfferAdvancedSearchController.offerAdvancedSearchModel = null;
        offerSimpleSearch();
        break;
      case SupplierOfferTabEnum.PublicOffer:
        textEditingControllerKeyword.text = "";
        _offerSimpleSearchParam.value = OfferSimpleSearchModel(
            filterTypeId: OfferFilterTypeEnum.PublicOffer,
            statusId: StatusEnum.Open);
        OfferAdvancedSearchController.offerAdvancedSearchModel = null;
        offerSimpleSearch();
        break;
      case SupplierOfferTabEnum.RequestsToday:
        textEditingControllerKeyword.text = "";
        OfferAdvancedSearchController.offerAdvancedSearchModel = null;
        _requestSimpleSearchParam.value =
            RequestSimpleSearchModel(requestStatusId: StatusEnum.Open);
        requestSimpleSearch();
        break;
    }
    update();
  }

  void onSimpleSearch(String keyWord) {
    if (currentTab.value == SupplierOfferTabEnum.RequestsToday) {
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
    if (currentTab.value == SupplierOfferTabEnum.AllMyOffer) {
      _offerAdvancedSearchParam.value.statusId = null;
      _offerAdvancedSearchParam.value.filterTypeId =
          OfferFilterTypeEnum.AllOffer;
      offerAdvancedSearch();
    } else if (currentTab.value == SupplierOfferTabEnum.PublicOffer) {
      _offerAdvancedSearchParam.value.statusId = StatusEnum.Open;
      _offerAdvancedSearchParam.value.filterTypeId =
          OfferFilterTypeEnum.PublicOffer;
      offerAdvancedSearch();
    } else {
      _offerAdvancedSearchParam.value.statusId = null;
      _offerAdvancedSearchParam.value.filterTypeId = null;
      requestAdvancedSearch();
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
      offers.clear();
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

  void onUpdateOffer(OfferModel offer) async {
    final result =
        await Get.toNamed(Routes.CREATE_OFFER, arguments: offer.offerId);
    if (result != null) {
      final OfferModel offerUpdate =
          offers.firstWhere((_) => _.offerId == result.offerId);
      offers[offers.indexOf(offerUpdate)] = result;
      update();
    }
  }

  void onLoading() {
    if (currentTab.value == SupplierOfferTabEnum.RequestsToday) {
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

  Future<void> onChat(OfferModel offer) async {
    final backResult = await Get.toNamed(
      Routes.CHAT,
      arguments: ChatArgument(
        conversationName: "ECOM",
        contactId: offer.userId,
        requestId: offer.requestId,
        conversationTypeId: ConversationTypeEnum.RequestNegotiation,
        conversationId: offer.conversationId,
      ),
    );
    if (backResult != null) {
      offer.conversationId = backResult.conversationId;
      update();
    }
  }
}
