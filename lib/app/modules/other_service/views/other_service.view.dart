import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/modules/other_service/controllers/other_service.controller.dart';

class OtherServiceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherServiceController>(
      init: Get.find(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: AppBarWidget(),
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
          ),
          body: Column(
            children: [
              ScreenTitle(
                title: LocaleKeys.OtherServices_Title.tr,
                onBack: () {
                  Get.back();
                },
              ),
              _buildTabs(controller),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: controller.pages,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: AppBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildTabs(OtherServiceController controller) {
    return Container(
      height: 35,
      margin: EdgeInsets.only(bottom: 10),
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
        tabs: controller.tabs
            .map(
              (int tab) => Container(
                width: tab == OtherServicesTabEnum.MachineriesTab
                    ? Get.width * 0.25
                    : Get.width * 0.2,
                alignment: Alignment.center,
                child: Tab(text: OtherServicesTabEnum.getName(tab)),
              ),
            )
            .toList(),
        onTap: (index) {
          controller.onTabChanged(index);
        },
      ),
    );
  }
}
