import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/data/providers/contract.provider.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/contract_status.controller.dart';

class ContractStatusView extends StatelessWidget {
  final int contactType;

  const ContractStatusView({Key key, this.contactType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContractStatusController>(
      init: Get.put(
        ContractStatusController(
          repository: ContractRepository(
            apiClient: ContractProvider(),
          ),
        ),
      ),
      builder: (_controller) {
        return Scaffold(
          appBar: AppBar(
            title: AppBarWidget(),
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
          ),
          body: _controller.isLoading.value
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  children: [
                    ScreenHeader(
                      title: contactType == ContactTypeEnum.OtherService
                          ? LocaleKeys.Offer_Status.tr
                          : LocaleKeys.Contract_Status.tr,
                      showBackButton: true,
                    ),
                    Expanded(
                      child: _controller.contractsStatus.isEmpty ||
                              _controller.contractsStatus == null
                          ? Center(
                              child: Text(
                                LocaleKeys.Contract_Empty.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kPrimaryGreyColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SmartRefresher(
                              controller: _controller.refreshController,
                              footer: CustomFooter(
                                height: 30,
                                builder:
                                    (BuildContext context, LoadStatus mode) {
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                },
                              ),
                              enablePullDown: false,
                              enablePullUp: false,
                              onLoading: () {
                                _controller.getContractsStatus(
                                    _controller.tenantId,
                                    isReload: false);
                              },
                              child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: _controller.contractsStatus.length,
                                padding: EdgeInsets.symmetric(
                                  horizontal: kHorizontalContentPadding,
                                  vertical: 10,
                                ),
                                itemBuilder: (context, index) {
                                  final item =
                                      _controller.contractsStatus[index];
                                  return _buildContractStatusItem(item);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
          bottomNavigationBar: AppBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildContractStatusItem(ContractStatusModel item) {
    return ShadowBox(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.conversationTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (contactType != ContactTypeEnum.OtherService)
                  Text(
                    item != null && item.status != null
                        ? NegotiationStatusType.getName(item.status)
                        : "",
                    style: TextStyle(
                      fontSize: 12,
                      color: kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  )
              ],
            ),
          ),
          if (AuthController.to.currentUser.hasChat)
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.CHAT,
                  arguments: ChatArgument(
                    conversationId: item.conversationId,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  border: Border.all(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                child: Text(
                  LocaleKeys.Shared_Chat.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
