import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';

class OpenContractController extends GetxController
    with SingleGetTickerProviderMixin {
  ContractRepository repository;

  OpenContractController({@required this.repository})
      : assert(repository != null);

  static OpenContractController to = Get.find();
  final AuthController authController = Get.find();

  TextEditingController textEditingControllerKeyword = TextEditingController();
  TabController tabController;

  Rx<OpenContractSortParam> filter = OpenContractSortParam().obs;
  RxList<OpenContractModel> openContractList = RxList<OpenContractModel>([]);
  Rx<OpenContractAdvanceSearchModel> _openContractAdvanceSearchModel =
      OpenContractAdvanceSearchModel().obs;
  List<int> tabs = [
    OpenContractTabEnum.ContractDetail,
    OpenContractTabEnum.FixationDetails
  ];
  SortCriteriaModel sortCriteria = SortCriteriaModel();

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  RxDouble totalQuantity = 0.0.obs;
  RxDouble totalDeliveryBag = 0.0.obs;
  RxDouble totalDeliveryNet = 0.0.obs;
  RxDouble totalPendingNW = 0.0.obs;
  RxString selectedCommodity = LocaleKeys.Shared_Commodity.tr.obs;
  RxString selectedCoverMonth = LocaleKeys.Shared_CoverMonth.tr.obs;
  RxString selectedContractType = LocaleKeys.Shared_TypeOfContract.tr.obs;
  RxInt _totalCount = 0.obs;
  int currentPage;

  OpenContractAdvanceSearchModel get openContractAdvanceSearchModel =>
      _openContractAdvanceSearchModel.value;

  OpenContractSortParam get filterParam => filter.value;

  bool get hasMore => _totalCount.value > openContractList.length;

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: tabs.length);
    _onSetDefaultParam();
    getOpenContract(keyword: null);
    super.onInit();
  }

  Future<void> getOpenContract({String keyword, bool isReload = true}) async {
    clearDesc();
    _openContractAdvanceSearchModel.value.keyword = keyword;
    if (isReload) {
      _totalCount.value = 0;
      _openContractAdvanceSearchModel.value.pageNumber = 1;
      isLoading.value = true;
      _openContractAdvanceSearchModel.value.pageSize = 6;

      if (openContractList.isNotEmpty) {
        openContractList.clear();
      }
    } else {
      _openContractAdvanceSearchModel.value.pageSize = 15;
      isLoadMore.value = true;
    }
    update();

    try {
      await repository
          .getOpenContractSearch(openContractAdvanceSearchModel)
          .then(
        (response) {
          if (response != null && response.body != null) {
            final result = OpenContractDataResultModel.fromJson(response.body);
            _totalCount.value = result.totalCount;
            openContractList.addAll(result.objects);
            openContractAdvanceSearchModel.pageNumber += 1;
            _calculateTotal();
          }
          _setValueCompletedLoad(isReload);
          update();
        },
      );
    } catch (e) {
      _setValueCompletedLoad(isReload);
      update();
    }
  }

  void _calculateTotal() {
    totalQuantity = 0.0.obs;
    totalDeliveryBag = 0.0.obs;
    totalDeliveryNet = 0.0.obs;
    totalPendingNW = 0.0.obs;
    for (var item in openContractList) {
      totalQuantity += item.quantity;
      totalDeliveryBag += item.deliveryBags;
      totalDeliveryNet += item.deliveryNetWt;
      totalPendingNW += item.pendingNW;
    }
  }

  void clearDesc() {
    filterParam.isDescVendorName = null;
    filterParam.isDescContractNumber = null;
    filterParam.isDescQuantity = null;
    filterParam.isDescQuality = null;
    filterParam.isDescContractDate = null;
    filterParam.isDescDeadline = null;
    filterParam.isDescOverdue = null;
    filterParam.isDescDeliveryBag = null;
    filterParam.isDescDeliveryNet = null;
    filterParam.isDescPendingNW = null;
    filterParam.isDescPrice = null;
    filterParam.isDescFinalPrice = null;
    filterParam.isDescPriceUnitCode = null;
    filterParam.isDescCertCode = null;
    filterParam.isDescCrop = null;
    filterParam.isDescRemark = null;
    update();
  }

  Future<bool> onSortParam(String selector, bool param) async {
    if (param == null) {
      clearDesc();
      param = true;
    } else {
      param = !param;
    }
    sortCriteria.selector = selector;
    sortCriteria.desc = param;
    _openContractAdvanceSearchModel.value.sort = [sortCriteria];
    currentPage = _openContractAdvanceSearchModel.value.pageNumber;
    _openContractAdvanceSearchModel.value.pageNumber = 1;
    _openContractAdvanceSearchModel.value.pageSize = openContractList.length;
    await onSort();
    _openContractAdvanceSearchModel.value.pageNumber = currentPage;
    update();
    return param;
  }

  Future<void> onSort() async {
    try {
      await repository
          .getOpenContractSearch(openContractAdvanceSearchModel)
          .then(
        (response) {
          if (response != null && response.body != null) {
            openContractList.clear();
            openContractList.addAll(
                OpenContractDataResultModel.fromJson(response.body).objects);
            update();
          }
        },
      );
    } catch (e) {
      throw e;
    }
  }

  void onAdvanceSearch(
      OpenContractAdvanceSearchModel openContractAdvanceSearch) {
    textEditingControllerKeyword.text = "";
    _openContractAdvanceSearchModel.value = openContractAdvanceSearch;
    onFilter();
    update();
  }

  void _onSetDefaultParam() {
    if (AuthController.to.currentUser.isBuyer) {
      openContractAdvanceSearchModel.openContractFilterTypeId =
          UserRoleEnum.Buyer;
    }
    if (AuthController.to.currentUser.isSupplier) {
      openContractAdvanceSearchModel.openContractFilterTypeId =
          UserRoleEnum.Supplier;
      openContractAdvanceSearchModel.tenantId =
          AuthController.to.currentUser.tenantId;
    }
  }

  void _setValueCompletedLoad(bool isReload) {
    if (isReload) {
      isLoading.value = false;
    } else {
      isLoadMore.value = false;
    }
  }

  void onCoverMonthChanged(bool value, int coverMonthId) {
    if (value) {
      openContractAdvanceSearchModel.coverMonths.add(coverMonthId);
    } else {
      openContractAdvanceSearchModel.coverMonths.remove(coverMonthId);
    }
    if (openContractAdvanceSearchModel.coverMonths.length ==
        LookUpController.to.coverMonths.length) {
      _openContractAdvanceSearchModel.value.selectAllCoverMonth = true;
    } else {
      _openContractAdvanceSearchModel.value.selectAllCoverMonth = false;
    }
    update();
  }

  void onCommodityChanged(bool value, int commodityId) {
    if (value) {
      openContractAdvanceSearchModel.commodityTypeIds.add(commodityId);
    } else {
      openContractAdvanceSearchModel.commodityTypeIds.remove(commodityId);
    }
    if (openContractAdvanceSearchModel.commodityTypeIds.length ==
        LookUpController.to.commodities.values.length) {
      _openContractAdvanceSearchModel.value.selectAllCommodity = true;
    } else {
      _openContractAdvanceSearchModel.value.selectAllCommodity = false;
    }
    update();
  }

  void onContractTypeChanged(bool value, int contractTypeId) {
    if (value) {
      _openContractAdvanceSearchModel.value.contractTypeIds.add(contractTypeId);
    } else {
      _openContractAdvanceSearchModel.value.contractTypeIds
          .remove(contractTypeId);
    }
    if (openContractAdvanceSearchModel.contractTypeIds.length ==
        LookUpController.to.contractTypes.values.length) {
      _openContractAdvanceSearchModel.value.selectAllContractType = true;
    } else {
      _openContractAdvanceSearchModel.value.selectAllContractType = false;
    }
    update();
  }

  void onFilter() {
    textEditingControllerKeyword.text = "";
    selectedCommodity.value = TermName.commodityListName(
      openContractAdvanceSearchModel.commodityTypeIds,
    );
    selectedCoverMonth.value = TermName.coverMonthListName(
      openContractAdvanceSearchModel.coverMonths,
    );
    selectedContractType.value = TermName.contractListName(
      openContractAdvanceSearchModel.contractTypeIds,
    );
    if (openContractAdvanceSearchModel.commodityTypeIds == null ||
        openContractAdvanceSearchModel.commodityTypeIds.isEmpty) {
      openContractAdvanceSearchModel.selectAllCommodity = false;
    }
    if (openContractAdvanceSearchModel.coverMonths == null ||
        openContractAdvanceSearchModel.coverMonths.isEmpty) {
      openContractAdvanceSearchModel.selectAllCoverMonth = false;
    }
    if (openContractAdvanceSearchModel.contractTypeIds == null ||
        openContractAdvanceSearchModel.contractTypeIds.isEmpty) {
      openContractAdvanceSearchModel.selectAllContractType = false;
    }
    getOpenContract(keyword: null);
  }

  void selectAllCommodity(bool value) {
    _openContractAdvanceSearchModel.value.selectAllCommodity = value;
    if (value) {
      _openContractAdvanceSearchModel.value.commodityTypeIds =
          LookUpController.to.commodities.values.map((_) => _.id).toList();
    } else {
      _openContractAdvanceSearchModel.value.commodityTypeIds.clear();
    }
    update();
  }

  void selectAllCoverMonth(bool value) {
    _openContractAdvanceSearchModel.value.selectAllCoverMonth = value;
    if (value) {
      _openContractAdvanceSearchModel.value.coverMonths =
          LookUpController.to.coverMonths.map((_) => _.id).toList();
    } else {
      _openContractAdvanceSearchModel.value.coverMonths.clear();
    }
    update();
  }

  void selectAllContractType(bool value) {
    _openContractAdvanceSearchModel.value.selectAllContractType = value;
    if (value) {
      _openContractAdvanceSearchModel.value.contractTypeIds =
          LookUpController.to.contractTypes.values.map((_) => _.id).toList();
    } else {
      _openContractAdvanceSearchModel.value.contractTypeIds.clear();
    }
    update();
  }
}
