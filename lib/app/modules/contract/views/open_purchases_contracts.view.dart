import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/search_box.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/app/widgets/button_filter.dart';
import 'package:agree_n/app/widgets/label_check_box.dart';
import 'package:agree_n/app/widgets/bottom_sheet_header.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/open_contract.controller.dart';
import 'package:agree_n/app/modules/contract/views/open_contract_advanced_search.view.dart';
import 'package:agree_n/app/modules/contract/widgets/open_contract_contract_detail_tab.widget.dart';

class OpenContractsView extends StatelessWidget {
  final List<Widget> pages = [ContractDetailTab(), Container()];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpenContractController>(
      init: Get.find(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: AppBarWidget(),
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
          ),
          body: Column(
            children: [
              _buildTitle(controller),
              Padding(
                padding: const EdgeInsets.all(
                  kHorizontalContentPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBox(
                        hintText: LocaleKeys.OpenContract_SearchHint.tr,
                        controller: controller.textEditingControllerKeyword,
                        onSearch: (keyword) {
                          controller.getOpenContract(keyword: keyword.trim());
                        },
                      ),
                    ),
                    ButtonFilter(
                      onTap: () {
                        Get.dialog(
                          GetBuilder<OpenContractController>(
                            init: Get.find(),
                            builder: (openContractDetailController) {
                              return OpenContractAdvancedSearchView(
                                onSearch: (searchParam) {
                                  openContractDetailController
                                      .onAdvanceSearch(searchParam);
                                },
                              );
                            },
                          ),
                          arguments: controller.openContractAdvanceSearchModel,
                          useSafeArea: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              _buildFilter(controller),
              SizedBox(height: 10),
              _buildTabs(controller),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: pages,
                  physics: NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
          bottomNavigationBar: AppBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildTitle(OpenContractController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: ScreenTitle(
        title: controller.authController.currentUser.isBuyer
            ? LocaleKeys.BuyerDashBoard_OpenPurchasesContracts.tr
            : LocaleKeys.SupplierDashboard_OpenSales.tr,
        onBack: () {
          Get.back();
        },
      ),
    );
  }

  Widget _buildTabs(OpenContractController controller) {
    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TabBar(
        isScrollable: true,
        controller: controller.tabController,
        indicatorColor: kPrimaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: kPrimaryColor,
        unselectedLabelColor: kPrimaryGreyColor,
        labelPadding: const EdgeInsets.all(0),
        indicatorPadding: const EdgeInsets.all(0),
        labelStyle: TextStyle(
          color: kPrimaryGreyColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: controller.tabs
            .map((int tab) => Container(
                width: Get.width * 0.5,
                alignment: Alignment.center,
                child: Tab(text: OpenContractTabEnum.getName(tab))))
            .toList(),
        onTap: (index) {},
      ),
    );
  }

  Widget _buildFilter(OpenContractController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShadowBox(
          borderRadius: 50,
          margin: const EdgeInsets.symmetric(
            horizontal: kHorizontalContentPadding,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: GetBuilder<OpenContractController>(
            init: Get.find(),
            builder: (openContractDetailsController) {
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _showCommodity();
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedCommodity.value,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: kPrimaryGreyColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 25,
                            color: kPrimaryGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    color: kPrimaryGreyColor.withOpacity(0.5),
                    width: 2,
                    margin: const EdgeInsets.only(right: 10),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _showCoverMonth();
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedCoverMonth.value,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: kPrimaryGreyColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 25,
                            color: kPrimaryGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    color: kPrimaryGreyColor.withOpacity(0.5),
                    width: 2,
                    margin: const EdgeInsets.only(right: 10),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        _showContractType();
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.selectedContractType.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: kPrimaryGreyColor,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_sharp,
                            size: 25,
                            color: kPrimaryGreyColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Future _showCoverMonth() {
    return Get.bottomSheet(
      GetBuilder<OpenContractController>(
        init: Get.find(),
        builder: (controller) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 15),
            constraints: BoxConstraints(maxHeight: Get.height * 0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetHeader(
                  onDone: () {
                    controller.onFilter();
                    Get.back();
                  },
                  onClear: () {
                    controller.selectAllCoverMonth(false);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LabeledCheckbox(
                    value: controller
                        .openContractAdvanceSearchModel.selectAllCoverMonth,
                    label: LocaleKeys.OpenContract_All.tr,
                    onChanged: (value) {
                      controller.selectAllCoverMonth(value);
                    },
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: LookUpController.to.coverMonths.length,
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemBuilder: (context, index) {
                      final item = LookUpController.to.coverMonths[index];
                      return LabeledCheckbox(
                        value: controller
                            .openContractAdvanceSearchModel.coverMonths
                            .contains(item.id),
                        label: item.name,
                        onChanged: (value) {
                          controller.onCoverMonthChanged(value, item.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future _showCommodity() {
    return Get.bottomSheet(
      GetBuilder<OpenContractController>(
        init: Get.find(),
        builder: (controller) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 15),
            constraints: BoxConstraints(maxHeight: Get.height * 0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetHeader(
                  onDone: () {
                    controller.onFilter();
                    Get.back();
                  },
                  onClear: () {
                    controller.selectAllCommodity(false);
                  },
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LabeledCheckbox(
                    value: controller
                        .openContractAdvanceSearchModel.selectAllCommodity,
                    label: LocaleKeys.OpenContract_All.tr,
                    onChanged: (value) {
                      controller.selectAllCommodity(value);
                    },
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: LookUpController.to.commodities.values.length,
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemBuilder: (context, index) {
                      final item =
                          LookUpController.to.commodities.values[index];
                      return LabeledCheckbox(
                        value: controller
                            .openContractAdvanceSearchModel.commodityTypeIds
                            .contains(item.id),
                        label: item.name,
                        onChanged: (value) {
                          controller.onCommodityChanged(value, item.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future _showContractType() {
    return Get.bottomSheet(
      GetBuilder<OpenContractController>(
        init: Get.find(),
        builder: (controller) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 15),
            constraints: BoxConstraints(maxHeight: Get.height * 0.4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetHeader(
                  onDone: () {
                    controller.onFilter();
                    Get.back();
                  },
                  onClear: () {
                    controller.selectAllContractType(false);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LabeledCheckbox(
                    value: controller
                        .openContractAdvanceSearchModel.selectAllContractType,
                    label: LocaleKeys.OpenContract_All.tr,
                    onChanged: (value) {
                      controller.selectAllContractType(value);
                    },
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: LookUpController.to.contractTypes.values.length,
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemBuilder: (context, index) {
                      final item =
                          LookUpController.to.contractTypes.values[index];
                      return LabeledCheckbox(
                        value: controller
                            .openContractAdvanceSearchModel.contractTypeIds
                            .contains(item.id),
                        label: item.name,
                        onChanged: (value) {
                          controller.onContractTypeChanged(value, item.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
