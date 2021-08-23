import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/repositories/user.repository.dart';
import 'package:agree_n/app/modules/auth/views/reset_password.view.dart';

class ForgotPasswordController extends GetxController {
  final UserRepository repository;

  ForgotPasswordController({@required this.repository})
      : assert(repository != null);

  RxString email = ''.obs;

  void forgotPassword(String email) async {
    try {
      MessageDialog.showLoading();
      await repository.requestForgotPassword(email).then(
        (response) {
          MessageDialog.hideLoading();
          if (response.body != null) {
            final result = response.body;
            if (result) {
              MessageDialog.showMessage(
                LocaleKeys.ForgotPassword_RequestSuccess.tr,
                onClosed: () {
                  Get.back();
                  Get.to(() => ResetPasswordView());
                },
              );
            } else {
              MessageDialog.showMessage(
                  LocaleKeys.ForgotPassword_RequestFail.tr);
            }
          }
        },
      );
    } catch (e) {
      MessageDialog.hideLoading();
      MessageDialog.showMessage(LocaleKeys.Shared_ErrorMessage.tr);
    }
  }
}
