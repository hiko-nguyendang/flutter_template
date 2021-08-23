import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/tooltip.util.dart';
import 'package:agree_n/app/enums/selector.enum.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/providers/contract.provider.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/contract/controllers/open_contract.controller.dart';

class ContractDetailTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpenContractController>(
      init: Get.put(
        OpenContractController(
          repository: ContractRepository(
            apiClient: ContractProvider(),
          ),
        ),
      ),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (controller.openContractList.isEmpty) {
          return Center(
            child: Text(LocaleKeys.DashBoard_NoData.tr),
          );
        }
        return Column(
          children: [
            Expanded(
              child: HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: 1560,
                isFixedHeader: true,
                itemCount: controller.openContractList.length + 1,
                headerWidgets: _getTitleWidget(controller),
                leftSideItemBuilder: (context, index) {
                  if (index == controller.openContractList.length) {
                    return _buildTotalColumn(controller);
                  }
                  return _generateFirstColumnRow(
                      index, controller.openContractList[index].vendorName);
                },
                rightSideItemBuilder: (context, index) {
                  if (index == controller.openContractList.length) {
                    return _buildTotalRow(controller);
                  }
                  return _generateRightHandSideColumnRow(
                      controller.openContractList[index]);
                },
                rowSeparatorWidget: Divider(
                  color: kPrimaryGreyColor.withOpacity(0.5),
                  height: 1.0,
                  thickness: 0.0,
                ),
                verticalScrollbarStyle: const ScrollbarStyle(
                  isAlwaysShown: true,
                  thickness: 0,
                  radius: Radius.circular(5.0),
                ),
                horizontalScrollbarStyle: const ScrollbarStyle(
                  isAlwaysShown: true,
                  thickness: 0,
                  radius: Radius.circular(5.0),
                ),
              ),
            ),
            if (controller.hasMore) _buildButtonShowMore(controller),
          ],
        );
      },
    );
  }

  Widget _buildButtonShowMore(OpenContractController controller) {
    return GestureDetector(
      onTap: () {
        controller.getOpenContract(
          keyword: null,
          isReload: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          controller.isLoadMore.value
              ? LocaleKeys.OpenContract_loading.tr
              : LocaleKeys.OpenContract_showMore.tr,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget(OpenContractController controller) {
    return [
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_VendorName.tr,
            controller.filterParam.isDescVendorName,
            width: 120, isFirstRow: true),
        onTap: () async {
          controller.filterParam.isDescVendorName =
              await controller.onSortParam(SelectorEnum.VendorName,
                  controller.filterParam.isDescVendorName);
        },
      ),
      _buildTypeTitle(),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_ContractNo.tr,
            controller.filterParam.isDescContractNumber),
        onTap: () async {
          controller.filterParam.isDescContractNumber =
              await controller.onSortParam(SelectorEnum.ContractNumber,
                  controller.filterParam.isDescContractNumber);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_Quantity.tr,
            controller.filterParam.isDescQuantity),
        onTap: () async {
          controller.filterParam.isDescQuantity = await controller.onSortParam(
            SelectorEnum.Quantity,
            controller.filterParam.isDescQuantity,
          );
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_Quality.tr,
            controller.filterParam.isDescQuality),
        onTap: () async {
          controller.filterParam.isDescQuality = await controller.onSortParam(
              SelectorEnum.Quality, controller.filterParam.isDescQuality);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_ContractDate.tr,
            controller.filterParam.isDescContractDate),
        onTap: () async {
          controller.filterParam.isDescContractDate =
              await controller.onSortParam(SelectorEnum.ContractDate,
                  controller.filterParam.isDescContractDate);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_Deadline.tr,
            controller.filterParam.isDescDeadline),
        onTap: () async {
          controller.filterParam.isDescDeadline = await controller.onSortParam(
              SelectorEnum.DeadLine, controller.filterParam.isDescDeadline);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_OverDue.tr,
            controller.filterParam.isDescOverdue),
        onTap: () async {
          controller.filterParam.isDescOverdue = await controller.onSortParam(
              SelectorEnum.OverDueDay, controller.filterParam.isDescOverdue);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_DeliveryBags.tr,
            controller.filterParam.isDescDeliveryBag),
        onTap: () async {
          controller.filterParam.isDescDeliveryBag =
              await controller.onSortParam(SelectorEnum.DeliveryBags,
                  controller.filterParam.isDescDeliveryBag);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_DeliveryNetWt.tr,
            controller.filterParam.isDescDeliveryNet),
        onTap: () async {
          controller.filterParam.isDescDeliveryNet =
              await controller.onSortParam(SelectorEnum.DeliveryNetWt,
                  controller.filterParam.isDescDeliveryNet);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_PendingNW.tr,
            controller.filterParam.isDescPendingNW),
        onTap: () async {
          controller.filterParam.isDescPendingNW = await controller.onSortParam(
              SelectorEnum.PendingNW, controller.filterParam.isDescPendingNW);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_Price.tr,
            controller.filterParam.isDescPrice),
        onTap: () async {
          controller.filterParam.isDescPrice = await controller.onSortParam(
              SelectorEnum.Price, controller.filterParam.isDescPrice);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_FinalPrice.tr,
            controller.filterParam.isDescFinalPrice),
        onTap: () async {
          controller.filterParam.isDescFinalPrice =
              await controller.onSortParam(SelectorEnum.FinalPrice,
                  controller.filterParam.isDescFinalPrice);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_PriceUnitCode.tr,
            controller.filterParam.isDescPriceUnitCode),
        onTap: () async {
          controller.filterParam.isDescPriceUnitCode =
              await controller.onSortParam(SelectorEnum.PriceUnitType,
                  controller.filterParam.isDescPriceUnitCode);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_CertCode.tr,
            controller.filterParam.isDescCertCode),
        onTap: () async {
          controller.filterParam.isDescCertCode = await controller.onSortParam(
              SelectorEnum.CertCode, controller.filterParam.isDescCertCode);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(
            LocaleKeys.OpenContract_Crop.tr, controller.filterParam.isDescCrop),
        onTap: () async {
          controller.filterParam.isDescCrop = await controller.onSortParam(
              SelectorEnum.Crop, controller.filterParam.isDescCrop);
        },
      ),
      GestureDetector(
        child: _getTitleItemWidget(LocaleKeys.OpenContract_Remark.tr,
            controller.filterParam.isDescRemark),
        onTap: () async {
          controller.filterParam.isDescRemark = await controller.onSortParam(
              SelectorEnum.Remark, controller.filterParam.isDescRemark);
        },
      ),
    ];
  }

  Widget _getTitleItemWidget(String label, bool isSort,
      {bool isFirstRow = false, double width = 100}) {
    return Container(
      width: width,
      height: 50,
      color: isFirstRow ? kPrimaryColor : kPrimaryColor.withOpacity(0.5),
      alignment: Alignment.center,
      child: isSort != null
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isFirstRow ? Colors.white : kPrimaryBlackColor),
                  ),
                ),
                Icon(isSort ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16,
                    color: isFirstRow ? Colors.white : kPrimaryBlackColor)
              ],
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isFirstRow ? Colors.white : kPrimaryBlackColor,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _buildTypeTitle() {
    return Container(
      width: 60,
      height: 50,
      padding: const EdgeInsets.only(left: 5, top: 10),
      color: kPrimaryColor.withOpacity(0.5),
      alignment: Alignment.topLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.OpenContract_Type.tr,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kPrimaryBlackColor),
          ),
          MyTooltip(
            message: 'OC: ${LocaleKeys.ContractType_OnCall.tr}\n'
                'O: ${LocaleKeys.ContractType_Outright.tr}\n'
                'D: ${LocaleKeys.ContractType_Deposit.tr}',
            child: Icon(
              Icons.help,
              color: kPrimaryBlackColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _generateFirstColumnRow(int index, String vendorName) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        border: index == 0
            ? Border(
                top: BorderSide(color: Colors.white, width: 1),
              )
            : Border(
                top: BorderSide(color: Colors.white, width: 0),
              ),
      ),
      child: Text(
        vendorName != null ? vendorName : "",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(OpenContractModel value) {
    return Row(
      children: <Widget>[
        _buildRightColumnValue(ContractTypeEnum.getType(value.contractTypeId),
            width: 60),
        _buildRightColumnValue(value.contractNumber),
        _buildRightColumnValue(
            NumberFormat('###,###.##').format(value.quantity)),
        _buildRightColumnValue(value.quality),
        _buildRightColumnValue(
            DateFormat('dd/MM/yyyy').format(value.contractDate)),
        _buildRightColumnValue(DateFormat('dd/MM/yyyy').format(value.deadLine)),
        _buildRightColumnValue(value.overDueDay.toString()),
        _buildRightColumnValue(
            NumberFormat('###,###.##').format(value.deliveryBags)),
        _buildRightColumnValue(
            NumberFormat('###,###.##').format(value.deliveryNetWt)),
        _buildRightColumnValue(
            NumberFormat('###,###.##').format(value.pendingNW)),
        _buildRightColumnValue(value.price.toString()),
        _buildRightColumnValue(
            NumberFormat('###,###.##').format(value.finalPrice)),
        _buildRightColumnValue(value.priceUnitType),
        _buildRightColumnValue(value.certCode),
        _buildRightColumnValue(value.crop.toString()),
        _buildRightColumnValue(value.remark),
      ],
    );
  }

  Widget _buildRightColumnValue(String value, {double width = 100.0}) {
    return Container(
      width: width,
      height: 50,
      padding: const EdgeInsets.only(left: 5),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(
              value != null ? value : "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          VerticalDivider(
            color: kPrimaryGreyColor.withOpacity(0.5),
            thickness: 1,
            width: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(OpenContractController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildRightColumnValue('', width: 60),
            _buildRightColumnValue(''),
            _buildRightColumnValue(
              NumberFormat('###,###.##').format(controller.totalQuantity.value),
            ),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
            _buildRightColumnValue(
              NumberFormat('###,###.##')
                  .format(controller.totalDeliveryBag.value),
            ),
            _buildRightColumnValue(
              NumberFormat('###,###.##')
                  .format(controller.totalDeliveryNet.value),
            ),
            _buildRightColumnValue(
              NumberFormat('###,###.##')
                  .format(controller.totalPendingNW.value),
            ),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
            _buildRightColumnValue(''),
          ],
        ),
        Divider(
          color: kPrimaryGreyColor.withOpacity(0.5),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }

  Widget _buildTotalColumn(OpenContractController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 5),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: kPrimaryGreyColor.withOpacity(0.5),
              ),
            ),
          ),
          child: Text(
            LocaleKeys.OpenContract_Total.tr,
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Divider(
          color: kPrimaryGreyColor.withOpacity(0.5),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
