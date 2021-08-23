import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/data/providers/user.provider.dart';
import 'package:agree_n/app/data/repositories/user.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/profile.controller.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: GetBuilder<ProfileController>(
        init: Get.put<ProfileController>(
          ProfileController(
            repository: UserRepository(
              apiClient: UserProvider(),
            ),
          ),
        ),
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (controller.profile == null) {
            return Column(
              children: [
                SafeArea(
                  child: ScreenTitle(
                    title: LocaleKeys.Navigation_Profile.tr,
                    onBack: () {
                      Get.back();
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      LocaleKeys.Profile_ErrorMessage.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: kPrimaryGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(controller),
              _buildForm(controller),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm(ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalContentPadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.Profile_Email.tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              height: 45,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                border: Border.all(color: kPrimaryColor),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(controller.profile.email, style: TextStyle(
                fontSize: 16,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w400,
              ),),
            ),
            Text(
              LocaleKeys.Profile_Phone.tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                controller.updateParam.phoneNumber = number.phoneNumber;
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG
              ),
              onInputValidated: (isValid) {
                controller.isPhoneNumberValid.value = isValid;
              },
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              locale: Get.locale.languageCode,
              formatInput: false,
              hintText: "",
              isEnabled: !controller.isSubmitting.value,
              ignoreBlank: false,
              errorMessage: LocaleKeys.Profile_InvalidPhoneNumber.tr,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              initialValue: controller.phoneNumber,
              inputBorder: OutlineInputBorder(),
            ),
            RoundedButton(
              labelText: controller.isSubmitting.value
                  ? LocaleKeys.Profile_Updating.tr
                  : LocaleKeys.Profile_Update.tr,
              margin: const EdgeInsets.only(top: 20),
              onPressed: () {
                if (controller.isSubmitting.value ||
                    !controller.isPhoneNumberValid.value) {
                  return;
                }
                controller.onUpdateProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileController controller) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
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
                  controller.profile.name,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
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
    return GetBuilder<ProfileController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isUploading.value) {
          return Container(
            height: 80,
            width: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CupertinoActivityIndicator(),
          );
        }
        return Container(
          height: 80,
          width: 80,
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 0.5),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(controller.profile.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              controller.onChangedAvatar();
            },
            child: Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kOfferBackgroundColor,
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 12,
              ),
            ),
          ),
        );
      },
    );
  }
}
