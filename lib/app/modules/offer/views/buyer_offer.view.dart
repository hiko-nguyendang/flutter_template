import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/search_box.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/modules/offer/widgets/offer_list.widget.dart';
import 'package:agree_n/app/modules/offer/views/advanced_search.view.dart';
import 'package:agree_n/app/modules/offer/controllers/buyer_offer.controller.dart';

class BuyerOfferView extends StatelessWidget {
  final List<Widget> buyerPages = [
    OfferList(),
    OfferList(),
    OfferList(),
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
      body: GetBuilder<BuyerOfferController>(
        init: Get.find(),
        builder: (controller) {
          return Column(
            children: [
              SizedBox(height: 5),
              _buildTabs(controller),
              _buildSearch(controller),
              SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: controller.buyerOfferController,
                  children: buyerPages,
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

  Widget _buildTabs(BuyerOfferController controller) {
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
        isScrollable: false,
        controller: controller.buyerOfferController,
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
        tabs: controller.buyerTabs
            .map(
              (int tab) => Text(
                BuyerOfferTabEnum.getName(tab),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            )
            .toList(),
        onTap: (index) {
          controller.onBuyerTabChanged(index);
        },
      ),
    );
  }

  Widget _buildSearch(BuyerOfferController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalContentPadding),
      child: Row(
        children: [
          Expanded(
            child: SearchBox(
              hintText: LocaleKeys.BuyerOffer_SearchHint.tr,
              controller: controller.textEditingControllerKeyword,
              onSearch: (String keyWord) {
                controller.onSimpleSearch(keyWord.trim());
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(
                OfferAdvancedSearchView(
                  isBuyer: true,
                  onSearch: (searchParam) {
                    controller.onAdvancedSearch(searchParam);
                  },
                ),
                useSafeArea: false,
              );
            },
            child: Container(
              padding: EdgeInsets.all(6),
              margin: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    offset: Offset(0, 0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Icon(
                Icons.tune,
                color: kPrimaryColor,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
