import 'package:get/get.dart';

import 'package:agree_n/app/settings/endpoints.dart';
import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/data/models/lookup.model.dart';

class LookUpProvider extends GetConnect {
  Future<List<AppLookupModel>> getAppLookUp() async {
    try {
      final response = await HttpHelper.get(Endpoints.LOOK_UP);
      List<AppLookupModel> result = response.body
          .map<AppLookupModel>((item) => AppLookupModel.fromJson(item))
          .toList();
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<WarehouseResultModel> getWarehousesForTenant() async {
    try {
      final response = await HttpHelper.get("${Endpoints.TENANT_WAREHOUSE}");
      final WarehouseResultModel result =
          WarehouseResultModel.fromJson(response.body);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<List<CropYearModel>> getCropYear() async {
    try {
      final response = await HttpHelper.get("${Endpoints.CROP_YEAR}");
      List<CropYearModel> result = response.body
          .map<CropYearModel>((item) => CropYearModel.fromJson(item))
          .toList();
      return result;
    } catch (e) {
      return null;
    }
  }
}
