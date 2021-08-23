import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/search_box.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/button_filter.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/modules/offer/views/public_offers.view.dart';
import 'package:agree_n/app/modules/offer/views/advanced_search.view.dart';
import 'package:agree_n/app/modules/offer/views/supplier_my_offers.views.dart';
import 'package:agree_n/app/modules/offer/views/supplier_request_today.view.dart';
import 'package:agree_n/app/modules/offer/controllers/supplier_offer.controller.dart';

class SupplierOfferView extends StatelessWidget {
  final List<Widget> supplierPages = [
    SupplierAllOffersView(),
    PublicOffersView(),
    RequestsTodayView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<SupplierOfferController>(
        init: Get.find(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(height: 5),
              _buildTabs(controller),
              _buildSearch(controller),
              Expanded(
                child: TabBarView(
                  controller: controller.supplierOfferController,
                  children: supplierPages,
                  physics: NeverScrollableScrollPhysics(),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildTabs(SupplierOfferController controller) {
    return Container(
      height: 35,
      margin: const EdgeInsets.only(bottom: kHorizontalContentPadding),
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
        controller: controller.supplierOfferController,
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
        tabs: controller.supplierTabs
            .map(
              (int tab) => Container(
                width: Get.width * 1 / 3,
                alignment: Alignment.center,
                child: Text(
                  SupplierOfferTabEnum.getName(tab),
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList(),
        onTap: (index) {
          controller.onSupplierTabChange(index);
        },
      ),
    );
  }

  Widget _buildSearch(SupplierOfferController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        kHorizontalContentPadding,
        0,
        kHorizontalContentPadding,
        15,
      ),
      child: Row(
        children: [
          Expanded(
            child: SearchBox(
              hintText: LocaleKeys.SupplierOffer_SearchHint.tr,
              controller: controller.textEditingControllerKeyword,
              onSearch: (String keyWord) {
                controller.onSimpleSearch(keyWord.trim());
              },
            ),
          ),
          ButtonFilter(
            onTap: () {
              Get.dialog(
                OfferAdvancedSearchView(
                  isBuyer: false,
                  onSearch: (searchParam) {
                    controller.onAdvancedSearch(searchParam);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
