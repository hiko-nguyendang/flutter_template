import 'package:meta/meta.dart';

//
import 'package:agree_n/app/data/providers/lookup.provider.dart';
import 'package:agree_n/app/data/models/lookup.model.dart';

class LookUpRepository {
  final LookUpProvider apiClient;

  LookUpRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<List<AppLookupModel>> getAppLookUp() async {
    return await apiClient.getAppLookUp();
  }

  Future<WarehouseResultModel> getWarehousesForTenant() async {
    return await apiClient.getWarehousesForTenant();
  }

  Future<List<CropYearModel>>getCropYear() async{
    return await apiClient.getCropYear();
  }

}
