import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/models/contact.model.dart';
import 'package:agree_n/app/data/repositories/contact.repository.dart';

class ContactRateController extends GetxController {
  final ContactRepository repository;

  Rx<ContactRateModel> contactRate = Rx<ContactRateModel>();
  RxBool isLoading = false.obs;

  ContactRateController({@required this.repository})
      : assert(repository != null);

  @override
  void onInit() {
    ContactArgument arg = Get.arguments;
    getTenant(arg.contactId);
    super.onInit();
  }

  Future getTenant(int contactId) async {
    //TODO: Call API Get Contact Rate
    isLoading.value = true;
    try {
      await repository.getContactRate(contactId).then((response) {
        if (response.statusCode == APIStatus.Successfully) {
          final extractData = json.decode(response.body);
          if (extractData != null) {
            final result = ContactRateModel.fromJson(extractData);
            contactRate.value = result;
            isLoading.value = false;
          }
        }
      });
    } catch (e) {
      isLoading.value = false;
      MessageDialog.showError(message: LocaleKeys.Shared_ErrorMessage.tr);
      throw e;
    }
    update();
  }
}
