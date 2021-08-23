import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/other_service/widgets/trucking_item.widget.dart';
import 'package:agree_n/app/modules/other_service/controllers/trucking.controller.dart';

class OtherServiceTruckingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TruckingController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (controller.trucking.isEmpty == null ||
            controller.trucking.isEmpty) {
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
          footer:LoadingBottomWidget(),
          enablePullDown: false,
          enablePullUp: controller.hasMore,
          onLoading: () {
            controller.getData(isReload: false);
          },
          controller: controller.refreshController,
          child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalContentPadding,
              vertical: 10,
            ),
            itemCount: controller.trucking.length,
            itemBuilder: (context, index) {
              final item = controller.trucking[index];
              return TruckingItem(
                item: item,
                controller: controller,
              );
            },
          ),
        );
      },
    );
  }
}
