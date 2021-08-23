import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/widgets/input_box.dart';
import 'package:agree_n/app/widgets/select_box.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/data/providers/offer.provider.dart';
import 'package:agree_n/app/data/repositories/offer.repository.dart';
import 'package:agree_n/app/modules/offer/widgets/create_request_inputs.widget.dart';
import 'package:agree_n/app/modules/offer/controllers/create_request.controller.dart';

class CreateRequestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: AppBarWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
        ),
        body: GetBuilder<CreateRequestController>(
          init: Get.put(
            CreateRequestController(
              repository: OfferRepository(
                apiClient: OfferProvider(),
              ),
            ),
          ),
          builder: (controller) {
            if (controller.isLoading.value) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }

            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return;
              },
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenHeader(
                        title: controller.createOfferParam.requestId != 0
                            ? LocaleKeys.SupplierOffer_UpdateARequest.tr
                            : LocaleKeys.SupplierOffer_CreateARequest.tr,
                        showBackButton: true,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kHorizontalContentPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCoffeeType(controller),
                            _buildCommodity(controller),
                            _buildTypeOfContract(controller),
                            _buildDeliveryDate(controller, context),
                            _buildGrade(controller),
                            _buildQuantityAndUnit(controller),
                            _buildPackingQuantity(controller),
                            _buildPrice(controller),
                            if (TermName.contractTypeName(controller
                                    .createOfferParam.contractTypeId) !=
                                LocaleKeys.ContractType_Outright.tr)
                              _buildCoverMonth(controller),
                            _buildCertification(controller),
                            _buildAudience(controller),
                            if (controller.createOfferParam.audienceTypeId !=
                                    null &&
                                controller.createOfferParam.audienceTypeId ==
                                    AudienceEnum.NonPublic)
                              _buildSupplier(controller),
                            _buildDeliveryTerm(controller),
                            _buildValidity(controller, context),
                            _buildLocation(controller),
                            _buildSpecialClause(controller),
                            RoundedButton(
                              labelText: LocaleKeys.Shared_Post.tr,
                              onPressed: () {
                                controller.onPostRequest();
                              },
                              margin: EdgeInsets.only(bottom: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpecialClause(CreateRequestController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateOffer_SpecialClause.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        InputBox(
          focusNode: FocusNode(),
          hintText: LocaleKeys.CreateOffer_SpecialClauseHint.tr,
          initValue: controller.createOfferParam.specialClause,
          maxLines: 4,
          radius: 20,
          onChanged: (text) {
            controller.createOfferParam.specialClause = text;
          },
          validator: (newText) {
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCertification(CreateRequestController controller) {
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
              controller.createOfferParam.certificationId),
          hintText: LocaleKeys.CreateContract_CertificationHint.tr,
          onTap: () {
            Get.focusScope.unfocus();
            Get.bottomSheet(RequestSelectCertification());
          },
        ),
      ],
    );
  }

  Widget _buildAudience(CreateRequestController controller) {
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
        SelectBox(
          hintText: LocaleKeys.CreateOffer_AudienceHint.tr,
          value: TermName.audienceTypeName(
              controller.createOfferParam.audienceTypeId),
          onTap: () {
            Get.focusScope.unfocus();
            Get.bottomSheet(
              RequestSelectAudience(),
            );
          },
        ),
        if (controller.createOfferParam.audienceTypeId == null &&
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

  Widget _buildSupplier(CreateRequestController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateOffer_Supplier.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          value: controller.createOfferParam.supplierNames,
          hintText: LocaleKeys.CreateOffer_SupplierHint.tr,
          onTap: () {
            Get.focusScope.unfocus();
            Get.bottomSheet(
              SelectedSupplier(),
              enableDrag: false,
              isDismissible: false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPackingQuantity(CreateRequestController controller) {
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
                initValue: controller.createOfferParam.packingQuantity != null
                    ? NumberFormat('###,###.##')
                        .format(controller.createOfferParam.packingQuantity)
                    : '',
                onChanged: (quantity) {
                  if (quantity != null && quantity.isNotEmpty) {
                    controller.createOfferParam.packingQuantity =
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
                    controller.createOfferParam.packingUnitTypeId),
                hintText: LocaleKeys.CreateContract_PackingUnitHint.tr,
                onTap: () {
                  Get.bottomSheet(RequestSelectPackingUnitCode());
                },
              ),
              if (controller.createOfferParam.packingUnitTypeId == null &&
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

  Widget _buildCoffeeType(CreateRequestController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.CreateOffer_Type.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          hintText: LocaleKeys.CreateOffer_SelectTypeHint.tr,
          value:
              TermName.coffeeTypeName(controller.createOfferParam.coffeeTypeId),
          onTap: () {
            Get.bottomSheet(
              RequestSelectCoffeeType(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommodity(CreateRequestController controller) {
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
          value:
              TermName.commodityName(controller.createOfferParam.commodityId),
          hintText: LocaleKeys.CreateContract_CommodityHint.tr,
          onTap: () {
            Get.bottomSheet(RequestSelectCommodity());
          },
        ),
      ],
    );
  }

  Widget _buildTypeOfContract(CreateRequestController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.Shared_TypeOfContract.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SelectBox(
          hintText: LocaleKeys.CreateOffer_ContractHint.tr,
          value: TermName.contractTypeName(
              controller.createOfferParam.contractTypeId),
          onTap: () {
            Get.bottomSheet(RequestSelectTypeOfContract());
          },
        ),
        if (controller.createOfferParam.contractTypeId == null &&
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

  Widget _buildDeliveryDate(
      CreateRequestController controller, BuildContext context) {
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
        SelectBox(
          hintText: '28/10/2020',
          hasIcon: false,
          value: controller.createOfferParam.deliveryDate != null
              ? DateFormat('dd/MM/yyyy')
                  .format(controller.createOfferParam.deliveryDate)
              : '',
          onTap: () {
            controller.onSelectDeliveryDate(context);
          },
        ),
        if (controller.createOfferParam.deliveryDate == null &&
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

  Widget _buildGrade(CreateRequestController controller) {
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
          value: TermName.gradeName(controller.createOfferParam.gradeTypeId),
          onTap: () {
            Get.bottomSheet(RequestSelectGrade());
          },
        ),
        if (controller.createOfferParam.gradeTypeId == null &&
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

  Widget _buildCoverMonth(CreateRequestController controller) {
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
        controller.coverMonthLoading.value
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : SelectBox(
                onTap: () {
                  Get.bottomSheet(RequestSelectCoverMonth());
                },
                hintText: LocaleKeys.CreateOffer_CoverMonthHint.tr,
                value: controller.createOfferParam.coverMonth ?? "",
              ),
        if (controller.createOfferParam.coverMonth == null &&
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

  Widget _buildDeliveryTerm(CreateRequestController controller) {
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
          hintText: LocaleKeys.CreateOffer_DeliveryTermHint.tr,
          value: TermName.deliveryTermCode(
              controller.createOfferParam.deliveryTermId),
          onTap: () {
            Get.focusScope.unfocus();
            Get.bottomSheet(RequestSelectDeliveryTerm());
          },
        ),
        if (controller.createOfferParam.deliveryTermId == null &&
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
          )
      ],
    );
  }

  Widget _buildValidity(
      CreateRequestController controller, BuildContext context) {
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
        SelectBox(
          hintText: '28/10/2020',
          hasIcon: false,
          value: controller.createOfferParam.validityDate != null
              ? '${DateFormat('dd/MM/yyyy').format(controller.createOfferParam.validityDate)} to '
                  '${DateFormat('HH:mm a').format(controller.createOfferParam.validityDate)}'
              : '',
          onTap: () {
            Get.focusScope.unfocus();
            controller.showValidity(context);
          },
        ),
        if (controller.createOfferParam.validityDate == null &&
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

  Widget _buildLocation(CreateRequestController controller) {
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
          hintText: LocaleKeys.CreateOffer_LocationHint.tr,
          value: TermName.deliveryWarehouse(
              controller.createOfferParam.deliveryWarehouseId),
          onTap: () {
            Get.focusScope.unfocus();
            Get.bottomSheet(
              RequestSelectLocation(),
            );
          },
        ),
        if (controller.createOfferParam.deliveryWarehouseId == null &&
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

  Widget _buildPrice(CreateRequestController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
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
                    if (TermName.contractTypeName(
                                controller.createOfferParam.contractTypeId) !=
                            LocaleKeys.ContractType_Outright.tr &&
                        TermName.contractTypeName(
                                controller.createOfferParam.contractTypeId)
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
                        initValue: controller.createOfferParam.price != null
                            ? NumberFormat('###,###.##')
                                .format(controller.createOfferParam.price)
                            : null,
                        keyboardType: TextInputType.number,
                        onChanged: (price) {
                          if (price != null && price.isNotEmpty) {
                            controller.createOfferParam.price = double.parse(
                              price.replaceAll(",", ""),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.createOfferParam.price == null &&
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
        SizedBox(width: 20),
        Expanded(
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
              SelectBox(
                hasIcon: false,
                hintText: LocaleKeys.CreateOffer_CurrencyHint.tr,
                value: TermName.priceUnitName(
                    controller.createOfferParam.priceUnitTypeId),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityAndUnit(CreateRequestController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.Shared_Quantity.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InputBox(
                focusNode: FocusNode(),
                hintText: '500',
                onChanged: (quantity) {
                  if (quantity != null && quantity.isNotEmpty) {
                    controller.createOfferParam.quantity =
                        double.parse(quantity.replaceAll(",", ""));
                  }
                },
                initValue: controller.createOfferParam.quantity != null
                    ? NumberFormat('###,###.##')
                        .format(controller.createOfferParam.quantity)
                    : null,
                keyboardType: TextInputType.number,
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
                hintText: LocaleKeys.CreateOffer_UnitHint.tr,
                value: TermName.quantityUnitName(
                    controller.createOfferParam.quantityUnitTypeId),
                onTap: () {
                  Get.bottomSheet(RequestSelectUnit());
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
