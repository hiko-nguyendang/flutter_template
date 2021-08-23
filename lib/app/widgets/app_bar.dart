import 'package:flutter/material.dart';
import 'package:get/get.dart';

//
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';

class AppBarWidget extends StatelessWidget {
  final AuthController authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalContentPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAvatar(),
          SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                if (authController.currentUser != null)
                  Flexible(
                    child: Text(
                      LocaleKeys.AppBar_Title.trParams({
                        'user_name': authController.currentUser.name,
                      }),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    authController.currentUser != null &&
                            authController.currentUser.isSupplier
                        ? '"${LocaleKeys.Shared_Supplier.tr}"'
                        : '"${LocaleKeys.Shared_Buyer.tr}"',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (ModalRoute.of(context).settings.name == Routes.CONTACTS) {
                Get.offAndToNamed(Routes.NAVIGATION);
              } else {
                Get.toNamed(Routes.NAVIGATION);
              }
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(
                Icons.settings,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return GetBuilder<AuthController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.currentUser == null) {
          return SizedBox();
        }
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.PROFILE);
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 0.5),
              image: DecorationImage(
                image: NetworkImage(controller.currentUser.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
