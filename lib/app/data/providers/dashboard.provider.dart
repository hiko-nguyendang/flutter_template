import 'dart:convert';
import 'package:get/get.dart';
import 'package:xml2json/xml2json.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';

class DashboardProvider extends GetConnect {
  Future<HttpResponse> getDashboardData() async {
    return HttpHelper.get(Endpoints.DASHBOARD);
  }

  Future<HttpResponse> getMarketPrice() async {
    return await HttpHelper.get(
        'http://api.giacaphe.net/quote?key=baZ2DyPaNSul0Bxq&sub=y&styl=2');
  }

  Future<List<ExchangeRateModel>> getCurrency() async {
    try {
      final a = await HttpHelper.get(
          "https://portal.vietcombank.com.vn/Usercontrols/TVPortal.TyGia/pXML.aspx?b=68");
      final myTransformer = Xml2Json();
      myTransformer.parse(a.body);
      final jsonString = myTransformer.toGData();
      final MarketRateModel result =
          MarketRateModel.fromJson(json.decode(jsonString));
      return result.ExrateList.Exrate;
    } catch (e) {
      return null;
    }
  }

  Future<HttpResponse> postMarketPulse(String message) async {
    final param = {"message": message};
    return HttpHelper.post(Endpoints.MARKET_PULSE, param);
  }

  Future<HttpResponse> getAllMarketPulse(PaginationParam param) async {
    return HttpHelper.get(
        "${Endpoints.MARKET_PULSE}/?pageSize=${param.pageSize}&pageIndex=${param.pageNumber}");
  }

  Future<HttpResponse> getLatestMarketPulse() async {
    return HttpHelper.get(Endpoints.LATEST_MARKET_PULSE);
  }

  Future<HttpResponse> deleteMarketPulse(int id) async {
    return HttpHelper.delete('${Endpoints.MARKET_PULSE}/$id');
  }

  Future<HttpResponse> updateMarketPulse(MarketPulseModel param) async {
    final updateParam = {"message": param.message};
    return HttpHelper.put('${Endpoints.MARKET_PULSE}/${param.id}', updateParam);
  }

  Future<List<WeatherModel>> getWeather() async {
    try {
      final response =
          await HttpHelper.get("${Endpoints.DASHBOARD}/weather-images");
      final List<WeatherModel> result = response.body
          .map<WeatherModel>((_) => WeatherModel.fromJson(_))
          .toList();
      return result;
    } catch (e) {
      return null;
    }
  }
}
