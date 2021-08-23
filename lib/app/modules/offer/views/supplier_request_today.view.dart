import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/providers/offer.provider.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/data/repositories/offer.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/offer/controllers/supplier_offer.controller.dart';

class RequestsTodayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupplierOfferController>(
      init: Get.put(
        SupplierOfferController(
          repository: OfferRepository(
            apiClient: OfferProvider(),
          ),
        ),
      ),
      builder: (controller) {
        if (controller.isLoading.value) {
          return CupertinoActivityIndicator();
        }
        if (controller.offers.isEmpty) {
          return Center(
            child: Text(
              LocaleKeys.Offer_RequestEmpty.tr,
              style: TextStyle(
                fontSize: 16,
                color: kPrimaryGreyColor,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return SmartRefresher(
          footer: LoadingBottomWidget(),
          enablePullDown: false,
          enablePullUp: controller.hasMore.value,
          onLoading: () {
            controller.onLoading();
          },
          controller: controller.refreshController,
          child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalContentPadding,
              vertical: 5,
            ),
            itemCount: controller.offers.length,
            itemBuilder: (context, index) {
              final item = controller.offers[index];
              return _buildOfferItem(controller, item);
            },
          ),
        );
      },
    );
  }

  Widget _buildOfferItem(SupplierOfferController controller, OfferModel offer) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, 0),
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocaleKeys.Offer_Posted.tr}'
            ' ${controller.calculatePostTime(offer.createdDate)}',
            style: TextStyle(
              fontSize: 14.0,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildOfferInfo(offer),
          Row(
            children: [
              _buildValidDataAndAudience(offer, controller),
              if (AuthController.to.currentUser.hasChat)
                GestureDetector(
                  onTap: () {
                    controller.onChat(offer);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      offer.conversationId != null
                          ? LocaleKeys.Shared_Chat.tr
                          : LocaleKeys.Offer_Accept.tr,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValidDataAndAudience(
      OfferModel offer, SupplierOfferController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Icon(
                Icons.av_timer,
                color: kLightTextColor,
                size: 22,
              ),
              offer.validityDate.isBefore(DateTime.now())
                  ? Text(
                      LocaleKeys.Offer_Expired.tr,
                      style: TextStyle(
                        fontSize: 10.0,
                        color: kHintTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : Text(
                      '${LocaleKeys.Offer_Validate_till.tr} '
                      '${DateFormat('HH:mm a').format(offer.validityDate)}',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: kHintTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              if (offer.validityDate.isAfter(DateTime.now()))
                Text(
                  '-${controller.calculateDurationValidate(offer.validityDate)}',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Image.asset(
                offer.audienceTypeId == AudienceEnum.Public
                    ? 'assets/icons/public.png'
                    : 'assets/icons/non_public.png',
                width: 23,
              ),
              Text(
                offer.audienceTypeId == AudienceEnum.Public
                    ? LocaleKeys.Shared_Public.tr
                    : LocaleKeys.Shared_NonPublic.tr,
                style: TextStyle(
                  fontSize: 10.0,
                  color: kLightTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // if (offer.audienceTypeId == AudienceEnum.Public)
              //   Text(
              //     '(${offer.totalPerson})',
              //     style: TextStyle(
              //       fontSize: 10.0,
              //       color: kLightTextColor,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOfferInfo(OfferModel offer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kOfferBackgroundColor.withOpacity(0.3),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TermName.contractTypeName(offer.contractTypeId),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (TermName.contractTypeName(offer.contractTypeId) !=
                    LocaleKeys.ContractType_Outright.tr)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      offer.coverMonth,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: kPrimaryBlackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    DateFormat('MMM yyyy').format(offer.deliveryDate),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kPrimaryBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: Get.width * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TermName.deliveryWarehouse(offer.deliveryWarehouseId),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '${NumberFormat('###,###.##').format(offer.quantity)}'
                    ' ${TermName.quantityUnitName(offer.quantityUnitTypeId)}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kPrimaryBlackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  TermName.deliveryTermCode(offer.deliveryTermId),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  TermName.gradeName(offer.gradeTypeId),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.end,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    _offerPrice(offer),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                Text(
                  TermName.certificationName(offer.certificationId),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _offerPrice(OfferModel offer) {
    if (offer.contractTypeId == ContractTypeEnum.Outright) {
      return '${NumberFormat("###,###.##").format(offer.price)} '
          '${TermName.priceUnitName(offer.priceUnitTypeId)}';
    } else {
      if (offer.price < 0) {
        return '${NumberFormat("###,###.##").format(offer.price)}'
            ' ${TermName.priceUnitName(offer.priceUnitTypeId)}';
      } else {
        return '+ ${NumberFormat("###,###.##").format(offer.price)} '
            '${TermName.priceUnitName(offer.priceUnitTypeId)}';
      }
    }
  }
}
