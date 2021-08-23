import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/lookup.model.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/models/share.model.dart';
import 'package:agree_n/app/data/repositories/offer.repository.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';

class CreateOfferController extends GetxController {
  final OfferRepository repository;

  CreateOfferController({@required this.repository})
      : assert(repository != null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //
  Rx<OfferModel> _offerParam = OfferModel(
    isFavoriteOffer: false,
    priceUnitTypeId: LookUpController.to.priceUnits.defaultValue,
    quantityUnitTypeId: LookUpController.to.quantityUnits.defaultValue,
    coffeeTypeId: LookUpController.to.coffeeTypes.defaultValue,
    commodityId: LookUpController.to.commodities.defaultValue,
  ).obs;
  RxList<LookupOptionModel> grades = RxList<LookupOptionModel>();
  RxList<BaseModel> coverMonths = RxList<BaseModel>();

  RxBool isEdit = false.obs;
  RxBool isSubmit = false.obs;
  RxBool isLoading = false.obs;
  RxString priceSymbol = "+".obs;
  RxBool coverMonthLoading = false.obs;
  List<int> audiences = AudienceEnum.listAudiences;

  OfferModel get createOfferParam => _offerParam.value;

  @override
  void onInit() {
    final int offerId = Get.arguments;
    _filterGradeByCommodity(createOfferParam.commodityId);
    if (offerId != null) {
      isEdit.value = true;
      _getOfferDetail(offerId);
    }
    _getCoverMonth(createOfferParam.commodityId);
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

  Future<void> _getOfferDetail(int offerId) async {
    isLoading.value = true;
    await repository.getOfferDetail(offerId).then(
      (response) {
        isLoading.value = false;
        _offerParam.value = response;
        _offerParam.value.price = _offerParam.value.price.abs();
      },
    );
    update();
  }

  void onUnitChanged(int unit) {
    createOfferParam.quantityUnitTypeId = unit;
    update();
  }

  void onGradeChanged(int grade) {
    createOfferParam.gradeTypeId = grade;
    final gradeName = TermName.gradeName(grade);
    if (gradeName == LocaleKeys.TermOptionName_R45FAQ32GL.tr ||
        gradeName == LocaleKeys.TermOptionName_R45FAQ.tr) {
      createOfferParam.packingUnitTypeId = LookUpController
          .to.packingUnitCodes.values
          .firstWhere((_) =>
              TermName.packingUnitName(_.id) == LocaleKeys.TermOptionName_PP.tr)
          .id;
    } else {
      createOfferParam.packingUnitTypeId = null;
    }
    update();
  }

  void onContractTypeChanged(int contractType) {
    createOfferParam.contractTypeId = contractType;

    if (TermName.contractTypeName(contractType) ==
        LocaleKeys.TermOptionName_Outright.tr) {
      createOfferParam.priceUnitTypeId = LookUpController.to.priceUnits.values
          .firstWhere(
              (_) => _.termOptionName == LocaleKeys.TermOptionName_VNDKG.tr)
          .id;
    } else {
      if (TermName.commodityName(createOfferParam.commodityId) ==
          LocaleKeys.TermOptionName_Arabica.tr) {
        createOfferParam.priceUnitTypeId = LookUpController.to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_CTLB.tr)
            .id;
      } else {
        createOfferParam.priceUnitTypeId = LookUpController.to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_USDMT.tr)
            .id;
      }
    }
    update();
  }

  void onCoverMonthChanged(String coverMonthCode) {
    createOfferParam.coverMonth = coverMonthCode;
    update();
  }

  void onAudienceChanged(int audience) {
    createOfferParam.audienceTypeId = audience;
    update();
  }

  void onDeliveryTermChanged(int deliveryTerm) {
    createOfferParam.deliveryTermId = deliveryTerm;
    update();
  }

  Future onSelectDeliveryDate(BuildContext context) async {
    final deliveryDate = await _showDatePicker(context);
    if (deliveryDate != null) {
      createOfferParam.deliveryDate = deliveryDate;
    }
    update();
  }

  void onTypeChanged(int type) {
    createOfferParam.coffeeTypeId = type;
    update();
  }

  void onLocationChanged(int location) {
    createOfferParam.deliveryWarehouseId = location;
    update();
  }

  void onCurrencyChanged(int priceUnit) {
    createOfferParam.priceUnitTypeId = priceUnit;
    update();
  }

