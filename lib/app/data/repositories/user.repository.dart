import 'dart:io';
import 'package:meta/meta.dart';

import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/providers/user.provider.dart';
import 'package:agree_n/app/utils/http_utils.dart';

class UserRepository {
  final UserProvider apiClient;

  UserRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<HttpResponse> getProfile() async {
    return apiClient.getProfile();
  }

  Future<RefreshTokenResponse> refreshToken(String token) {
    return apiClient.refreshToken(token);
  }

  Future<HttpResponse> updateProfile(UpdateProfileParam param) {
    return apiClient.updateProfile(param);
  }

  Future<String> updateAvatar(File file) {
    return apiClient.updateAvatar(file);
  }

  Future<HttpResponse> loginUser({String email, String password}) {
    return apiClient.loginUser(
      email: email,
      password: password,
    );
  }

  Future<HttpResponse> requestForgotPassword(String email) {
    return apiClient.requestForgotPassword(email);
  }

  Future<bool> resetPassword(ResetPasswordParam param) {
    return apiClient.resetPassword(param);
  }
}
