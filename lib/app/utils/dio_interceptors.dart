import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity/connectivity.dart';

import 'package:agree_n/app/settings/keys.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';

class DioInterceptors extends InterceptorsWrapper {
  final Dio _dio;
  final _store = GetStorage();
  final AuthController _authController = AuthController.to;
  String _accessToken;

  DioInterceptors(this._dio);

  @override
  Future onRequest(RequestOptions options) async {
    final bool hasInternet = await _checkInternetConnection();
    if(hasInternet){
      if (!options.path.contains("refresh")) {
        _getToken(options);
      }

      options.headers.addAll({
        HttpHeaders.authorizationHeader:
        '${AppStorageKey.TOKEN_TYPE} $_accessToken'
      });
    }else{
      MessageDialog.showMessage(LocaleKeys.Login_NoInternet.tr);
      return;
    }

    return options;
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError dioError) async {
    super.onError(dioError);
  }

  Future<void> _getToken(RequestOptions options) async {
    String accessToken = _store.read(AppStorageKey.ACCESS_TOKEN);
    if (accessToken == null) return '';
    String expiredTimeString = _store.read(AppStorageKey.EXPIRED_TIME);
    DateTime expiredTime = DateTime.parse(expiredTimeString);
    //If not active for 3 days logout
    if (DateTime.now().difference(expiredTime).inMinutes > 4320) {
      _authController.logout();
      return;
    }
    if (DateTime.now().isAfter(expiredTime)) {
      await _refreshTokenAndRecallApi(options);
    } else {
      _accessToken = accessToken;
    }
  }

  Future<void> _refreshTokenAndRecallApi(RequestOptions options) async {
    _dio.interceptors.requestLock.lock();
    _dio.interceptors.responseLock.lock();
    try {
      String refreshToken = _store.read(AppStorageKey.REFRESH_TOKEN) ?? '';
      final RefreshTokenResponse tokenData =
          await _authController.refreshToken(refreshToken);
      await _store.write(AppStorageKey.ACCESS_TOKEN, tokenData.accessToken);
      await _store.write(AppStorageKey.REFRESH_TOKEN, tokenData.refreshToken);
      final expiredTime =
          new DateTime.now().add(Duration(seconds: tokenData.expiresIn));
      final expiredTimeString =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(expiredTime);
      await _store.write(AppStorageKey.EXPIRED_TIME, expiredTimeString);
      _accessToken = tokenData.accessToken;
      //Recall api before refresh token
      options.headers.addAll({
        HttpHeaders.authorizationHeader:
            '${AppStorageKey.TOKEN_TYPE} $_accessToken'
      });
      _dio.request(options.path, options: options);
    } catch (e) {
      _authController.logout();
    }
    _dio.interceptors.requestLock.unlock();
    _dio.interceptors.responseLock.unlock();
  }

  Future<bool> _checkInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    final bool hasInternet = result != ConnectivityResult.none;
    return hasInternet;
  }
}
