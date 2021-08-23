import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/models/contact.model.dart';
import 'package:agree_n/app/data/repositories/contact.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';

class ContactController extends GetxController {
  ContactRepository repository;

  ContactController({@required this.repository}) : assert(repository != null);

  static ContactController to = Get.find();

  TextEditingController textController = TextEditingController();
  RxList<ContactModel> contacts = RxList<ContactModel>([]);
  RefreshController refreshController = RefreshController();
  RxBool isLoading = false.obs;
  RxBool hasMore = false.obs;
  RxInt _totalCount = 0.obs;

  Rx<ContactParamModel> _contactParam = ContactParamModel().obs;

  @override
  void onInit() {
    setContactFilterType();
    getContacts(null);
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void setContactFilterType() {
    if (AuthController.to.currentUser.isBuyer) {
      _contactParam.value.contactFilterTypeId = UserRoleEnum.Buyer;
    } else {
      _contactParam.value.contactFilterTypeId = UserRoleEnum.Supplier;
    }
  }

  Future<void> getContacts(String keyword, {bool isReload = true}) async {
    _contactParam.value.keyword = keyword;
    if (isReload) {
      isLoading.value = true;
      if(contacts.isNotEmpty){
        contacts.clear();
      }
      _contactParam.value.pageNumber = 1;
      update();
    }
    await repository.getContacts(_contactParam.value).then(
      (response) {
        if (response != null) {
          _totalCount.value = response.totalCount;
          contacts.addAll(response.objects);
          _contactParam.value.pageNumber += 1;
          _checkHasMore();
          refreshController.loadComplete();
        }
        isLoading.value = false;
        update();
      },
    );
  }

  void _checkHasMore() {
    hasMore.value = _totalCount.value > contacts.length;
    update();
  }

  void onChat(ContactModel contact) async {
    await repository.getConversation(contact.tenantId).then(
      (response) {
        if (response != null) {
          Get.toNamed(
            Routes.CHAT,
            arguments: ChatArgument(
              conversationTypeId: ConversationTypeEnum.SimpleNegotiation,
              contactId: contact.tenantId,
              conversationName: contact.companyName,
              conversationId: response.conversationId,
            ),
          );
        }
      },
    );
  }
}
