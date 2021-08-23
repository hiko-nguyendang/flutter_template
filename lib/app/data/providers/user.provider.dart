import 'dart:io';
import 'package:get/get.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/user.model.dart';

class UserProvider extends GetConnect {
  Future<HttpResponse> getProfile() async {
    return await HttpHelper.get(Endpoints.USER_PROFILE);
  }

  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final HttpResponse response =
          await HttpHelper.get('${Endpoints.REFRESH_TOKEN}/$refreshToken');
      if (response.statusCode == 200) {
        return RefreshTokenResponse.fromJson(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<HttpResponse> loginUser({String email, String password}) {
    return HttpHelper.post(Endpoints.LOGIN, {
      'username': email,
      'password': password,
      'rememberMe': true,
    });
  }

  Future<HttpResponse> updateProfile(UpdateProfileParam param) async {
    return HttpHelper.post(Endpoints.UPDATE_USER_PROFILE, param);
  }

  Future<String> updateAvatar(File file) async {
    try {
      final result = await HttpHelper.uploadFile(
          '${Endpoints.UPLOAD}/${FileUploadTypeEnum.UserImage}',
          file: file);
      return result.body;
    } catch (e) {
      return null;
    }
  }

  Future<HttpResponse> requestForgotPassword(String email) async {
    final data = {"email": email};
    try {
      return HttpHelper.post(Endpoints.FORGOT_PASSWORD, data);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> resetPassword(ResetPasswordParam param) async {
    try {
      final HttpResponse response =
          await HttpHelper.post(Endpoints.RESET_PASSWORD, param);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
