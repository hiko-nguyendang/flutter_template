import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:extended_image/extended_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/search_box.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/data/models/contact.model.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/contract/views/contract_status.view.dart';
import 'package:agree_n/app/modules/contact/controllers/contact.controller.dart';

class ContactsView extends StatelessWidget {
  final AuthController _authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<ContactController>(
        init: Get.find(),
        builder: (contactController) {
          return Column(
            children: [
              ScreenHeader(
                  title: _authController.currentUser != null
                      ? _authController.currentUser.isBuyer
                          ? LocaleKeys.Shared_Directory.tr
                          : LocaleKeys.Shared_Contacts.tr
                      : ''),
              Padding(
                padding: const EdgeInsets.all(kHorizontalContentPadding),
                child: SearchBox(
                  controller: contactController.textController,
                  hintText: LocaleKeys.Contract_SearchHint.tr,
                  onSearch: (keyword) {
                    contactController.getContacts(keyword.trim());
                  },
                ),
              ),
              Expanded(child: _buildContactsList(contactController)),
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildContactsList(ContactController contactController) {
    if (contactController.isLoading.value) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    if (contactController.contacts.isEmpty) {
      return Center(
        child: Text(LocaleKeys.Contact_contactEmpty.tr),
      );
    }
    return SmartRefresher(
      controller: contactController.refreshController,
      footer: LoadingBottomWidget(),
      enablePullDown: false,
      enablePullUp: contactController.hasMore.value,
      onRefresh: () {
        // contactController.getContacts(null);
      },
      onLoading: () {
        contactController.getContacts(null, isReload: false);
      },
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: contactController.contacts.length,
        padding: EdgeInsets.symmetric(
          horizontal: kHorizontalContentPadding,
          vertical: 10,
        ),
        itemBuilder: (context, index) {
          final item = contactController.contacts[index];
          return _buildContactItem(item, contactController);
        },
      ),
    );
  }

  Widget _buildContactItem(
      ContactModel item, ContactController contactController) {
    return ShadowBox(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: kPrimaryGreyColor.withOpacity(0.5),
            child: item.avatarUrl == null
                ? Text(
                    "${item.firstName[0]}${item.lastName[0]}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: ExtendedImage.network(
                      item.avatarUrl,
                      fit: BoxFit.cover,
                      width: Get.width,
                      height: Get.height,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return CircularProgressIndicator();
                            break;
                          case LoadState.completed:
                            return state.completedWidget;
                            break;
                          default:
                            return Center(
                              child: Text(
                                "${item.firstName[0]}${item.lastName[0]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: Get.width * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.contactName,
                  style: TextStyle(
                    fontSize: 14,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    launch("tel://${item.phoneNumber}");
                  },
                  child: Text(
                    item.phoneNumber,
                    style: TextStyle(
                      fontSize: 13,
                      color: kPrimaryBlueColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  item.emailAddress ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: kPrimaryGreyColor,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.address ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: kPrimaryGreyColor,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                if (_authController.currentUser.hasChat)
                  GestureDetector(
                    onTap: () {
                      contactController.onChat(item);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: EdgeInsets.only(bottom: 5),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        LocaleKeys.Shared_Chat.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => ContractStatusView(
                        contactType: item.tenantId,
                      ),
                      arguments: item.tenantId,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      border: Border.all(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      item.tenantId == ContactTypeEnum.OtherService
                          ? LocaleKeys.Shared_CheckOffers.tr
                          : LocaleKeys.Shared_CheckStatus.tr,
                      textAlign: TextAlign.center,
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
          )
        ],
      ),
    );
  }
}
