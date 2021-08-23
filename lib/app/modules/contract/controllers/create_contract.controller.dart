import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/models/lookup.model.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/contract/views/buyer_submit_contract.view.dart';

class CreateContractController extends GetxController {
  final ContractRepository repository;

  CreateContractController({@required this.repository})
      : assert(repository != null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController certificatePremiumTextController =
      TextEditingController();

  Rx<CreateContractModel> contractParam = CreateContractModel(
    quantityUnitTypeId: LookUpController.to.quantityUnits.defaultValue,
    coffeeTypeId: LookUpController.to.coffeeTypes.defaultValue,
    commodityTypeId: LookUpController.to.commodities.defaultValue,
    cropYear: LookUpController.to.cropYears.first.cropYear,
  ).obs;
  RxList<LookupOptionModel> grades = RxList<LookupOptionModel>();
  RxList<SupplierModel> suppliers = RxList<SupplierModel>();
  RxList<SupplierModel> suppliersClone = RxList<SupplierModel>();
  RxList<BaseModel> coverMonths = RxList<BaseModel>();

  RxBool isSubmit = false.obs;
  RxBool isLoading = false.obs;
  RxString priceSymbol = "+".obs;
  RxBool coverMonthLoading = false.obs;
  RxString cropYearName = LookUpController.to.cropYears.first.cropYearName.obs;

  CreateContractModel get createContractParam => contractParam.value;

  @override
  void onInit() {
    _filterGradeByCommodity(createContractParam.commodityTypeId);
    _getSuppliers();
    _getCoverMonth(createContractParam.commodityTypeId);
    super.onInit();
  }

  Future<void> _getCoverMonth(int commodityId) async {
    coverMonthLoading.value = true;
    await repository.getCoverMonth(commodityId).then(
      (response) {
        coverMonthLoading.value = false;
        if (response != null) {
          coverMonths.clear();
          coverMonths.addAll(response);
        }
      },
    );
    update();
  }

  void _filterGradeByCommodity(int commodity) {
    grades.clear();
    if (TermName.commodityName(commodity) ==
        LocaleKeys.TermOptionName_Arabica.tr) {
      grades.addAll(LookUpController.to.grades.values.where((_) =>
          _.id == 12 ||
          _.id == 16 ||
          _.id == 17 ||
          _.id == 20 ||
          _.id == 23 ||
          _.id == 27 ||
          _.id == 28 ||
          _.id == 29 ||
          _.id == 30 ||
          _.id == 31 ||
          _.id == 32 ||
          _.id == 33 ||
          _.id == 34 ||
          _.id == 35));
    } else {
      grades.addAll(LookUpController.to.grades.values.where((_) =>
          _.id == 10 ||
          _.id == 11 ||
          _.id == 13 ||
          _.id == 14 ||
          _.id == 15 ||
          _.id == 18 ||
          _.id == 19 ||
          _.id == 21 ||
          _.id == 22 ||
          _.id == 24 ||
          _.id == 26 ||
          _.id == 25 ||
          _.id == 36 ||
          _.id == 37 ||
          _.id == 38 ||
          _.id == 39));
    }
    update();
  }

  Future<void> _getSuppliers() async {
    isLoading.value = true;
    await repository.getSuppliers().then((response) {
      suppliers.addAll(response);
      isLoading.value = false;
      suppliersClone = suppliers;
    });
    update();
  }

  void onSelectSupplier(SupplierModel supplierModel) {
    suppliers = suppliersClone;
    createContractParam.supplierName = supplierModel.name;
    createContractParam.supplierId = supplierModel.supplierId;
    update();
  }

  void onContractTypeChanged(int contractType) {
    createContractParam.contractTypeId = contractType;

    if (TermName.contractTypeName(contractType) ==
        LocaleKeys.TermOptionName_Outright.tr) {
      createContractParam.priceUnitTypeId = LookUpController
          .to.priceUnits.values
          .firstWhere(
              (_) => _.termOptionName == LocaleKeys.TermOptionName_VNDKG.tr)
          .id;
    } else {
      if (TermName.commodityName(createContractParam.commodityTypeId) ==
          LocaleKeys.TermOptionName_Arabica.tr) {
        createContractParam.priceUnitTypeId = LookUpController
            .to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_CTLB.tr)
            .id;
      } else {
        createContractParam.priceUnitTypeId = LookUpController
            .to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_USDMT.tr)
            .id;
      }
    }
    update();
  }

  void onTypeChanged(int id) {
    createContractParam.coffeeTypeId = id;
    update();
  }

  void selectDeliveryDate(BuildContext context) async {
    final deliveryDate =
        await _showDatePicker(context, createContractParam.deliveryDate);
    if (deliveryDate != null) {
      createContractParam.deliveryDate = deliveryDate;
    }
    update();
  }

  Future<DateTime> _showDatePicker(BuildContext context, DateTime initDate) {
    return showRoundedDatePicker(
      context: context,
      locale: Locale(Get.locale.languageCode),
      initialDate: _getInitDate(initDate),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      height: Get.height * 0.4,
      borderRadius: 16,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColor,
        accentTextTheme: TextTheme(
          caption: TextStyle(color: kPrimaryColor),
        ),
      ),
    );
  }

  DateTime _getInitDate(DateTime date) {
    if (date == null || date.isBefore(DateTime.now())) {
      return DateTime.now();
    } else {
      return date;
    }
  }

  void onSelectQuality(int quality) {
    createContractParam.gradeTypeId = quality;
    final gradeName = TermName.gradeName(quality);
    if (gradeName == LocaleKeys.TermOptionName_R45FAQ32GL.tr ||
        gradeName == LocaleKeys.TermOptionName_R45FAQ.tr) {
      createContractParam.packingUnitTypeId = LookUpController
          .to.packingUnitCodes.values
          .firstWhere((_) =>
              TermName.packingUnitName(_.id) == LocaleKeys.TermOptionName_PP.tr)
          .id;
    } else {
      createContractParam.packingUnitTypeId = null;
    }
    update();
  }

  void onSelectPackingUnitCode(int packingUnitCode) {
    createContractParam.packingUnitTypeId = packingUnitCode;
    update();
  }

  void onCoverMonthChanged(String coverMonthCode) {
    createContractParam.coverMonth = coverMonthCode;
    update();
  }

  void onSelectCertification(int certification) {
    createContractParam.certificationTypeId = certification;
    if (TermName.certificationName(createContractParam.certificationTypeId) ==
        LocaleKeys.TermOptionName_None.tr) {
      createContractParam.certificationPremium = 0;
      certificatePremiumTextController.text = '';
    }
    update();
  }

  void onLocationChanged(int location) {
    createContractParam.deliveryWarehouseId = location;
    update();
  }

  void onSelectCommodity(int commodity) {
    createContractParam.commodityTypeId = commodity;
    _filterGradeByCommodity(commodity);

    if (TermName.contractTypeName(createContractParam.contractTypeId) !=
        LocaleKeys.TermOptionName_Outright.tr) {
      if (TermName.commodityName(commodity) ==
          LocaleKeys.TermOptionName_Arabica.tr) {
        createContractParam.priceUnitTypeId = LookUpController
            .to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_CTLB.tr)
            .id;
      } else {
        createContractParam.priceUnitTypeId = LookUpController
            .to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_USDMT.tr)
            .id;
      }
    }
    update();
    _getCoverMonth(commodity);
  }

  void onQuantityUnitChanged(int quantityUnit) {
    createContractParam.quantityUnitTypeId = quantityUnit;
    update();
  }

  void onCreate() {
    isSubmit.value = true;
    formKey.currentState.validate();
    if (formKey.currentState.validate() &&
        createContractParam.contractTypeId != null &&
        createContractParam.supplierId != null &&
        createContractParam.deliveryDate != null &&
        createContractParam.price != null &&
        createContractParam.packingUnitTypeId != null &&
        createContractParam.quantity != null &&
        createContractParam.deliveryWarehouseId != null) {
      final isNumberValid = _validateNumberInput();
      if (isNumberValid) {
        if (TermName.contractTypeName(createContractParam.contractTypeId) ==
            LocaleKeys.ContractType_Outright.tr) {
          _createContract();
        } else {
          if (createContractParam.coverMonth != null) {
            _createContract();
          }
        }
      }
    }

    update();
  }

  Future<void> _createContract() async {
    MessageDialog.showLoading();
    try {
      await repository.createContract(createContractParam).then(
        (response) {
          MessageDialog.hideLoading();
          if (response.body != null) {
            Get.back();
            Get.to(
              () => BuyerSubmitContractView(),
              arguments: ContractArgument(
                contractNumber: createContractParam.contractNumber,
                pdfUrl: response.body,
              ),
            );
          } else {
            MessageDialog.showMessage(LocaleKeys.Shared_ErrorMessage.tr);
          }
        },
      );
    } catch (e) {
      MessageDialog.hideLoading();
      MessageDialog.showError();
      throw e;
    }
  }

  bool _validateNumberInput() {
    if (TermName.contractTypeName(createContractParam.contractTypeId) !=
        LocaleKeys.ContractType_Outright.tr) {
      if (createContractParam.quantity <= 0 ||
          createContractParam.packingQuantity <= 0 ||
          createContractParam.price <= 0) {
        MessageDialog.showMessage(LocaleKeys.CreateOffer_NumberInvalid.tr);
        return false;
      } else {
        return true;
      }
    } else {
      if (createContractParam.quantity <= 0 ||
          createContractParam.packingQuantity <= 0 ||
          createContractParam.price <= 0) {
        MessageDialog.showMessage(LocaleKeys.CreateOffer_NumberInvalid.tr);
        return false;
      } else {
        return true;
      }
    }
  }

  void searchSupplierName(String keyWord) {
    if (keyWord == null || keyWord.isEmpty) {
      suppliers = suppliersClone;
    } else {
      final cloneList = suppliersClone;
      List<SupplierModel> searchResult = [];
      for (var item in cloneList) {
        if (item.name.toUpperCase().contains(keyWord.toUpperCase())) {
          searchResult.add(item);
        }
      }
      suppliers = searchResult.obs;
    }
    update();
  }

  void onSelectedCropYear(String cropYear) {
    cropYearName.value = cropYear;
    contractParam.value.cropYear = cropYear.split("-").last;
    update();
  }

  void onSymbolChanged(text) {
    priceSymbol.value = text;
    update();
  }
}
