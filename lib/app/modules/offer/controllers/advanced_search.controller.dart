import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/data/models/offer.model.dart';
import 'package:agree_n/app/data/repositories/offer.repository.dart';

class OfferAdvancedSearchController extends GetxController {
  final OfferRepository repository;

  OfferAdvancedSearchController({@required this.repository})
      : assert(repository != null);

  RxList<double> quantityValue = RxList<double>();

  Rx<OfferAdvancedSearchModel> _searchParam = OfferAdvancedSearchModel().obs;
  RxInt totalFilter = 0.obs;

  List<int> audiences = AudienceEnum.listAudiences;

  OfferAdvancedSearchModel get searchParam => _searchParam.value;

  static OfferAdvancedSearchModel offerAdvancedSearchModel;

  @override
  void onInit() {
    if (offerAdvancedSearchModel != null) {
      _searchParam.value = offerAdvancedSearchModel;
      quantityValue = [
        _searchParam.value.startQuantity.toDouble(),
        _searchParam.value.endQuantity.toDouble(),
      ].obs;
      _calculateTotal();
    } else {
      quantityValue = [QuantityEnum.QuantityMin, QuantityEnum.QuantityMax].obs;
    }
    super.onInit();
  }

  void updateSelectedUnit(int unitId) {
    if (searchParam.quantityUnitTypeIds.contains(unitId)) {
      searchParam.quantityUnitTypeIds.remove(unitId);
    } else {
      searchParam.quantityUnitTypeIds.add(unitId);
    }
    _calculateTotal();
    update();
  }

  void updateSelectedContractType(int contractTypeId) {
    if (searchParam.contractTypeIds.contains(contractTypeId)) {
      searchParam.contractTypeIds.remove(contractTypeId);
    } else {
      searchParam.contractTypeIds.add(contractTypeId);
    }
    _calculateTotal();
    update();
  }

  void updateSelectedLocation(int locationId) {
    if (searchParam.warehouseIds.contains(locationId)) {
      searchParam.warehouseIds.remove(locationId);
    } else {
      searchParam.warehouseIds.add(locationId);
    }
    _calculateTotal();
    update();
  }

  void updateSelectedCoverMonth(int coverMonthId) {
    if (searchParam.coverMonths.contains(coverMonthId)) {
      searchParam.coverMonths.remove(coverMonthId);
    } else {
      searchParam.coverMonths.add(coverMonthId);
    }
    _calculateTotal();
    update();
  }

  void updateSelectedAudience(int audienceId) {
    if (searchParam.audienceTypeIds.contains(audienceId)) {
      searchParam.audienceTypeIds.remove(audienceId);
    } else {
      searchParam.audienceTypeIds.add(audienceId);
    }
    _calculateTotal();
    update();
  }

  void onDragging(int handlerIndex, double lowerValue, double upperValue) {
    searchParam.startQuantity = lowerValue.toInt();
    searchParam.endQuantity = upperValue.toInt();
    quantityValue.clear();
    quantityValue.add(lowerValue);
    quantityValue.add(upperValue);
    _calculateTotal();
    update();
  }

  void onGradeChanged(int gradeId) {
    searchParam.gradeTypeId = gradeId;
    totalFilter += 1;
    update();
  }

  void onDeliveryTermChanged(int termId) {
    searchParam.deliveryTermId = termId;
    totalFilter += 1;
    update();
  }

  Future onSelectDeliveryStartDate(BuildContext context) async {
    DateTime selectedDate =
        await _showDatePicker(context, initDate: searchParam.deliveryStartDate);
    if (selectedDate != null) {
      searchParam.deliveryStartDate = selectedDate;
      _calculateTotal();
    }
    update();
  }

  Future onSelectDeliveryEndDate(BuildContext context) async {
    DateTime selectedDate =
        await _showDatePicker(context, initDate: searchParam.deliveryEndDate);
    if (selectedDate != null) {
      searchParam.deliveryEndDate = selectedDate;
      _calculateTotal();
    }
    update();
  }

  Future onSelectValidityStartDate(BuildContext context) async {
    DateTime selectedDate =
        await _showDatePicker(context, initDate: searchParam.validityStartDate);
    if (selectedDate != null) {
      searchParam.validityStartDate = selectedDate;
      _calculateTotal();
    }
    update();
  }

  Future onSelectValidityEndDate(BuildContext context) async {
    DateTime selectedDate =
        await _showDatePicker(context, initDate: searchParam.validityEndDate);
    if (selectedDate != null) {
      searchParam.validityEndDate = selectedDate;
      _calculateTotal();
    }
    update();
  }

  Future<DateTime> _showDatePicker(BuildContext context, {DateTime initDate}) {
    return showRoundedDatePicker(
      context: context,
      locale: Locale(Get.locale.languageCode),
      initialDate: initDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
      height: MediaQuery.of(context).size.height * 0.4,
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

  void _calculateTotal() {
    totalFilter.value = 0;
    if (searchParam.quantityUnitTypeIds != null &&
        searchParam.quantityUnitTypeIds.isNotEmpty) {
      totalFilter.value += 1;
    }
    if (searchParam.warehouseIds != null &&
        searchParam.warehouseIds.isNotEmpty) {
      totalFilter.value += 1;
    }
    if (searchParam.startQuantity != null &&
            searchParam.startQuantity != QuantityEnum.QuantityMin ||
        searchParam.endQuantity != null &&
            searchParam.endQuantity != QuantityEnum.QuantityMax) {
      totalFilter.value += 1;
    }
    if (searchParam.gradeTypeId != null) {
      totalFilter.value += 1;
    }
    if (searchParam.contractTypeIds != null &&
        searchParam.contractTypeIds.isNotEmpty) {
      totalFilter.value += 1;
    }
    if (searchParam.validityStartDate != null &&
        searchParam.validityEndDate != null) {
      totalFilter.value += 1;
    }
    if (searchParam.deliveryStartDate != null &&
        searchParam.deliveryEndDate != null) {
      totalFilter.value += 1;
    }
    if (searchParam.deliveryTermId != null) {
      totalFilter.value += 1;
    }
    if (searchParam.audienceTypeIds != null &&
        searchParam.audienceTypeIds.isNotEmpty) {
      totalFilter.value += 1;
    }
    if (searchParam.coverMonths != null && searchParam.coverMonths.isNotEmpty) {
      totalFilter.value += 1;
    }
    update();
  }

  void onSearchAdvance() {
    offerAdvancedSearchModel = searchParam;
  }

  void onClearSearch(){
    _searchParam.value = OfferAdvancedSearchModel();
    totalFilter.value = 0;
    update();
  }
}
