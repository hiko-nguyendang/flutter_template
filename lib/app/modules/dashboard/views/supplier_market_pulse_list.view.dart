import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/settings/app_config.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/modules/dashboard/controllers/supplier_market_pulse_list.controller.dart';

class SupplierMarketPulseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<SupplierMarketPulseListController>(
        init: Get.put(
          SupplierMarketPulseListController(
            repository: DashboardRepository(
              apiClient: DashboardProvider(),
            ),
          ),
        ),
        builder: (marketController) {
          if (marketController.isLoading.value) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Column(
            children: [
              ScreenHeader(
                title: LocaleKeys.MarketPulse_Title.tr,
                showBackButton: true,
              ),
              SizedBox(height: 5),
              Expanded(
                child: SmartRefresher(
                  controller: marketController.refreshController,
                  enablePullDown: false,
                  enablePullUp: marketController.hasMore,
                  onLoading: () {
                    marketController.getData(isReload: false);
                  },
                  footer: CustomFooter(
                    height: 30,
                    builder: (BuildContext context, LoadStatus mode) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    },
                  ),
                  child: ListView.builder(
                    itemCount: marketController.marketPulses.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalContentPadding,
                      vertical: 10
                    ),
                    itemBuilder: (context, index) {
                      final item = marketController.marketPulses[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: ShadowBox(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    item.userImage ??
                                        AppConfig.DEFAULT_USER_AVATAR,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 10,
                                        children: [
                                          Text(
                                            item.userName,
                                            style: TextStyle(
                                              color: kPrimaryBlackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('MMM dd, yyyy')
                                                .format(item.createdDate),
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        item.message,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
