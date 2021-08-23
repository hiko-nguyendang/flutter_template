import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/repositories/user.repository.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';

class ProfileController extends GetxController {
  final UserRepository repository;

  ProfileController({@required this.repository}) : assert(repository != null);

  final AuthController _authController = Get.find();
  Rx<UserModel> _profile = Rx<UserModel>();
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool isUploading = false.obs;
  RxBool isPhoneNumberValid = true.obs;
  PhoneNumber phoneNumber = PhoneNumber();
  // List<String> countries = [];
  UpdateProfileParam updateParam = UpdateProfileParam();

  UserModel get profile => _profile.value;

  @override
  void onInit() {
    if (_authController.currentUser != null) {
      _getUserProfile();
    }
    super.onInit();
  }

  Future<void> _getUserProfile() async {
    try {
      isLoading.value = true;
      final HttpResponse response = await repository.getProfile();
      _profile.value = UserModel.fromJson(response.body);
      // countries.add(_profile.value.countryCode);
      if (_profile.value.phoneNumber != null &&
          _profile.value.phoneNumber.isNotEmpty) {
        phoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(
            _profile.value.phoneNumber);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
    update();
  }

  void onUpdateProfile() async {
    try {
      isSubmitting.value = true;
      update();
      HttpResponse response = await repository.updateProfile(updateParam);
      final result = response.body;
      if (!result) {
        MessageDialog.showMessage(LocaleKeys.Profile_UpdateFailMessage.tr);
      } else if (updateParam.imageUrl != null &&
          updateParam.imageUrl.isNotEmpty) {
        _authController.updateAvatar(updateParam.imageUrl);
      }
      isSubmitting.value = false;
      update();
    } catch (e) {
      isSubmitting.value = false;
      update();
      MessageDialog.showMessage(LocaleKeys.Profile_UpdateFailMessage.tr);
    }
  }

  Future<void> onChangedAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (pickedFile != null) {
      isUploading.value = true;
      update();
      final imageUrl = await repository.updateAvatar(File(pickedFile.path));
      if (imageUrl == null) {
        MessageDialog.showMessage(LocaleKeys.Profile_UpdateFailMessage.tr);
      } else {
        updateParam.imageUrl = imageUrl;
        _profile.value.imageUrl = imageUrl;
      }
      isUploading.value = false;
      update();
    }
  }
}
