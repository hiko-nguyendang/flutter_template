import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/other_service/widgets/other_item.widget.dart';
import 'package:agree_n/app/modules/other_service/controllers/other.controller.dart';

class OtherServiceOtherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (controller.others.isEmpty == null ||
            controller.others.isEmpty) {
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
            itemCount: controller.others.length,
            padding: EdgeInsets.symmetric(
              horizontal: kHorizontalContentPadding,
              vertical: 10,
            ),
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = controller.others[index];
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
