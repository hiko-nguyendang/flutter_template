import 'package:get/get.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/data/models/lookup.model.dart';
import 'package:agree_n/app/data/repositories/lookup.repository.dart';

class LookUpController extends GetxController {
  final LookUpRepository repository;

  LookUpController({this.repository}) : assert(repository != null);

  static LookUpController to = Get.find();

  //Mock data
  List<CoverMonthModel> coverMonths = [
    CoverMonthModel(id: 1, name: 'F/2021'),
    CoverMonthModel(id: 2, name: 'H/2021'),
    CoverMonthModel(id: 3, name: 'K/2021'),
    CoverMonthModel(id: 4, name: 'N/2021'),
    CoverMonthModel(id: 5, name: 'U/2021'),
    CoverMonthModel(id: 6, name: 'X/2021'),
    CoverMonthModel(id: 7, name: 'Z/2021'),
  ];
  List<WarehouseModel> locations = [];
  List<CropYearModel> cropYears = [];

  AppLookupModel grades;
  AppLookupModel commodities;
  AppLookupModel contractTypes;
  AppLookupModel coffeeTypes;
  AppLookupModel quantityUnits;
  AppLookupModel certifications;
  AppLookupModel deliveryTerms;
  AppLookupModel packingUnitCodes;
  AppLookupModel priceUnits;
  List<LookupOptionModel> coverMonthCodes = [
    LookupOptionModel(id: 1, displayName: CoverMonthEnum.F),
    LookupOptionModel(id: 3, displayName: CoverMonthEnum.H),
    LookupOptionModel(id: 5, displayName: CoverMonthEnum.K),
    LookupOptionModel(id: 7, displayName: CoverMonthEnum.N),
    LookupOptionModel(id: 9, displayName: CoverMonthEnum.U),
    LookupOptionModel(id: 11, displayName: CoverMonthEnum.X),
    LookupOptionModel(id: 12, displayName: CoverMonthEnum.Z),
  ];

  @override
  void onInit() async {
    _getWarehousesForTenant();
    _getAppLookUpData();
    _getCropYear();
    super.onInit();
  }

  Future<void> _getCropYear() async {
    await repository.getCropYear().then((result) => cropYears = result);
  }

  Future<void> _getWarehousesForTenant() async {
    await repository.getWarehousesForTenant().then(
          (response) {
        if (response != null) {
          locations = response.warehouses;
        }
      },
    );
  }

  Future<void> _getAppLookUpData() async {
    await repository.getAppLookUp().then(
          (value) {
        grades = value.firstWhere(
              (element) => element.name == TermNameEnum.GradeType,
        );
        packingUnitCodes = value.firstWhere(
              (element) => element.name == TermNameEnum.PackingUnitType,
        );
        quantityUnits = value.firstWhere(
                (element) => element.name == TermNameEnum.QuantityUnitType);
        deliveryTerms = value
            .firstWhere((element) => element.name == TermNameEnum.DeliveryTerm);
        certifications = value.firstWhere(
                (element) => element.name == TermNameEnum.CertificationType);
        commodities = value.firstWhere(
                (element) => element.name == TermNameEnum.CommodityType);
        contractTypes = value
            .firstWhere((element) => element.name == TermNameEnum.ContractType);
        coffeeTypes = value
            .firstWhere((element) => element.name == TermNameEnum.CoffeeType);
        packingUnitCodes = value.firstWhere(
                (element) => element.name == TermNameEnum.PackingUnitType);
        priceUnits = value.firstWhere(
                (element) => element.name == TermNameEnum.PriceUnitType);
      },
    );
  }
}
