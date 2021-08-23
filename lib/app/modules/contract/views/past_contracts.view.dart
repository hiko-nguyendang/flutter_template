import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract.controller.dart';

class PastContractsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<PastContractController>(
        init: Get.find(),
        builder: (controller) {
          return controller.isLoading.value
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  children: [
                    ScreenTitle(
                      title: LocaleKeys.BuyerDashBoard_PastContracts.tr,
                      onBack: () {
                        Get.back();
                      },
                    ),
                    _buildTabs(controller),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: controller.pastContractPages,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ),
                  ],
                );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildTabs(PastContractController controller) {
    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: kHorizontalContentPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: TabBar(
        isScrollable: true,
        controller: controller.tabController,
        indicatorColor: kPrimaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: kPrimaryColor,
        unselectedLabelColor: kPrimaryGreyColor,
        labelPadding: const EdgeInsets.all(0),
        indicatorPadding: const EdgeInsets.all(0),
        labelStyle: TextStyle(
          color: kPrimaryGreyColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: controller.pastContractTabs
            .map(
              (int tab) => Container(
                width: Get.width * 1 / 3,
                alignment: Alignment.center,
                child: Tab(
                  text: PastContractTabEnum.getName(tab),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
