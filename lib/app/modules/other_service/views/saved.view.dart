import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/other_service/widgets/other_item.widget.dart';
import 'package:agree_n/app/modules/other_service/controllers/saved.controller.dart';
import 'package:agree_n/app/modules/other_service/widgets/trucking_item.widget.dart';
import 'package:agree_n/app/modules/other_service/widgets/packaging_item.widget.dart';
import 'package:agree_n/app/modules/other_service/widgets/machineries_item.widget.dart';

class OtherServiceSavedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SavedController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (controller.allOffers.isEmpty == null ||
            controller.allOffers.isEmpty) {
          return Center(
            child: Text(
              LocaleKeys.Offer_OfferEmpty.tr,
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
          controller: controller.refreshController,
          footer: LoadingBottomWidget(),
          enablePullDown: false,
          enablePullUp: controller.hasMore,
          onLoading: () {
            controller.getData(isReload: false);
          },
          child: ListView.builder(
            itemCount: controller.allOffers.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalContentPadding,
              vertical: 10,
            ),
            itemBuilder: (context, index) {
              final item = controller.allOffers[index];
              if (item.serviceTypeId == OtherServiceTypeEnum.Packing) {
                return PackagingItem(
                  item: item,
                  controller: controller,
                  swipeController: controller.packagingSwipeController,
                );
              }
              if (item.serviceTypeId == OtherServiceTypeEnum.Trucking) {
                return TruckingItem(
                  item: item,
                  controller: controller,
                );
              }
              if (item.serviceTypeId == OtherServiceTypeEnum.Machinery) {
                return MachineryItem(
                  item: item,
                  swipeController: controller.machineriesSwipeController,
                  controller: controller,
                );
              }
              return OtherItem(
                item: item,
                swipeController: controller.otherSwipeController,
                controller: controller,
              );
            },
          ),
        );
      },
    );
  }
}