  void onSelectCommodity(int commodity) {
    createOfferParam.commodityId = commodity;
    _filterGradeByCommodity(commodity);

    if (TermName.contractTypeName(createOfferParam.contractTypeId) !=
        LocaleKeys.TermOptionName_Outright.tr) {
      if (TermName.commodityName(commodity) ==
          LocaleKeys.TermOptionName_Arabica.tr) {
        createOfferParam.priceUnitTypeId = LookUpController.to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_CTLB.tr)
            .id;
      } else {
        createOfferParam.priceUnitTypeId = LookUpController.to.priceUnits.values
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_USDMT.tr)
            .id;
      }
    }
    update();
    _getCoverMonth(commodity);
  }

  void onSelectPackingUnitCode(int packingUnitId) {
    createOfferParam.packingUnitTypeId = packingUnitId;
    update();
  }

  void onSelectCertification(int certificationId) {
    createOfferParam.certificationId = certificationId;
    update();
  }

  Future<void> onPostOffer() async {
    isSubmit.value = true;
    update();
    formKey.currentState.validate();
    if (formKey.currentState.validate() &&
        createOfferParam.gradeTypeId != null &&
        createOfferParam.contractTypeId != null &&
        createOfferParam.validityDate != null &&
        createOfferParam.deliveryDate != null &&
        createOfferParam.deliveryTermId != null &&
        createOfferParam.price != null &&
        createOfferParam.packingUnitTypeId != null &&
        createOfferParam.deliveryWarehouseId != null &&
        createOfferParam.audienceTypeId != null) {
      if (TermName.contractTypeName(createOfferParam.contractTypeId) !=
          LocaleKeys.ContractType_Outright.tr) {
        if (createOfferParam.coverMonth == null) {
          return;
        }
      }

      final isNumberValid = _validateNumberInput();
      if (isNumberValid) {
        final value = '${priceSymbol.value}'
            '${createOfferParam.price}';
        createOfferParam.price = double.parse(value);
        if (isEdit.value) {
          _updateOffer();
        } else {
          _createOffer();
        }
      }
    }
    update();
  }

  Future<void> _updateOffer() async {
    if (createOfferParam.deliveryDate.isBefore(DateTime.now()) ||
        createOfferParam.validityDate.isBefore(DateTime.now())) {
      MessageDialog.showMessage(
        LocaleKeys.CreateOffer_DeliveryDateOrValidityInvalid.tr,
      );
      return;
    }
    MessageDialog.showLoading();
    await repository.updateOffer(createOfferParam).then(
      (response) {
        MessageDialog.hideLoading();
        if (response) {
          Get.back(result: createOfferParam);
        } else {
          MessageDialog.showMessage(LocaleKeys.Shared_ErrorMessage.tr);
        }
      },
    );
  }

  Future<void> _createOffer() async {
    MessageDialog.showLoading();
    await repository.createOffer(createOfferParam).then(
      (response) {
        MessageDialog.hideLoading();
        if (response) {
          Get.back();
        } else {
          MessageDialog.showMessage(LocaleKeys.Shared_ErrorMessage.tr);
        }
      },
    );
  }

  bool _validateNumberInput() {
    if (TermName.contractTypeName(createOfferParam.contractTypeId) !=
        LocaleKeys.ContractType_Outright.tr) {
      if (createOfferParam.quantity <= 0 ||
          createOfferParam.packingQuantity <= 0 ||
          createOfferParam.price <= 0) {
        MessageDialog.showMessage(LocaleKeys.CreateOffer_NumberInvalid.tr);
        return false;
      } else {
        return true;
      }
    } else {
      if (createOfferParam.quantity <= 0 ||
          createOfferParam.packingQuantity <= 0 ||
          createOfferParam.price <= 0) {
        MessageDialog.showMessage(LocaleKeys.CreateOffer_NumberInvalid.tr);
        return false;
      } else {
        return true;
      }
    }
  }

  Future<DateTime> _showDatePicker(BuildContext context) {
    return showRoundedDatePicker(
      context: context,
      locale: Locale(Get.locale.languageCode),
      initialDate: _getInitDate(),
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

  DateTime _getInitDate() {
    if (createOfferParam.deliveryDate == null ||
        createOfferParam.deliveryDate.isBefore(DateTime.now())) {
      return DateTime.now();
    } else {
      return createOfferParam.deliveryDate;
    }
  }

  void showValidity(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        theme: DatePickerTheme(
            doneStyle:
                TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            cancelStyle: TextStyle(
                color: kPrimaryGreyColor.withOpacity(0.5),
                fontWeight: FontWeight.w500)),
        minTime: DateTime.now(),
        maxTime: DateTime(DateTime.now().year + 1),
        onChanged: (date) {}, onConfirm: (date) {
      createOfferParam.validityDate = date;
      update();
    },
        currentTime: createOfferParam.validityDate ?? DateTime.now(),
        locale: Get.locale.languageCode.toLowerCase() == LanguageEnum.English
            ? LocaleType.en
            : LocaleType.vi);
  }

  void addPeople(String text) {
    _offerParam.value.people = text.trim().split(",");
  }

  void onSymbolChanged(text) {
    priceSymbol.value = text;
    update();
  }
}
