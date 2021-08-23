import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/dashboard/widgets/dashboard_widgets.widget.dart';
import 'package:agree_n/app/modules/dashboard/controllers/dashboard.controller.dart';

class BuyerDashboardView extends StatelessWidget {
  final DashboardController _dashboardController = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppBarWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
        ),
        body: Obx(
          () => _dashboardController.isLoading.value
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SmartRefresher(
                  controller: _dashboardController.refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: () {
                    _dashboardController.getDashboardData();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_authController.currentUser != null &&
                            _authController.currentUser.hasWidget)
                          DashboardWidgets(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kHorizontalContentPadding,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _authController.currentUser != null &&
                                        _authController.currentUser.hasOffer
                                    ? _buildOfferSession()
                                    : SizedBox(),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: _authController.currentUser != null &&
                                        _authController
                                            .currentUser.hasOpenContract
                                    ? _buildContractSession()
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kHorizontalContentPadding,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _authController.currentUser != null &&
                                        _authController
                                            .currentUser.hasPastContract
                                    ? _buildPastContractSession()
                                    : SizedBox(),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: _authController.currentUser != null &&
                                        _authController
                                            .currentUser.hasOtherService
                                    ? _buildOtherServicesSession()
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildButtons(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: AppBottomNavigationBar(),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (_authController.currentUser != null &&
              _authController.currentUser.hasCreateRequest)
            Expanded(
              flex: 1,
              child: RoundedButton(
                labelText: LocaleKeys.BuyerDashBoard_PostRequestButton.tr,
                onPressed: () {
                  Get.toNamed(Routes.CREATE_REQUEST);
                },
              ),
            ),
          if (_authController.currentUser != null &&
              _authController.currentUser.hasCreateContract &&
              _authController.currentUser.hasCreateRequest)
            SizedBox(width: 15),
          if (_authController.currentUser != null &&
              _authController.currentUser.hasCreateContract)
            Expanded(
              flex: 1,
              child: RoundedButton(
                backgroundColor: Colors.white,
                textColor: kPrimaryColor,
                labelText: LocaleKeys.BuyerDashBoard_create_contract_button.tr,
                onPressed: () {
                  Get.toNamed(Routes.CREATE_CONTRACT);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOtherServicesSession() {
    return ShadowBox(
      width: Get.width * 0.4,
      height: 150,
      borderRadius: 15,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.Shared_OthersServices.tr,
            style: TextStyle(
              fontSize: 16,
              color: kPrimaryBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.OTHER_SERVICES,
                  arguments: OtherServicesTabEnum.TruckingTab,
                );
              },
              child: Text(
                LocaleKeys.Shared_Trucking.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(
                Routes.OTHER_SERVICES,
                arguments: OtherServicesTabEnum.MachineriesTab,
              );
            },
            child: Text(
              LocaleKeys.Shared_Machineries.tr,
              style: TextStyle(
                fontSize: 15,
                color: kPrimaryColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.OTHER_SERVICES,
                  arguments: OtherServicesTabEnum.PackingTab,
                );
              },
              child: Text(
                LocaleKeys.Shared_Packaging.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.OTHER_SERVICES,
                  arguments: OtherServicesTabEnum.OtherTab,
                );
              },
              child: Text(
                LocaleKeys.DashBoard_Fertilizers.tr,
                style: TextStyle(
                  fontSize: 15,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastContractSession() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.PAST_CONTRACTS);
      },
      child: ShadowBox(
        width: Get.width * 0.4,
        height: 150,
        borderRadius: 15,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.DashBoard_PastSince.tr,
                    style: TextStyle(
                      fontSize: 11,
                      color: kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(_dashboardController
                        .buyerDashboard.currentCropYearStartDate),
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              height: 40,
              child: Text(
                LocaleKeys.BuyerDashBoard_PastContracts.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                _dashboardController.buyerDashboard.pastContractNumber
                    .toString(),
                style: TextStyle(
                  fontSize: 38,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Wrap(
              spacing: 5,
              children: [
                Container(
                  height: 12,
                  width: 8,
                  color: kPrimaryColor,
                ),
                Text(
                  LocaleKeys.DashBoard_SeeAllPast.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractSession() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.OPEN_CONTRACTS);
      },
      child: ShadowBox(
        width: Get.width * 0.4,
        height: 150,
        borderRadius: 15,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              LocaleKeys.Shared_Contract.tr,
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryGreyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            SizedBox(
              height: 40,
              child: Text(
                LocaleKeys.BuyerDashBoard_OpenPurchasesContracts.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                _dashboardController.buyerDashboard.openPurchaseContractNumber
                    .toString(),
                style: TextStyle(
                  fontSize: 38,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Wrap(
              spacing: 5,
              children: [
                Container(
                  height: 12,
                  width: 8,
                  color: kPrimaryColor,
                ),
                Text(
                  LocaleKeys.DashBoard_SeeAllContracts.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferSession() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.BUYER_OFFER,
        );
      },
      child: ShadowBox(
        width: Get.width * 0.4,
        height: 150,
        borderRadius: 15,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.BuyerDashBoard_OffersToday.tr,
                    style: TextStyle(
                      fontSize: 11,
                      color: kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(
                        _dashboardController.buyerDashboard.lastAccessDateTime),
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              height: 40,
              child: Text(
                LocaleKeys.BuyerDashBoard_SuppliersOffers.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                _dashboardController.buyerDashboard.lastAccessOpenOfferNumber
                    .toString(),
                style: TextStyle(
                  fontSize: 38,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Wrap(
              spacing: 5,
              children: [
                Container(
                  height: 12,
                  width: 8,
                  color: kPrimaryColor,
                ),
                Text(
                  LocaleKeys.DashBoard_SeeAllOffers.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
