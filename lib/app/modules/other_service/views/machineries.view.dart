import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/other_service/widgets/machineries_item.widget.dart';
import 'package:agree_n/app/modules/other_service/controllers/machineries.controller.dart';

class OtherServiceMachineriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MachineriesController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (controller.machines.isEmpty == null ||
            controller.machines.isEmpty) {
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
            itemCount: controller.machines.length,
            padding: EdgeInsets.symmetric(
              horizontal: kHorizontalContentPadding,
              vertical: 10,
            ),
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = controller.machines[index];
              return MachineryItem(
                item: item,
                swipeController: controller.machineriesSwipeController,
                controller: controller,
              );
            },
          ),
        );
      },
    );
  }
}
