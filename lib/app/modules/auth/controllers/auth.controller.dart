import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/keys.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/repositories/user.repository.dart';
import 'package:agree_n/app/modules/base/controllers/base.controller.dart';
import 'package:agree_n/app/modules/auth/controllers/firebase.controller.dart';

class AuthController extends GetxController {
  final UserRepository repository;

  FireBaseController _fireBaseController = FireBaseController.to;
  BaseController _baseController = BaseController.to;

  AuthController({@required this.repository}) : assert(repository != null);

  static AuthController get to => Get.find<AuthController>();
  final _store = GetStorage();

  Rx<UserModel> _loggedUser = Rx<UserModel>();
  RxBool isLoggedIn = RxBool(false);

  UserModel get currentUser => _loggedUser.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    //Run every time auth state changes
    ever(isLoggedIn, handleAuthChanged);
    await verifyUser();
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> verifyUser() async {
    final storedToken = await _store.read(AppStorageKey.ACCESS_TOKEN);
    if (storedToken != null) {
      try {
        HttpResponse response = await repository.getProfile();
        final UserModel user = UserModel.fromJson(response.body);
        setLoggedUser(user);
      } catch (e) {
        await logout();
      }
    } else {
      await logout();
    }
  }

  Future<void> setLoggedUser(UserModel user) async {
    _loggedUser.value = user;
    isLoggedIn.value = true;
  }

  Future<void> setTokensAndExpiredTime(
      {String accessToken, String refreshToken, int expiredDuration}) async {
    await _store.write(AppStorageKey.ACCESS_TOKEN, accessToken);
    await _store.write(AppStorageKey.REFRESH_TOKEN, refreshToken);
    final expiredTime = new DateTime.now().add(
      Duration(seconds: expiredDuration),
    );
    final expiredTimeString =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(expiredTime);
    await _store.write(AppStorageKey.EXPIRED_TIME, expiredTimeString);
  }

  handleAuthChanged(isLoggedIn) async {
    if (isLoggedIn) {
      // TODO: Need to unsub old user topics
      _fireBaseController.initFirebase(currentUser.id);
      Get.offAllNamed(Routes.DASHBOARD);
      _baseController.getNotification();
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  void updateAvatar(String avatar) {
    _loggedUser.value.imageUrl = avatar;
    update();
  }

  Future<RefreshTokenResponse> refreshToken(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }

  Future<void> logout() async {
    if (currentUser != null) {
      _fireBaseController.unsubscribeFirebaseTopic(currentUser.id);
    }
    await _store.remove(AppStorageKey.ACCESS_TOKEN);
    await _store.remove(AppStorageKey.REFRESH_TOKEN);
    _loggedUser.value = null;
    isLoggedIn.value = false;
  }
}
