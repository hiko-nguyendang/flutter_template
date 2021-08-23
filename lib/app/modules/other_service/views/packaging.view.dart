import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/other_service/widgets/packaging_item.widget.dart';
import 'package:agree_n/app/modules/other_service/controllers/packaging.controller.dart';

class OtherServicePackagingView extends StatefulWidget {
  @override
  _OtherServicePackagingViewState createState() =>
      _OtherServicePackagingViewState();
}

class _OtherServicePackagingViewState extends State<OtherServicePackagingView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagingController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (controller.packaging.isEmpty == null ||
            controller.packaging.isEmpty) {
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
          footer: LoadingBottomWidget(),
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
            itemCount: controller.packaging.length,
            itemBuilder: (context, index) {
              final item = controller.packaging[index];
              return PackagingItem(
                item: item,
                controller: controller,
                swipeController: controller.packagingSwipeController,
              );
            },
          ),
        );
      },
    );
  }
}
