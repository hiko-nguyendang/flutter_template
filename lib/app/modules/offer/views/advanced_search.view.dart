import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/widgets/select_box.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/providers/offer.provider.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/data/repositories/offer.repository.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/offer/controllers/advanced_search.controller.dart';

class OfferAdvancedSearchView extends StatelessWidget {
  final Function(OfferAdvancedSearchModel) onSearch;
  final bool isBuyer;

  const OfferAdvancedSearchView({Key key, this.onSearch, this.isBuyer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<OfferAdvancedSearchController>(
        init: Get.put(
          OfferAdvancedSearchController(
            repository: OfferRepository(
              apiClient: OfferProvider(),
            ),
          ),
        ),
        builder: (controller) {
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(controller),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalContentPadding,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUnit(controller),
                        _buildQuantity(controller),
                        _buildGrade(controller),
                        _buildTypeOfContract(controller),
                        _buildValidity(context, controller),
                        _buildDeliveryDate(context, controller),
                        _buildDeliveryTerm(controller),
                        if (isBuyer) _buildAudience(controller),
                        _buildLocation(controller),
                        _buildCoverMonth(controller),
                        _buildSearchButton(controller),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildDeliveryTerm(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_DeliveryTerms.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          hintText: 'FOB',
          value:
              TermName.deliveryTermName(controller.searchParam.deliveryTermId),
          onTap: () {
            Get.bottomSheet(_buildSelectDeliveryTerm());
          },
        ),
      ],
    );
  }

  Widget _buildGrade(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_Grade.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          hintText: LocaleKeys.CreateOffer_SelectGradeHint.tr,
          value: TermName.gradeName(controller.searchParam.gradeTypeId),
          onTap: () {
            Get.bottomSheet(_buildSelectGrade());
          },
        ),
      ],
    );
  }

  Widget _buildSearchButton(OfferAdvancedSearchController controller) {
    return Row(
      children: [
        Expanded(
          child: RoundedButton(
            backgroundColor: Colors.white,
            textColor: kPrimaryColor,
            labelText: LocaleKeys.OpenContract_Clear.tr,
            onPressed: () {
              controller.onClearSearch();
            },
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: RoundedButton(
            labelText: '${LocaleKeys.Shared_Search.tr} '
                '(${controller.totalFilter.value})',
            onPressed: () {
              onSearch(controller.searchParam);
              controller.onSearchAdvance();
              Get.back();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectGrade() {
    return GetBuilder<OfferAdvancedSearchController>(
      init: Get.find(),
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
                groupValue: popUpController.searchParam.gradeTypeId ?? -1,
                onChanged: (int grade) {
                  popUpController.onGradeChanged(grade);
                  Get.back();
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSelectDeliveryTerm() {
    return GetBuilder<OfferAdvancedSearchController>(
      init: Get.find(),
      builder: (popUpController) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.deliveryTerms.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.deliveryTerms.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: popUpController.searchParam.deliveryTermId ?? -1,
                onChanged: (int term) {
                  popUpController.onDeliveryTermChanged(term);
                  Get.back();
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(OfferAdvancedSearchController controller) {
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
        title: LocaleKeys.Shared_Filter.tr,
        onBack: () {
          Get.back();
        },
      ),
    );
  }

  Widget _buildCoverMonth(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_CoverMonth.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Wrap(
          spacing: 40,
          children:
              List.generate(LookUpController.to.coverMonths.length, (index) {
            final item = LookUpController.to.coverMonths[index];
            return GestureDetector(
              onTap: () {
                controller.updateSelectedCoverMonth(item.id);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: controller.searchParam.coverMonths.contains(item.id)
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)),
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: controller.searchParam.coverMonths.contains(item.id)
                        ? Colors.white
                        : kPrimaryBlackColor.withOpacity(0.8),
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 10),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }

  Widget _buildAudience(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_Audience.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: List.generate(controller.audiences.length, (index) {
            final item = controller.audiences[index];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.updateSelectedAudience(item);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: index == 0
                      ? const EdgeInsets.only(top: 10, right: 10, bottom: 10)
                      : const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: controller.searchParam.audienceTypeIds.contains(item)
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    AudienceEnum.getName(item),
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          controller.searchParam.audienceTypeIds.contains(item)
                              ? Colors.white
                              : kPrimaryBlackColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }

  Widget _buildDeliveryDate(
      BuildContext context, OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_DeliveryDate.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SelectBox(
                hintText: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                value: controller.searchParam.deliveryStartDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.searchParam.deliveryStartDate)
                    : '',
                onTap: () {
                  controller.onSelectDeliveryStartDate(context);
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectBox(
                hintText: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                value: controller.searchParam.deliveryEndDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.searchParam.deliveryEndDate)
                    : '',
                onTap: () {
                  controller.onSelectDeliveryEndDate(context);
                },
              ),
            ),
          ],
        ),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }

  Widget _buildValidity(
      BuildContext context, OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_Validity.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SelectBox(
                hintText: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                value: controller.searchParam.validityStartDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.searchParam.validityStartDate)
                    : '',
                onTap: () {
                  controller.onSelectValidityStartDate(context);
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectBox(
                hintText: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                value: controller.searchParam.validityEndDate != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.searchParam.validityEndDate)
                    : '',
                onTap: () {
                  controller.onSelectValidityEndDate(context);
                },
              ),
            ),
          ],
        ),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }

  Widget _buildTypeOfContract(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: kPrimaryGreyColor),
        Text(
          LocaleKeys.Shared_TypeOfContract.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: Get.width,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: List.generate(
                LookUpController.to.contractTypes.values.length, (index) {
              final item = LookUpController.to.contractTypes.values[index];
              return GestureDetector(
                onTap: () {
                  controller.updateSelectedContractType(item.id);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        controller.searchParam.contractTypeIds.contains(item.id)
                            ? kPrimaryColor
                            : kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.searchParam.contractTypeIds
                              .contains(item.id)
                          ? Colors.white
                          : kPrimaryBlackColor.withOpacity(0.8),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }

  Widget _buildLocation(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_Location.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: Get.width,
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children:
                List.generate(LookUpController.to.locations.length, (index) {
              final item = LookUpController.to.locations[index];
              return GestureDetector(
                onTap: () {
                  controller.updateSelectedLocation(item.id);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: controller.searchParam.warehouseIds.contains(item.id)
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          controller.searchParam.warehouseIds.contains(item.id)
                              ? Colors.white
                              : kPrimaryBlackColor.withOpacity(0.8),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }

  Widget _buildQuantity(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.Shared_Quantity.tr,
              style: TextStyle(
                fontSize: 14,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${NumberFormat().format(controller.searchParam.startQuantity)} - '
              '${NumberFormat().format(controller.searchParam.endQuantity)}',
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        FlutterSlider(
          trackBar: FlutterSliderTrackBar(
            activeTrackBar: BoxDecoration(color: kPrimaryColor),
            activeTrackBarHeight: 6.5,
          ),
          tooltip: FlutterSliderTooltip(
            disabled: true,
          ),
          values: controller.quantityValue,
          rangeSlider: true,
          max: QuantityEnum.QuantityMax,
          min: QuantityEnum.QuantityMin,
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(),
            child: Container(
              width: 20,
              height: 20,
              decoration: new BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: BoxDecoration(),
            child: Container(
              width: 20,
              height: 20,
              decoration: new BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            controller.onDragging(handlerIndex, lowerValue, upperValue);
          },
        ),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }

  Widget _buildUnit(OfferAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_Unit.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            LookUpController.to.quantityUnits.values.length,
            (index) {
              final item = LookUpController.to.quantityUnits.values[index];
              return GestureDetector(
                onTap: () {
                  controller.updateSelectedUnit(item.id);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: controller.searchParam.quantityUnitTypeIds
                            .contains(item.id)
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    LookUpController
                        .to.quantityUnits.values[index].termOptionName,
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.searchParam.quantityUnitTypeIds
                              .contains(item.id)
                          ? Colors.white
                          : kPrimaryBlackColor.withOpacity(0.8),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Divider(color: kPrimaryGreyColor),
      ],
    );
  }
}
