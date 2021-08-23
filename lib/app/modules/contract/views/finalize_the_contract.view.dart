import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/modules/contract/controllers/finalize_contract.controller.dart';

class FinalizeTheContractView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinalizeContractController>(
      init: Get.find(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: AppBarWidget(),
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
          ),
          body: Column(
            children: [
              ScreenHeader(
                showBackButton: true,
                title: controller.title != null ? controller.title : "",
              ),
              controller.isLoading.value
                  ? Expanded(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : _buildBody(controller),
            ],
          ),
          bottomNavigationBar: AppBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildBody(FinalizeContractController controller) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(kHorizontalContentPadding),
            child: Column(
              children: [
                _buildTerms(controller),
                if (!controller.isView)
                  RoundedButton(
                    labelText: LocaleKeys.Chat_FinalizeContract.tr,
                    margin: const EdgeInsets.all(20),
                    onPressed: () {
                      controller.onFinalize();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTerms(FinalizeContractController controller) {
    return Column(
      children: [
        _buildTermItem(
          LocaleKeys.Shared_Contract.tr,
          TermName.contractTypeName(
            controller.contract.contractType,
          ),
        ),
        _buildTermItem(
          LocaleKeys.Shared_Commodity.tr,
          TermName.commodityName(
            controller.contract.commodity,
          ),
        ),
        _buildTermItem(
          LocaleKeys.CreateOffer_Type.tr,
          TermName.coffeeTypeName(
            controller.contract.coffeeType,
          ),
        ),
        _buildTermItem(
          LocaleKeys.Shared_Grade.tr,
          controller.contract.gradeName,
        ),
        _buildTermItem(
          LocaleKeys.Shared_Quantity.tr,
          '${NumberFormat('###,###.##').format(controller.contract.quantity)} '
          '${TermName.quantityUnitName(controller.contract.quantityUnit)}',
        ),
        _buildTermItem(
          LocaleKeys.OtherServices_Packaging_Packing.tr,
          '${NumberFormat('###,###.##').format(controller.contract.packing)} '
          '${TermName.packingUnitName(controller.contract.packingUnit)}',
        ),
        _buildTermItem(
          LocaleKeys.Shared_DeliveryDate.tr,
          DateFormat('MMMM dd, yyyy').format(
            controller.contract.deliveryDate,
          ),
        ),
        _buildTermItem(
          LocaleKeys.CreateOffer_Price.tr,
          '${NumberFormat('###,###.##').format(controller.contract.price)} '
          '${TermName.priceUnitName(controller.contract.priceUnit)}',
        ),
        if (TermName.contractTypeName(controller.contract.contractType) !=
            LocaleKeys.TermOptionName_Outright.tr)
          _buildTermItem(
            LocaleKeys.Shared_CoverMonth.tr,
            controller.contract.coverMonthValue,
          ),
        _buildTermItem(
          LocaleKeys.CreateContract_CropYear.tr,
          controller.contract.cropYear,
        ),
        _buildTermItem(
          LocaleKeys.Shared_DeliveryTerms.tr,
          TermName.deliveryTermName(
            controller.contract.deliveryTerm,
          ),
        ),
        _buildTermItem(
          LocaleKeys.CreateContract_Certification.tr,
          TermName.certificationName(
            controller.contract.certification,
          ),
        ),
        _buildTermItem(
          LocaleKeys.CreateOffer_SpecialClause.tr,
          controller.contract.specialClause,
        ),
      ],
    );
  }

  Widget _buildTermItem(String termName, String termValue) {
    if (termValue == null) {
      return SizedBox();
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: kPrimaryColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          SizedBox(
            width: Get.width * 0.25,
            child: Text(
              '$termName :',
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              termValue,
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
