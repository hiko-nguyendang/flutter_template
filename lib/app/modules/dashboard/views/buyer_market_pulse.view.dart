import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/dashboard/views/market_pulse_detail.view.dart';
import 'package:agree_n/app/modules/dashboard/controllers/market_pulse_list.controller.dart';

class BuyerMarketPulseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          ScreenTitle(
            title: LocaleKeys.MarketPulse_MyPosts.tr,
            onBack: () {
              Get.offAllNamed(Routes.DASHBOARD);
            },
          ),
          Expanded(
            child: GetBuilder<MarketPulseListController>(
              init: Get.find(),
              builder: (controller) {
                if (controller.isLoading.value) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                return SmartRefresher(
                  controller: controller.refreshController,
                  enablePullDown: false,
                  enablePullUp: controller.hasMore,
                  onLoading: () {
                    controller.getData(isReload: false);
                  },
                  footer: LoadingBottomWidget(),
                  child: ListView.builder(
                    itemCount: controller.marketPulses.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalContentPadding,
                      vertical: 10,
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.marketPulses[index];
                      return _buildItem(item, controller);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      MarketPulseModel item, MarketPulseListController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ShadowBox(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(item.createdDate),
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                item.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    InkWell(
                      child: Icon(Icons.edit, size: 17, color: kPrimaryColor),
                      onTap: () {
                        Get.to(
                          () => BuyerMarketPulseFormScreen(),
                          arguments: item,
                        );
                      },
                    ),
                    InkWell(
                      child: Icon(Icons.delete, size: 17, color: kDangerColor),
                      onTap: () {
                        controller.deleteItem(item.id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
