import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/widgets/search_box.dart';
import 'package:agree_n/app/widgets/bottom_sheet_header.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contract_year_dropdown.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_volume.controller.dart';

class PastContractsVolumeFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PastContractVolumeController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.only(
            top: 5,
            bottom: 20,
            left: kHorizontalContentPadding,
            right: kHorizontalContentPadding,
          ),
          child: Column(
            children: [
              ShadowBox(
                width: double.infinity,
                height: 40,
                borderRadius: 20,
                padding: const EdgeInsets.all(5),
                margin: AuthController.to.currentUser.isSupplier
                    ? const EdgeInsets.symmetric(horizontal: 50)
                    : const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildCommodityItem(controller),
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                      width: 2,
                      thickness: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildDateItem(controller),
                    ),
                    if (AuthController.to.currentUser.isBuyer)
                      VerticalDivider(
                        color: Colors.grey,
                        width: 2,
                        thickness: 1,
                      ),
                    if (AuthController.to.currentUser.isBuyer)
                      Expanded(
                        flex: 2,
                        child: _buildAllSuppliesItem(controller),
                      )
                  ],
                ),
              ),
              ShadowBox(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 40,
                borderRadius: 20,
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: _buildGrade(controller),
                      flex: 2,
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                      width: 2,
                      thickness: 1,
                    ),
                    Expanded(
                      child: _buildContractType(controller),
                      flex: 2,
                    ),
                    VerticalDivider(
                      color: Colors.grey,
                      width: 2,
                      thickness: 1,
                    ),
                    Expanded(
                      child: _buildTimeFrame(controller),
                      flex: 2,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommodityItem(PastContractVolumeController controller) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(_buildCommodityFilter());
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                controller.filterParam.commodityTypeId != null
                    ? TermName.commodityName(
                        controller.filterParam.commodityTypeId)
                    : LocaleKeys.PastContract_FilterCommodity.tr,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(PastContractVolumeController controller) {
    return controller.filterParam.timeFrameTypeId == TimeFrameEnum.Year
        ? InkWell(
            onTap: () {
              Get.bottomSheet(
                _buildYearFilter(),
                isDismissible: false,
                enableDrag: false,
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '${controller.filterParam.fromYear} - ${controller.filterParam.toYear}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: PastContractYearDropDown(
              sizeIcon: 25,
              value: controller.filterParam.fromYear,
              items: controller.years,
              onChanged: (year) {
                controller.onSelectedToAndFromYear(year);
              },
            ),
          );
  }

  Widget _buildAllSuppliesItem(PastContractVolumeController controller) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          _buildSuppliersFilter(),
          isDismissible: true,
          enableDrag: false,
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                controller.filterParam.supplierName ??
                    LocaleKeys.PastContract_FilterSupplier.tr,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommodityFilter() {
    return GetBuilder<PastContractVolumeController>(
      builder: (popUpController) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return;
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            constraints: BoxConstraints(maxHeight: Get.height * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  itemCount: LookUpController.to.commodities.values.length,
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final item = LookUpController.to.commodities.values[index];
                    return RadioListTile<int>(
                      title: Text(item.termOptionName),
                      activeColor: kPrimaryColor,
                      value: item.id,
                      groupValue:
                          popUpController.filterParam.commodityTypeId ?? -1,
                      onChanged: (int commodityType) {
                        popUpController.onSelectCommodity(commodityType);
                        Get.back();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      constraints: BoxConstraints(maxHeight: Get.height * 0.5),
      child: GetBuilder<PastContractVolumeController>(
        builder: (popUpController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      popUpController.onCancelFilter();
                      Get.back();
                    },
                    child: Text(
                      LocaleKeys.Shared_Cancel.tr,
                      style: TextStyle(
                          color: kPrimaryGreyColor.withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      popUpController.onFilterDone();
                      Get.back();
                    },
                    child: Text(
                      LocaleKeys.Shared_Done.tr,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.PastContract_FilterFromDate.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 120,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: kHorizontalContentPadding,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(100),
                          color: kPrimaryColor.withOpacity(0.05),
                        ),
                        child: PastContractYearDropDown(
                          value: popUpController.selectedFromYear.value,
                          items: popUpController.years,
                          onChanged: (year) {
                            popUpController.onSelectedFromYear(year);
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.PastContract_FilterToDate.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 120,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: kHorizontalContentPadding,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(100),
                          color: kPrimaryColor.withOpacity(0.05),
                        ),
                        child: PastContractYearDropDown(
                          value: popUpController.selectedToYear.value,
                          items: popUpController.years,
                          onChanged: (year) {
                            popUpController.onSelectedToYear(year);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSuppliersFilter() {
    return GetBuilder<PastContractVolumeController>(
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetHeader(
                onDone: () {
                  controller.onSelectedSupplier();
                  Get.back();
                },
                onClear: () {
                  controller.onClear();
                },
              ),
              SearchBox(
                onSearch: (keyword) {
                  controller.onSearchSupplier(keyword);
                },
                hintText: LocaleKeys.CreateContract_SearchSupplierHint.tr,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  itemCount: controller.suppliers.length,
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemBuilder: (context, index) {
                    final item = controller.suppliers[index];
                    return InkWell(
                      onTap: () {
                        controller.onSupplierChanged(
                            !controller.filterParam.tenantIds
                                .contains(item.supplierId),
                            item.supplierId);
                      },
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: Checkbox(
                                  value: controller.filterParam.tenantIds
                                      .contains(item.supplierId),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (bool newValue) {
                                    controller.onSupplierChanged(
                                        newValue, item.supplierId);
                                  },
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          kPrimaryGreyColor.withOpacity(0.5),
                                      child: item.image != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: ExtendedImage.network(
                                                item.image,
                                                fit: BoxFit.cover,
                                                width: Get.width,
                                                height: Get.height,
                                                loadStateChanged:
                                                    (ExtendedImageState state) {
                                                  switch (state
                                                      .extendedImageLoadState) {
                                                    case LoadState.loading:
                                                      return CircularProgressIndicator();
                                                      break;
                                                    case LoadState.completed:
                                                      return state
                                                          .completedWidget;
                                                      break;
                                                    default:
                                                      return Center(
                                                        child: Text(
                                                          "${item.firstName[0]}${item.lastName[0]}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                            )
                                          : Text(
                                              "${item.firstName[0]}${item.lastName[0]}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: Get.width * 0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: kPrimaryBlackColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            item.phoneNumber,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: kPrimaryBlueColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeFrame(PastContractVolumeController controller) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          _buildTimeFrameFilter(),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                TimeFrameEnum.getName(
                    controller.filterParam.selectedTimeFrameName),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFrameFilter() {
    return GetBuilder<PastContractVolumeController>(
      builder: (popUpController) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return;
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            constraints: BoxConstraints(maxHeight: Get.height * 0.5),
            child: ListView.builder(
              itemCount: popUpController.timeFrames.length,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final item = popUpController.timeFrames[index];
                return RadioListTile<int>(
                  title: Text(TimeFrameEnum.getName(item)),
                  activeColor: kPrimaryColor,
                  value: item,
                  groupValue: popUpController.filterParam.timeFrameTypeId,
                  onChanged: (int timeFrameType) {
                    popUpController.onSelectedTimeFrameType(timeFrameType);
                    Get.back();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildContractType(PastContractVolumeController controller) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(_buildContractTypeFilter(controller));
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                controller.filterParam.contractTypeId != null
                    ? TermName.contractTypeName(
                        controller.filterParam.contractTypeId)
                    : LocaleKeys.CreateContract_ContractType.tr,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractTypeFilter(
      PastContractVolumeController popUpController) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return;
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        constraints: BoxConstraints(maxHeight: Get.height * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              itemCount: LookUpController.to.contractTypes.values.length,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final item = LookUpController.to.contractTypes.values[index];
                return RadioListTile<int>(
                  title: Text(item.termOptionName),
                  activeColor: kPrimaryColor,
                  value: item.id,
                  groupValue: popUpController.filterParam.contractTypeId ?? -1,
                  onChanged: (int contractType) {
                    popUpController.onSelectContractType(contractType);
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrade(PastContractVolumeController controller) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(_buildGradeFilter());
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                TermName.gradeName(controller.filterParam.gradeTypeId) == ''
                    ? LocaleKeys.Shared_Grade.tr
                    : TermName.gradeName(controller.filterParam.gradeTypeId),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeFilter() {
    return GetBuilder<PastContractVolumeController>(
      builder: (popUpController) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.grades.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.grades.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: popUpController.filterParam.gradeTypeId != null
                    ? popUpController.filterParam.gradeTypeId
                    : -1,
                onChanged: (int grade) {
                  popUpController.onSelectGrade(grade);
                  Get.back();
                },
              );
            },
          ),
        );
      },
    );
  }
}
