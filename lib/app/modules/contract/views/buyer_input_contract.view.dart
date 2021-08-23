import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/data/providers/contract.provider.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/buyer_input_contract.controller.dart';

class BuyerInputContractView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<BuyerInputContactController>(
        init: Get.put(
          BuyerInputContactController(
            repository: ContractRepository(
              apiClient: ContractProvider(),
            ),
          ),
        ),
        builder: (controller) {
          return controller.isLoading.value
              ? Center(child: CupertinoActivityIndicator())
              : Column(
                  children: [
                    ScreenHeader(
                      showBackButton: true,
                      title: controller.title ?? "",
                    ),
                    _buildBody(controller, context),
                  ],
                );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildBody(
      BuyerInputContactController controller, BuildContext context) {
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
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    LocaleKeys.Chat_LocationCode.tr,
                    style: TextStyle(
                      fontSize: 11,
                      color: kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: _buildLocation(controller),
                ),
                controller.isReview
                    ? _buildContractNumber(controller)
                    : _buildInputContractNumber(context, controller),
                if (!controller.isReview)
                  RoundedButton(
                    backgroundColor: controller.contract.location == null ||
                            controller.contractNumber.value.isEmpty
                        ? kPrimaryGreyColor.withOpacity(0.3)
                        : kPrimaryColor,
                    margin: const EdgeInsets.only(top: 20),
                    labelText: LocaleKeys.Chat_Next.tr,
                    onPressed: () {
                      if (controller.contract.location == null ||
                          controller.contractNumber.value.isEmpty) return;
                      controller.onNext();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputContractNumber(
      BuildContext context, BuyerInputContactController controller) {
    return Column(
      children: [
        Text(
          LocaleKeys.Chat_InsertYourContactNumber.tr,
          style: TextStyle(
            fontSize: 12,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildContractNumberInput(context, controller),
        Visibility(
          visible: controller.isContactNumberNotValid.value,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              LocaleKeys.Chat_ContactNumberRequiredMessage.tr,
              style: TextStyle(
                fontSize: 12,
                color: kErrorColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.textController.clear();
          },
          child: Text(
            LocaleKeys.InputContract_ClearAll.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContractNumber(BuyerInputContactController controller) {
    return Column(
      children: [
        Text(
          LocaleKeys.Chat_ContractNumber.tr,
          style: TextStyle(
            fontSize: 12,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          controller.contractNumber.value,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildContractNumberInput(
      BuildContext context, BuyerInputContactController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: PinCodeTextField(
        controller: controller.textController,
        appContext: context,
        length: 20,
        autovalidateMode: AutovalidateMode.disabled,
        obscureText: false,
        obscuringCharacter: '*',
        textCapitalization: TextCapitalization.characters,
        animationType: AnimationType.fade,
        validator: (text) {
          return null;
        },
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 30,
          fieldWidth: 15,
          inactiveColor: Colors.black.withOpacity(0.5),
          activeColor: Colors.white,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedColor: Colors.white,
          selectedFillColor: Colors.white,
        ),
        cursorColor: kPrimaryColor,
        animationDuration: Duration(milliseconds: 300),
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        keyboardType: TextInputType.text,
        onCompleted: (contractNumber) {
          controller.contractNumber.value = contractNumber;
        },
        onChanged: (contractNumber) {
          controller.contractNumberChange(contractNumber);
        },
        beforeTextPaste: (text) {
          return false;
        },
      ),
    );
  }

  Widget _buildLocation(BuyerInputContactController controller) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(
        LookUpController.to.locations.length,
        (index) => GestureDetector(
          onTap: () {
            if (controller.isReview) return;
            controller.onSelectedLocation(index);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: LookUpController.to.locations[index].id ==
                      controller.contract.location
                  ? kPrimaryColor
                  : kPrimaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              LookUpController.to.locations[index].name,
              style: TextStyle(
                fontSize: 14,
                color: LookUpController.to.locations[index].id ==
                        controller.contract.location
                    ? Colors.white
                    : kPrimaryBlackColor.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTerms(BuyerInputContactController controller) {
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
          TermName.gradeName(controller.contract.grade),
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
      margin: EdgeInsets.only(bottom: 5),
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
