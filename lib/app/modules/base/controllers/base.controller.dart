import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/constants/constants.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/settings/keys.dart';
import 'package:agree_n/app/settings/app_config.dart';
import 'package:agree_n/app/data/repositories/base.repository.dart';

class BaseController extends GetxController {
  final BaseRepository repository;

  BaseController({@required this.repository}) : assert(repository != null);

  static BaseController get to => Get.find();

  final _store = GetStorage();
  RxString _language = "".obs;
  RxInt currentTabIndex = BottomMenuEnum.HomeTab.obs;
  RxInt _unreadNotification = 0.obs;

  int get unreadNotification => _unreadNotification.value;

  int get currentTab => currentTabIndex.value;

  String get currentLanguage => _language.value;

  @override
  void onInit() {
    _setInitialLocalLanguage();
    super.onInit();
  }

  _setInitialLocalLanguage() {
    String locate = _store.read<String>(AppStorageKey.LANGUAGE);
    if (locate == '' || locate == null) {
      locate = Get.deviceLocale.languageCode;
    }
    _language.value = locate;
    updateLanguage(locate);
  }

  Locale get getLocale {
    if (currentLanguage == '' || currentLanguage == null) {
      _language.value = AppConfig.DEFAULT_LANGUAGE;
      updateLanguage(AppConfig.DEFAULT_LANGUAGE);
    }
    final Locale locale =
        SUPPORTED_LOCALES.firstWhere((l) => l.languageCode == currentLanguage);
    return locale;
  }

  Future<void> updateLanguage(String value) async {
    _language.value = value;
    await _store.write(AppStorageKey.LANGUAGE, value);
    Get.updateLocale(getLocale);
    update();
  }

  void setDefaultTab() {
    currentTabIndex.value = BottomMenuEnum.HomeTab;
  }

  void onCurrentTabChanged(int tabIndex) {
    currentTabIndex.value = tabIndex;
    switch (tabIndex) {
      case BottomMenuEnum.HomeTab:
        Get.offNamed(Routes.DASHBOARD);
        break;
      case BottomMenuEnum.ChatTab:
        Get.offNamed(Routes.CONVERSATIONS);
        break;
      case BottomMenuEnum.NotificationTab:
        Get.offNamed(Routes.NOTIFICATION);
        break;
    }
  }

  Future<void> getNotification() async {
    await repository
        .getNotifications(PaginationParam(pageSize: 10, pageNumber: 1))
        .then(
      (response) {
        _unreadNotification.value = response.numberOfUnread;
        update();
      },
    );
  }

  void updateUnreadNotification() {
    _unreadNotification.value += 1;
    update();
  }

  void resetUnreadNotification() {
    _unreadNotification.value = 0;
    update();
  }
}
