import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/input_box.dart';
import 'package:agree_n/app/widgets/select_box.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/modules/contract/widgets/create_contract_inputs.widget.dart';
import 'package:agree_n/app/modules/contract/controllers/create_contract.controller.dart';

class CreateContractView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: LocaleKeys.CreateContract_Title.tr,
                showBackButton: true,
              ),
              _buildBody(controller, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(CreateContractController controller, BuildContext context) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kHorizontalContentPadding),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSupplierName(controller),
                _buildCoffeeType(controller),
                _buildCommodity(controller),
                _buildContractType(controller),
                _buildDeliveryDate(controller, context),
                _buildQuality(controller),
                _buildQuantity(controller),
                _buildPackingQuantity(controller),
                _buildPrice(controller),
                _buildCoverMonthAndCropYear(controller),
                _buildCertification(controller),
                _buildCertificationPremium(controller),
                _buildLocation(controller),
                _buildContractNumber(controller),
                _buildSpecialClause(controller),
                RoundedButton(
                  labelText: LocaleKeys.CreateContract_Create.tr,
                  onPressed: () {
                    Get.focusScope.unfocus();
                    controller.onCreate();
                  },
                  margin: const EdgeInsets.symmetric(vertical: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierName(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_SupplierName.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        controller.isLoading.value
            ? Container(
                alignment: Alignment.center,
                height: 40,
                child: CupertinoActivityIndicator(),
              )
            : SelectBox(
                value: controller.createContractParam.supplierName,
                hintText: LocaleKeys.CreateContract_SupplierNameHint.tr,
                onTap: () {
                  Get.bottomSheet(SelectSupplierName(), isDismissible: false);
                },
              ),
        if (controller.isSubmit.value &&
            controller.createContractParam.supplierName == null)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              LocaleKeys.Shared_FieldRequiredMessage.tr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCoverMonthAndCropYear(CreateContractController controller) {
    if (TermName.contractTypeName(
            controller.createContractParam.contractTypeId) ==
        LocaleKeys.ContractType_Outright.tr) return _buildCropYear(controller);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildCoverMonth(controller)),
        SizedBox(width: 20),
        Expanded(child: _buildCropYear(controller)),
      ],
    );
  }

  Widget _buildCoverMonth(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_CoverMonth.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        controller.coverMonthLoading.value
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : SelectBox(
                onTap: () {
                  Get.bottomSheet(ContractSelectCoverMonth());
                },
                hintText: LocaleKeys.CreateOffer_CoverMonthHint.tr,
                value: controller.createContractParam.coverMonth ?? "",
              ),
        if (controller.createContractParam.coverMonth == null &&
            controller.isSubmit.value)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              LocaleKeys.Shared_FieldRequiredMessage.tr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCropYear(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_CropYear.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          onTap: () {
            Get.bottomSheet(SelectCropYear());
          },
          hintText: LocaleKeys.CreateContract_CropYear.tr,
          value: controller.createContractParam.cropYear ?? '',
        ),
        if (controller.createContractParam.cropYear == null &&
            controller.isSubmit.value)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              LocaleKeys.Shared_FieldRequiredMessage.tr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContractType(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_ContractType.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          value: TermName.contractTypeName(
              controller.createContractParam.contractTypeId),
          hintText: LocaleKeys.CreateContract_ContractTypeHint.tr,
          onTap: () {
            Get.bottomSheet(SelectContractType());
          },
        ),
        if (controller.createContractParam.contractTypeId == null &&
            controller.isSubmit.value)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              LocaleKeys.Shared_FieldRequiredMessage.tr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCoffeeType(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_CoffeeType.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          value: TermName.coffeeTypeName(
              controller.createContractParam.coffeeTypeId),
          hintText: LocaleKeys.CreateContract_TypeHint.tr,
          onTap: () {
            Get.bottomSheet(SelectCoffeeType());
          },
        ),
      ],
    );
  }

  Widget _buildCommodity(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_Commodity.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          value: TermName.commodityName(
              controller.createContractParam.commodityTypeId),
          hintText: LocaleKeys.CreateContract_CommodityHint.tr,
          onTap: () {
            Get.bottomSheet(SelectCommodity());
          },
        ),
      ],
    );
  }

  Widget _buildDeliveryDate(
      CreateContractController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_DeliveryDate.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          value: controller.createContractParam.deliveryDate != null
              ? DateFormat('dd/MM/yyyy')
                  .format(controller.createContractParam.deliveryDate)
              : '',
          hintText: LocaleKeys.CreateContract_DeliveryDateHint.tr,
          onTap: () {
            controller.selectDeliveryDate(context);
          },
        ),
        if (controller.createContractParam.deliveryDate == null &&
            controller.isSubmit.value)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              LocaleKeys.Shared_FieldRequiredMessage.tr,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }

  Widget _buildCertification(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_Certification.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          value: TermName.certificationName(
              controller.createContractParam.certificationTypeId),
          hintText: LocaleKeys.CreateContract_CertificationHint.tr,
          onTap: () {
            Get.focusScope.unfocus();
            Get.bottomSheet(SelectCertification());
          },
        ),
      ],
    );
  }

  Widget _buildCertificationPremium(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_CertificationPremium.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        InputBox(
          focusNode: FocusNode(),
          hintText: TermName.certificationName(
                      controller.createContractParam.certificationTypeId) ==
                  LocaleKeys.TermOptionName_None.tr
              ? LocaleKeys.CreateContract_NotApplicable.tr
              : '6000',
          controller: controller.certificatePremiumTextController,
          keyboardType: TextInputType.number,
          readOnly: TermName.certificationName(
                  controller.createContractParam.certificationTypeId) ==
              LocaleKeys.TermOptionName_None.tr,
          validator: (text) {
            return null;
          },
          onChanged: (quantity) {
            if (quantity != null && quantity.isNotEmpty) {
              controller.createContractParam.certificationPremium =
                  double.parse(quantity.replaceAll(",", ""));
            }
          },
        ),
      ],
    );
  }

  Widget _buildLocation(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_Destination.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          value: TermName.deliveryWarehouse(
              controller.createContractParam.deliveryWarehouseId),
          hintText: LocaleKeys.CreateContract_LocationHint.tr,
          onTap: () {
            Get.focusScope.unfocus();
            Get.bottomSheet(SelectLocation());
          },
        ),
        if (controller.createContractParam.deliveryWarehouseId == null &&
            controller.isSubmit.value)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              LocaleKeys.Shared_FieldRequiredMessage.tr,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[700],
                  fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }

  Widget _buildQuality(CreateContractController controller) {
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
          value: TermName.gradeName(controller.createContractParam.gradeTypeId),
          hintText: LocaleKeys.CreateOffer_SelectGradeHint.tr,
          onTap: () {
            Get.bottomSheet(SelectQuality());
          },
        ),
        if (controller.createContractParam.gradeTypeId == null &&
            controller.isSubmit.value)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              LocaleKeys.Shared_FieldRequiredMessage.tr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPackingQuantity(CreateContractController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.CreateContract_PackingQuantity.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputBox(
                focusNode: FocusNode(),
                hintText: '6000',
                keyboardType: TextInputType.number,
                onChanged: (quantity) {
                  if (quantity != null && quantity.isNotEmpty) {
                    controller.createContractParam.packingQuantity =
                        double.parse(quantity.replaceAll(",", ""));
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.CreateContract_PackingUnitCode.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SelectBox(
                value: TermName.packingUnitName(
                    controller.createContractParam.packingUnitTypeId),
                hintText: LocaleKeys.CreateContract_PackingUnitHint.tr,
                onTap: () {
                  Get.bottomSheet(SelectPackingUnitCode());
                },
              ),
              if (controller.createContractParam.packingUnitTypeId == null &&
                  controller.isSubmit.value)
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    LocaleKeys.Shared_FieldRequiredMessage.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildQuantity(CreateContractController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.CreateContract_Quantity.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputBox(
                focusNode: FocusNode(),
                hintText: '5000',
                keyboardType: TextInputType.number,
                onChanged: (quantity) {
                  if (quantity != null && quantity.isNotEmpty) {
                    controller.createContractParam.quantity =
                        double.parse(quantity.replaceAll(",", ""));
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
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
              SelectBox(
                value: TermName.quantityUnitName(
                    controller.createContractParam.quantityUnitTypeId),
                hintText: '',
                onTap: () {
                  Get.bottomSheet(SelectQuantityUnit());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContractNumber(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_ContractNumber.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        InputBox(
          focusNode: FocusNode(),
          hintText: 'DB21000001',
          maxLength: 20,
          onChanged: (contractNumber) {
            if (contractNumber != null && contractNumber.isNotEmpty) {
              controller.createContractParam.contractNumber = contractNumber;
            }
          },
        ),
      ],
    );
  }

  Widget _buildSpecialClause(CreateContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateContract_SpecialClause.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        InputBox(
          focusNode: FocusNode(),
          hintText: LocaleKeys.CreateContract_SpecialClauseHint.tr,
          initValue: controller.createContractParam.comment,
          maxLines: 4,
          radius: 20,
          onChanged: (specialClause) {
            controller.createContractParam.specialClause = specialClause;
          },
          validator: (specialClause) {
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPrice(CreateContractController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.CreateOffer_Price.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(100),
                    color: kPrimaryColor.withOpacity(0.05),
                  ),
                  child: Row(
                    children: [
                      if (TermName.contractTypeName(controller
                                  .createContractParam.contractTypeId) !=
                              LocaleKeys.ContractType_Outright.tr &&
                          TermName.contractTypeName(
                                  controller.createContractParam.contractTypeId)
                              .isNotEmpty)
                        SizedBox(
                          width: 30,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: kPrimaryColor,
                              ),
                              isExpanded: true,
                              value: controller.priceSymbol.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: kPrimaryBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (text) {
                                controller.onSymbolChanged(text);
                              },
                              items: ["+", "-"].map(
                                (String symbol) {
                                  return DropdownMenuItem<String>(
                                    value: symbol,
                                    child: Center(
                                      child: Text('$symbol'),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      Expanded(
                        child: InputBox(
                          focusNode: FocusNode(),
                          hintText: '2000',
                          fillColor: Colors.transparent,
                          hasBorder: false,
                          validator: (text) {
                            return null;
                          },
                          contentPadding: EdgeInsets.only(bottom: 16),
                          initValue: controller.createContractParam.price !=
                                  null
                              ? NumberFormat('###,###.##')
                                  .format(controller.createContractParam.price)
                              : null,
                          keyboardType: TextInputType.number,
                          onChanged: (price) {
                            if (price != null && price.isNotEmpty) {
                              final value = '${controller.priceSymbol.value}'
                                  '${price.replaceAll(",", "")}';
                              controller.createContractParam.price =
                                  double.parse(
                                value,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.createContractParam.price == null &&
                    controller.isSubmit.value)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      LocaleKeys.Shared_FieldRequiredMessage.tr,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
                          fontWeight: FontWeight.w400),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.CreateOffer_Currency.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 48,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(
                      horizontal: kHorizontalContentPadding, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(100),
                    color: kPrimaryColor.withOpacity(0.05),
                  ),
                  child: Text(
                    controller.createContractParam.priceUnitTypeId != null
                        ? TermName.priceUnitName(
                            controller.createContractParam.priceUnitTypeId)
                        : "",
                    style: TextStyle(
                        fontSize: 14,
                        color: kPrimaryBlackColor,
                        fontWeight: FontWeight.w400),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
