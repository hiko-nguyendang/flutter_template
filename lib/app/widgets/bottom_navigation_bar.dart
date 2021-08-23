import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/base/controllers/base.controller.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final BaseController _baseController = BaseController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        iconSize: 25,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: LocaleKeys.BottomBar_HomeButton.tr,
          ),
          if (AuthController.to.currentUser != null &&
              AuthController.to.currentUser.hasChat)
            BottomNavigationBarItem(
              icon: Icon(
                Icons.messenger_outline,
                color: Colors.white,
              ),
              activeIcon: Icon(Icons.message),
              label: LocaleKeys.BottomBar_MessageButton.tr,
            ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
                if (_baseController.unreadNotification > 0)
                  Positioned(
                    right: 0,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      width: 12,
                      height: 12,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  )
              ],
            ),
            activeIcon: Stack(
              children: [
                Icon(Icons.notifications),
                if (_baseController.unreadNotification > 0)
                  Positioned(
                    right: 0,
                    child: new Container(
                      padding: EdgeInsets.all(1),
                      width: 12,
                      height: 12,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  )
              ],
            ),
            label: LocaleKeys.BottomBar_AlertButton.tr,
          ),
        ],
        unselectedFontSize: 12,
        selectedFontSize: 12,
        unselectedItemColor: Colors.white,
        currentIndex: _baseController.currentTab,
        selectedItemColor: Colors.white,
        backgroundColor: kPrimaryColor,
        onTap: _baseController.onCurrentTabChanged,
      ),
    );
  }
}
