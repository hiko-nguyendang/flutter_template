import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/widgets/favorite_icon.dart';
import 'package:agree_n/app/data/models/other_service.model.dart';

class TruckingItem extends StatelessWidget {
  final OtherServiceModel item;
  final dynamic controller;

  TruckingItem({Key key, @required this.item, @required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      borderRadius: 0,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTitle(),
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            color: kPrimaryGreyColor.withOpacity(0.1),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * 0.4,
                      child: _buildFieldTitles(),
                    ),
                    Expanded(
                      child: _buildFieldValue(),
                    ),
                  ],
                ),
                if (item.trucking.routes != null &&
                    item.trucking.routes.isNotEmpty)
                  _buildDistanceSlide(),
              ],
            ),
          ),
          _buildChatButton(),
        ],
      ),
    );
  }

  Widget _buildDistanceSlide() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.routeStartLocation ?? "",
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryGreyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              item.routeEndLocation ?? "",
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryGreyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
          child: FlutterSlider(
            trackBar: FlutterSliderTrackBar(
              activeTrackBar: BoxDecoration(color: kPrimaryColor),
              activeTrackBarHeight: 5,
              inactiveTrackBar:
                  BoxDecoration(color: kPrimaryColor.withOpacity(0.2)),
            ),
            tooltip: FlutterSliderTooltip(
              disabled: true,
            ),
            values: item.valueSlider,
            rangeSlider: true,
            hatchMark: FlutterSliderHatchMark(
              labels: List.generate(
                item.trucking.routes.length + 1,
                (index) {
                  if (index == 0) {
                    return FlutterSliderHatchMarkLabel(
                      percent: 0,
                      label: Text(
                        '|',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  if (index == item.trucking.routes.length) {
                    return FlutterSliderHatchMarkLabel(
                      percent: 100,
                      label: Text(
                        '|',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  return FlutterSliderHatchMarkLabel(
                    percent: 100 / item.trucking.routes.length * index,
                    label: Text(
                      '|',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            max: (item.trucking.routes.length + 1).toDouble(),
            min: 1,
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
              controller.onSlideFlutterChanged(item, lowerValue, upperValue);
            },
            minimumDistance: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.tenantName,
            style: TextStyle(
              fontSize: 16,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        FavoriteIcon(
          isFavorite: item.isFavorite,
          onTap: () {
            controller.updateFavorite(item.offerId, item.isFavorite);
          },
        ),
      ],
    );
  }

  String _truckingPrice() {
    if (item.trucking.routes.isEmpty) {
      return '${NumberFormat('###,###.##').format(item.totalPrice ?? 0)}';
    } else {
      return '${NumberFormat('###,###.##').format(item.totalPrice ?? 0)} '
          '${TruckingPriceUnitType.getName(item.trucking.routes.first.priceUnitTypeId ?? 0)}';
    }
  }

  Widget _buildFieldValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${NumberFormat().format(item.trucking.truckSize)} '
          '${TermName.quantityUnitName(item.trucking.truckSizeQuantityUnitTypeId)}',
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            item.trucking.truckNumber,
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '${NumberFormat("###,###.##").format(item.trucking.volumeAvailable)} '
          '${TermName.quantityUnitName(item.trucking.volumeQuantityUnitTypeId)}',
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '${DateFormat('dd MMM. yy').format(item.trucking.validityStart)} - '
            '${DateFormat('dd MMM. yy').format(item.trucking.validityEnd)}',
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          _truckingPrice(),
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '${NumberFormat('###,###.##').format(item.totalDistance ?? 0)} Km',
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldTitles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.OtherServices_TruckSize.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            LocaleKeys.OtherServices_NoTruck.tr,
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          LocaleKeys.OtherServices_VolumeAvailable.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            LocaleKeys.Shared_Validity.tr,
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          LocaleKeys.CreateOffer_Price.tr,
          style: TextStyle(
            fontSize: 14,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            LocaleKeys.OtherServices_Distance.tr,
            style: TextStyle(
              fontSize: 14,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatButton() {
    return GestureDetector(
      onTap: () {
        controller.onChat(item.offerId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: Get.width * 0.35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          LocaleKeys.Shared_Chat.tr,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
