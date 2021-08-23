import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/label_check_box.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/advanced_search.controller.dart';

class OpenContractAdvancedSearchView extends StatelessWidget {
  final Function(OpenContractAdvanceSearchModel) onSearch;
  final bool isBuyer;

  const OpenContractAdvancedSearchView({Key key, this.onSearch, this.isBuyer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpenContractAdvancedSearchController>(
      init: Get.put(
        OpenContractAdvancedSearchController(),
      ),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 15,
            title: _buildBackButton(controller),
            automaticallyImplyLeading: false,
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return;
            },
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.symmetric(horizontal: kHorizontalContentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGrade(controller),
                  _buildType(controller),
                  _buildCommodity(controller),
                  _buildCoverMonth(controller),
                  _buildDestination(controller),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottom(controller),
        );
      },
    );
  }

  Widget _buildBottom(OpenContractAdvancedSearchController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kHorizontalContentPadding,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kPrimaryBlackColor.withOpacity(0.3),
            blurRadius: 3,
            offset: Offset(0, -3),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: RoundedButton(
              backgroundColor: Colors.white,
              textColor: kPrimaryColor,
              labelText: LocaleKeys.OpenContract_Clear.tr,
              onPressed: () {
                controller.clearFilter();
              },
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: RoundedButton(
              backgroundColor: kPrimaryColor,
              textColor: Colors.white,
              labelText: LocaleKeys.OpenContract_Apply.tr,
              onPressed: () {
                onSearch(controller.openContractAdvanceSearchModel);
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestination(OpenContractAdvancedSearchController controller) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              AuthController.to.currentUser.isSupplier
                  ? LocaleKeys.Shared_Destination.tr
                  : LocaleKeys.Shared_Location.tr,
              style: TextStyle(
                fontSize: 14,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: List.generate(
              LookUpController.to.locations.length,
              (index) {
                final item = LookUpController.to.locations[index];
                return LabeledCheckbox(
                  value: controller
                      .openContractAdvanceSearchModel.deliveryWarehouseIds
                      .contains(item.id),
                  label: item.name,
                  onChanged: (value) {
                    controller.onDestinationChanged(value, item.id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverMonth(OpenContractAdvancedSearchController controller) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              LocaleKeys.Shared_CoverMonth.tr,
              style: TextStyle(
                fontSize: 14,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: List.generate(
              LookUpController.to.coverMonths.length,
              (index) {
                final item = LookUpController.to.coverMonths[index];
                return LabeledCheckbox(
                  value: controller.openContractAdvanceSearchModel.coverMonths
                      .contains(item.id),
                  label: item.name,
                  onChanged: (value) {
                    controller.onCoverMonthChanged(value, item.id);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 5),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: kPrimaryGreyColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCommodity(OpenContractAdvancedSearchController controller) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              LocaleKeys.Shared_Commodity.tr,
              style: TextStyle(
                fontSize: 14,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: List.generate(
              LookUpController.to.commodities.values.length,
              (index) {
                final item = LookUpController.to.commodities.values[index];
                return LabeledCheckbox(
                  value: controller
                      .openContractAdvanceSearchModel.commodityTypeIds
                      .contains(item.id),
                  label: item.termOptionName,
                  onChanged: (value) {
                    controller.onCommodityChanged(value, item.id);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 5),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: kPrimaryGreyColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildType(OpenContractAdvancedSearchController controller) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              LocaleKeys.CreateOffer_Type.tr,
              style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            children: List.generate(
              LookUpController.to.coffeeTypes.values.length,
              (index) {
                final item = LookUpController.to.coffeeTypes.values[index];
                return LabeledCheckbox(
                  value: controller.openContractAdvanceSearchModel.coffeeTypeIds
                      .contains(item.id),
                  label: item.termOptionName,
                  onChanged: (value) {
                    controller.onTypeChanged(value, item.id);
                  },
                );
              },
            ),
          ),
          SizedBox(height: 5),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: kPrimaryGreyColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildGrade(OpenContractAdvancedSearchController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            LocaleKeys.Shared_Grade.tr,
            style: TextStyle(
                fontSize: 14,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: () {
            _showGrade();
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  TermName.gradeName(controller
                              .openContractAdvanceSearchModel.gradeTypeId)
                          .isNotEmpty
                      ? TermName.gradeName(
                          controller.openContractAdvanceSearchModel.gradeTypeId)
                      : LocaleKeys.CreateOffer_SelectGradeHint.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: TermName.gradeName(controller
                                .openContractAdvanceSearchModel.gradeTypeId)
                            .isNotEmpty
                        ? kPrimaryBlackColor
                        : kPrimaryGreyColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: kPrimaryColor,
                size: 25,
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Divider(
          height: 0.5,
          thickness: 0.5,
          color: kPrimaryGreyColor.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildBackButton(OpenContractAdvancedSearchController controller) {
    return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
          ),
          Text(
            LocaleKeys.Shared_Filter.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 25),
        ],
      );
  }

  Future _showGrade() {
    return Get.bottomSheet(
      GetBuilder<OpenContractAdvancedSearchController>(
        init: Get.find(),
        builder: (controller) {
          return Container(
            color: Colors.white,
            constraints: BoxConstraints(maxHeight: Get.height * 0.5),
            child: ListView.builder(
              itemCount: LookUpController.to.grades.values.length,
              primary: false,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemBuilder: (context, index) {
                final item = LookUpController.to.grades.values[index];
                return RadioListTile<int>(
                  title: Text(item.termOptionName),
                  activeColor: kPrimaryColor,
                  value: item.id,
                  groupValue: controller
                              .openContractAdvanceSearchModel.gradeTypeId !=
                          null
                      ? controller.openContractAdvanceSearchModel.gradeTypeId
                      : -1,
                  onChanged: (int grade) {
                    controller.onGradeChanged(grade);
                    Get.back();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
