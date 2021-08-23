import 'package:flutter/material.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';

class DashboardRepository {
  final DashboardProvider apiClient;

  DashboardRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<HttpResponse> getDashboardData() {
    return apiClient.getDashboardData();
  }

  Future<HttpResponse> getMarketPrice() {
    return apiClient.getMarketPrice();
  }

  Future<List<ExchangeRateModel>> getCurrency() {
    return apiClient.getCurrency();
  }

  Future<HttpResponse> postMarketPulse(String message) {
    return apiClient.postMarketPulse(message);
  }

  Future<HttpResponse> getAllMarketPulse(PaginationParam param) {
    return apiClient.getAllMarketPulse(param);
  }

  Future<HttpResponse> getLatestMarketPulse() {
    return apiClient.getLatestMarketPulse();
  }

  Future<HttpResponse> deleteMarketPulse(int id) {
    return apiClient.deleteMarketPulse(id);
  }

  Future<HttpResponse> updateMarketPulseDetail(MarketPulseModel param) {
    return apiClient.updateMarketPulse(param);
  }

  Future<List<WeatherModel>> getWeather() async {
    return await apiClient.getWeather();
  }
}
