import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/settings/version.dart';
import 'package:agree_n/app/settings/app_config.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/base/controllers/base.controller.dart';

class NavigationView extends GetView<AuthController> {
  final BaseController _baseController = BaseController.to;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(),
          Column(
            children: [
              MenuItem(
                name: LocaleKeys.Navigation_Profile.tr,
                icon: Icons.account_circle_sharp,
                onTap: () {
                  Get.toNamed(Routes.PROFILE);
                },
              ),
              if (controller.currentUser != null &&
                  controller.currentUser.hasDirectory)
                MenuItem(
                  name: controller.currentUser.isBuyer
                      ? LocaleKeys.Shared_Directory.tr
                      : LocaleKeys.Shared_Contacts.tr,
                  icon: Icons.contacts_outlined,
                  onTap: () {
                    Get.offNamed(Routes.CONTACTS);
                  },
                ),
              MenuItem(
                name: LocaleKeys.Navigation_Language.tr,
                icon: Icons.language,
                onTap: () {
                  Get.toNamed(Routes.LANGUAGE);
                },
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              _baseController.setDefaultTab();
              controller.logout();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, bottom: 20),
              child: Text(
                LocaleKeys.Navigation_Logout.tr,
                style: TextStyle(
                    fontSize: 16,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Spacer(),
          Text(
            'App version: ${GetPlatform.isAndroid ? AppVersion.ANDROID_VERSION : AppVersion.IOS_VERSION}',
            style: TextStyle(
              fontSize: 12,
              color: kPrimaryGreyColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            kHorizontalContentPadding,
            10,
            kHorizontalContentPadding,
            30,
          ),
          width: double.infinity,
          color: kPrimaryColor,
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
                _buildAvatar(),
                Text(
                  controller.currentUser != null
                      ? controller.currentUser.name
                      : '',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -2,
          left: 0,
          child: Container(
            width: Get.width,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return GetBuilder<AuthController>(
      init: Get.find(),
      builder: (authController) {
        if (controller.currentUser != null)
          return Container(
            height: 80,
            width: 80,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 0.5),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(controller.currentUser.imageUrl ??
                    AppConfig.DEFAULT_USER_AVATAR),
                fit: BoxFit.cover,
              ),
            ),
          );

        return SizedBox();
      },
    );
  }
}

class MenuItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const MenuItem({Key key, this.name, this.onTap, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: kPrimaryBlackColor,
        size: 25,
      ),
      title: Text(
        name,
        style: TextStyle(
            fontSize: 16,
            color: kPrimaryBlackColor,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
