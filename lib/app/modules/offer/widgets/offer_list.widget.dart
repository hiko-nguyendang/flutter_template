import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/favorite_icon.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/offer/controllers/buyer_offer.controller.dart';

class OfferList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyerOfferController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return CupertinoActivityIndicator();
        }
        if (controller.offers.isEmpty) {
          return Center(
            child: Text(
              controller.currentTab.value == BuyerOfferTabEnum.AllMyRequest
                  ? LocaleKeys.Offer_RequestEmpty.tr
                  : LocaleKeys.Offer_OfferEmpty.tr,
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
              return _buildOfferItem(item, controller);
            },
          ),
        );
      },
    );
  }

  Widget _buildOfferItem(OfferModel offer, BuyerOfferController controller) {
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
        children: [
          _buildOfferHeader(offer, controller),
          _buildOfferInfo(offer),
          _buildValidDateAndAudience(offer, controller)
        ],
      ),
    );
  }

  Widget _buildOfferHeader(OfferModel offer, BuyerOfferController controller) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.currentTab.value != BuyerOfferTabEnum.AllMyRequest)
                Text(
                  offer.supplierName ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(
                '${LocaleKeys.Offer_Posted.tr} '
                '${controller.calculatePostTime(offer.createdDate)}',
                style: TextStyle(
                  fontSize: controller.currentTab.value !=
                          BuyerOfferTabEnum.AllMyRequest
                      ? 12
                      : 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (controller.currentTab.value != BuyerOfferTabEnum.AllMyRequest)
          FavoriteIcon(
            isFavorite: offer.isFavoriteOffer ?? false,
            onTap: () {
              controller.onSetFavoriteOffer(offer);
            },
          ),
      ],
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
                  TermName.deliveryWarehouse(offer.deliveryWarehouseId) != null
                      ? TermName.deliveryWarehouse(offer.deliveryWarehouseId)
                      : "",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Text(
                //   offer.specialClause ?? '',
                //   style: TextStyle(
                //     fontSize: 12.0,
                //     color: kPrimaryBlackColor,
                //     fontWeight: FontWeight.w400,
                //   ),
                //   maxLines: 4,
                //   overflow: TextOverflow.ellipsis,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '${NumberFormat('###,###.##').format(offer.quantity)} '
                    '${TermName.quantityUnitName(offer.quantityUnitTypeId)}',
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
                  padding: const EdgeInsets.only(top: 5),
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
                SizedBox(
                  height: 5,
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

  Widget _buildValidDateAndAudience(
      OfferModel offer, BuyerOfferController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          SizedBox(
            width: Get.width * 0.6,
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
                  ],
                )
              ],
            ),
          ),
          if (AuthController.to.currentUser != null &&
              AuthController.to.currentUser.hasChat)
            _buildChatButton(offer, controller),
        ],
      ),
    );
  }

  Widget _buildChatButton(OfferModel offer, BuyerOfferController controller) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (controller.currentTab.value == BuyerOfferTabEnum.AllMyRequest) {
            controller.onUpdateRequest(offer.requestId);
          } else {
            Get.toNamed(
              Routes.CHAT,
              arguments: ChatArgument(
                conversationName: offer.supplierName,
                conversationTypeId: ConversationTypeEnum.OfferNegotiation,
                contactId: offer.userId,
                offerId: offer.offerId,
                conversationId: offer.conversationId,
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            controller.currentTab.value == BuyerOfferTabEnum.AllMyRequest
                ? LocaleKeys.CreateOffer_Modify.tr
                : LocaleKeys.Shared_Chat.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
