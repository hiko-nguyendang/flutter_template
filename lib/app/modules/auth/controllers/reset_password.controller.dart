import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/repositories/user.repository.dart';

class ResetPasswordController extends GetxController {
  final UserRepository repository;

  ResetPasswordController({@required this.repository})
      : assert(repository != null);

  RxString verificationCode = ''.obs;
  RxString newPassword = ''.obs;

  Future<void> resetPassword() async {
    MessageDialog.showLoading();
    final param = ResetPasswordParam(
        passwordResetCode: verificationCode.value,
        newPassword: newPassword.value);
    await repository.resetPassword(param).then(
      (response) {
        MessageDialog.hideLoading();
        if (response) {
          Get.offAllNamed(Routes.LOGIN);
        } else {
          MessageDialog.showMessage(LocaleKeys.ForgotPassword_InvalidCode.tr);
        }
      },
    );
  }
}
