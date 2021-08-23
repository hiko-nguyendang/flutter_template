import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/repositories/user.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';

class LoginController extends GetxController {
  final AuthController _authController = AuthController.to;
  final UserRepository repository;

  LoginController({@required this.repository}) : assert(repository != null);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.onClose();
  }

  Future<void> loginUser() async {
    final bool hasInternet = await _checkInternetConnection();
    if (hasInternet) {
      MessageDialog.showLoading();
      try {
        final email = emailController.text.trim().toLowerCase();
        final password = passwordController.text.trim();
        //
        HttpResponse response =
            await repository.loginUser(email: email, password: password);
        //
        MessageDialog.hideLoading();
        final LoginResponseModel userResponse =
            LoginResponseModel.fromJson(response.body);
        if (userResponse.userInfo.roleId == UserRoleEnum.Buyer ||
            userResponse.userInfo.roleId == UserRoleEnum.Supplier) {
          await _authController.setLoggedUser(userResponse.userInfo);
          await _authController.setTokensAndExpiredTime(
            accessToken: userResponse.accessToken,
            refreshToken: userResponse.refreshToken,
            expiredDuration: userResponse.expiresIn,
          );
          Get.toNamed(Routes.DASHBOARD);
          passwordController.clear();
        } else {
          _popupInvalidUser();
        }
      } catch (e) {
        MessageDialog.hideLoading();
        _popupInvalidUser();
      }
    } else {
      MessageDialog.showMessage(LocaleKeys.Login_NoInternet.tr);
    }
  }

  void _popupInvalidUser() {
    Get.snackbar(
      LocaleKeys.Login_Failed.tr,
      LocaleKeys.Login_EmailOrPasswordIncorrect.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  }

  Future<bool> _checkInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    final bool hasInternet = result != ConnectivityResult.none;
    return hasInternet;
  }
}
