import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/constants/constants.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract.controller.dart';

class PastContractPriceController extends GetxController {
  ContractRepository repository;

  PastContractPriceController({@required this.repository})
      : assert(repository != null);

  static PastContractPriceController to = Get.find();
  RxBool isLoading = false.obs;
  RxBool isGettingData = false.obs;
  RxBool isMonthSelected = false.obs;
  RxBool isFilterByDate = false.obs;
  RxBool alreadyChangeTimeFrameType = RxBool(false);
  RxBool hasData = RxBool(false);

  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedQuarter = RxInt();
  RxInt selectedMonth = RxInt();
  RxInt selectedDay = RxInt();
  RxInt selectedIndexColumn = RxInt(-1);

  int dayOfMonth = 31;
  double maxYValue = 0;
  int lengthOfMaxValue = 0;
  double minYValue = 0;
  int lengthOfMinValue = 0;
  RxList<SubTimeFrame> daysOfMonth = RxList<SubTimeFrame>();
  RxList<SubTimeFrame> monthsOfYear = RxList<SubTimeFrame>();
  RxList<SubTimeFrame> monthsOfQuarter = RxList<SubTimeFrame>();

  RxList<PastContractDetailModel> pastContractDetails =
      RxList<PastContractDetailModel>();
  RxList<PastContractSeriesModel> pastContractResult =
      RxList<PastContractSeriesModel>();

  List<SupplierModel> suppliers = List<SupplierModel>();
  List<SupplierModel> suppliersClone = List<SupplierModel>();

  Rx<PastContractFilterParam> pastContractFilterParam = PastContractFilterParam(
    type: PastContractTabEnum.Price,
    fromYear: DateTime.now().year,
    toYear: DateTime.now().year,
    timeFrameTypeId: TimeFrameEnum.Year,
    selectedTimeFrameName: TimeFrameEnum.Year,
  ).obs;

  RxList<int> timeFrames = [
    TimeFrameEnum.Year,
    TimeFrameEnum.Quarter,
    TimeFrameEnum.Month,
  ].obs;

  RxList<FlSpot> spots = RxList<FlSpot>();

  RxList<int> years = RxList<int>([]);

  RxInt selectedFromYear = DateTime.now().year.obs;
  RxInt selectedToYear = DateTime.now().year.obs;

  PastContractFilterParam get filterParam => pastContractFilterParam.value;

  get isYearTimeFrame {
    return filterParam.timeFrameTypeId == TimeFrameEnum.Year;
  }

  get isQuarterTimeFrame {
    return filterParam.timeFrameTypeId == TimeFrameEnum.Quarter;
  }

  get isMonthTimeFrame {
    return filterParam.timeFrameTypeId == TimeFrameEnum.Month;
  }

  get anySelectDayOfMonth {
    return daysOfMonth.any((element) => element.isSelected);
  }

  get anySelectMonthOfYear {
    return monthsOfYear.any((element) => element.isSelected);
  }

  get anySelectMonthOfQuarter {
    return monthsOfQuarter.any((element) => element.isSelected);
  }

  void generateYear() async {
    for (int i = AppConst.pastContractFromYear;
        i <= int.parse(DateTime.now().year.toString());
        i++) {
      years.add(i);
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    generateYear();
    initDayOfMonth(month: DateTime.now().month, year: DateTime.now().year);
    initMonthOfYear();
    initMonthsOfQuarter();
    getPastContractReport();
    suppliers = PastContractController.to.suppliers;
    suppliersClone = suppliers;
  }

  void selectedChartColumn(int indexColumn) {
    selectedIndexColumn.value = indexColumn + 1;
    if (isYearTimeFrame) {
      selectedYear = int.parse(pastContractResult[indexColumn].name).obs;
    }
    if (isMonthTimeFrame || isQuarterTimeFrame) {
      selectedMonth.value = indexColumn + 1;
    }

    if (isQuarterTimeFrame) {
      selectedQuarter.value = indexColumn + 1;
    }
    update();
    _clearSelectedTimeFrame();
  }

  void getPastContractInfo() async {
    try {
      alreadyChangeTimeFrameType.value = false;
      isGettingData.value = true;
      update();
      PastContractFilterParam pastContractFilterParam =
          new PastContractFilterParam(
        year: selectedYear.value,
        month: selectedMonth.value,
        day: selectedDay.value,
      );
      await repository
          .getPastContractDetailPrice(pastContractFilterParam)
          .then((response) {
        isGettingData.value = false;
        update();
        if (response.body != null) {
          List<PastContractDetailModel> result = response.body
              .map<PastContractDetailModel>(
                  (item) => new PastContractDetailModel.fromJson(item))
              .toList();
          pastContractDetails = result.obs;
        } else {
          MessageDialog.showError(message: response.statusMessage);
        }
      });
    } catch (e) {
      isGettingData.value = false;
      update();
      throw e;
    }
  }

  void clearPastContractInfo() {
    pastContractDetails.clear();
    update();
  }

  void getPastContractReport({bool isRefresh = true}) async {
    if (isRefresh) {
      pastContractResult.clear();
      try {
        isLoading.value = true;
        update();
        await repository.getPastContractPrice(filterParam).then((response) {
          isLoading.value = false;
          update();
          final result = response.body
              .map<PastContractSeriesModel>(
                  (item) => PastContractSeriesModel.fromJson(item))
              .toList();
          pastContractResult.addAll(result);
          _onCheckData();
        });
      } catch (e) {
        isLoading.value = false;
        update();
        throw e;
      }
    }
    _generatePriceValue();
  }

  void _onCheckData() {
    hasData.value = false;
    update();
    pastContractResult.forEach((_) {
      if (_.value > 0) {
        hasData.value = true;
        update();
      }
    });
  }

  void onSelectedTimeFrameType(int type) {
    selectedIndexColumn.value = -1;
    filterParam.timeFrameTypeId = type;
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    if (!isYearTimeFrame) {
      filterParam.fromYear = filterParam.toYear = DateTime.now().year;
      selectedYear = DateTime.now().year.obs;
      selectedMonth = DateTime.now().month.obs;
      clearPastContractInfo();
    }
    if (isYearTimeFrame) {
      filterParam.fromYear = AppConst.pastContractFromYear;
      filterParam.toYear = DateTime.now().year;
    }
    getPastContractReport();
    filterParam.selectedTimeFrameName = type;
    update();
  }

  void onSelectCommodity(int type) {
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    filterParam.commodityTypeId = type;
    getPastContractReport();
    update();
  }

  void onSelectContractType(int type) {
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    filterParam.contractTypeId = type;
    getPastContractReport();
    update();
  }

  void onFilterDone() {
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    filterParam.fromYear = selectedFromYear.value;
    filterParam.toYear = selectedToYear.value;
    getPastContractReport();
    update();
  }

  void onCancelFilter() {
    selectedFromYear.value = filterParam.fromYear;
    selectedToYear.value = filterParam.toYear;
    update();
  }

  void onSelectDayOfMonth(int dayOfMonth) {
    daysOfMonth.forEach((m) {
      if (m.id == dayOfMonth) {
        m.isSelected = true;
      } else
        m.isSelected = false;
    });

    selectedDay.value = dayOfMonth;
    clearPastContractInfo();
    getPastContractInfo();
    update();
  }

  void onSelectMonthOfYear(int monthOfYear) {
    monthsOfYear.forEach((m) {
      if (m.id == monthOfYear) {
        m.isSelected = !m.isSelected;
      } else
        m.isSelected = false;
    });

    selectedMonth.value = monthOfYear;
    clearPastContractInfo();
    getPastContractInfo();
    update();
  }

  void onSelectMonthOfQuarter(int monthOfQuarter) {
    monthsOfQuarter.forEach((m) {
      if (m.id == monthOfQuarter) {
        m.isSelected = !m.isSelected;
      } else
        m.isSelected = false;
    });

    selectedMonth.value = monthOfQuarter;
    clearPastContractInfo();
    getPastContractInfo();
    update();
  }

  void onSelectGrade(int grade) {
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    filterParam.gradeTypeId = grade;
    getPastContractReport();
    Get.back();
    update();
  }

  void initDayOfMonth({int month, int year, bool isInit = true}) {
    switch (month) {
      case 2:
        if (year % 4 == 0) {
          dayOfMonth = 29;
        } else
          dayOfMonth = 28;
        break;
      case 4:
        dayOfMonth = 30;
        break;
      case 6:
        dayOfMonth = 30;
        break;
      case 9:
        dayOfMonth = 30;
        break;
      case 11:
        dayOfMonth = 30;
        break;
      default:
        dayOfMonth = 31;
        break;
    }

    daysOfMonth = List.generate(
      dayOfMonth,
      (index) => new SubTimeFrame(id: index + 1, isSelected: false),
    ).obs;

    if (isInit == false) {
      isMonthSelected = true.obs;
    }
    update();
  }

  void initMonthOfYear() {
    monthsOfYear = List.generate(
      12,
      (index) => new SubTimeFrame(id: index + 1, isSelected: false),
    ).obs;
  }

  void initMonthsOfQuarter({int quarter = 1}) {
    switch (quarter) {
      case 1:
        monthsOfQuarter = [
          new SubTimeFrame(id: 1, isSelected: false),
          new SubTimeFrame(id: 2, isSelected: false),
          new SubTimeFrame(id: 3, isSelected: false),
        ].obs;
        break;
      case 2:
        monthsOfQuarter = [
          new SubTimeFrame(id: 4, isSelected: false),
          new SubTimeFrame(id: 5, isSelected: false),
          new SubTimeFrame(id: 6, isSelected: false),
        ].obs;
        break;
      case 3:
        monthsOfQuarter = [
          new SubTimeFrame(id: 7, isSelected: false),
          new SubTimeFrame(id: 8, isSelected: false),
          new SubTimeFrame(id: 9, isSelected: false),
        ].obs;
        break;
      case 4:
        monthsOfQuarter = [
          new SubTimeFrame(id: 10, isSelected: false),
          new SubTimeFrame(id: 11, isSelected: false),
          new SubTimeFrame(id: 12, isSelected: false),
        ].obs;
        break;
    }
  }

  // For generate report values for Price

  String generatePriceTitle(double value) {
    if (isYearTimeFrame) {
      final fromYear = int.parse(pastContractResult[0].name) - 1;
      return (fromYear + value.toInt()).toString();
    }
    if (isQuarterTimeFrame) {
      return '${pastContractResult[value.toInt() - 1].name}';
    } else {
      return pastContractResult[value.toInt() - 1].name;
    }
  }

  void _generatePriceValue() {
    if (spots != null) {
      spots.clear();
    } else
      spots = [].obs;
    int index = 1;
    for (int i = 0; i < pastContractResult.length; i++) {
      final value = pastContractResult[i].value;
      spots.add(FlSpot(index.toDouble(), value));
      index++;
    }
    update();
  }

  double getMaxYValue() {
    List<double> values = [];
    pastContractResult.forEach((element) {
      values.add(element.value);
    });
    return values.reduce(max);
  }

  double getMinYValue() {
    List<double> values = [];
    pastContractResult.forEach((element) {
      values.add(element.value);
    });
    return values.reduce(min);
  }

  String getRightTitle(double value) {
    if (value % 1000 == 0) {
      return NumberFormat('###,###.##').format(value);
    }
    return "";
  }

  void _clearSelectedTimeFrame() {
    daysOfMonth.forEach((element) {
      element.isSelected = false;
    });
    monthsOfYear.forEach((element) {
      element.isSelected = false;
    });
    monthsOfQuarter.forEach((element) {
      element.isSelected = false;
    });
  }

  void onSelectedFromYear(int year) {
    selectedFromYear.value = year;
    if (selectedFromYear.value > selectedToYear.value) {
      selectedToYear.value = selectedFromYear.value;
    }
    update();
  }

  void onSelectedToYear(int year) {
    selectedToYear.value = year;
    if (selectedToYear.value < selectedFromYear.value) {
      selectedFromYear.value = selectedToYear.value;
    }
    update();
  }

  void onSelectedToAndFromYear(int year) {
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    filterParam.fromYear = filterParam.toYear = year;
    selectedYear.value = year;
    getPastContractReport();
    update();
  }

  void onSupplierChanged(bool value, int supplierId) {
    if (value) {
      filterParam.tenantIds.add(supplierId);
    } else {
      filterParam.tenantIds.remove(supplierId);
    }
    update();
  }

  void onSelectedSupplier() {
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    final selectedSupplier =
        suppliers.where((_) => filterParam.tenantIds.contains(_.supplierId));
    if (selectedSupplier.isEmpty) {
      filterParam.supplierName = null;
    } else {
      filterParam.supplierName = selectedSupplier.map((_) => _.name).join(', ');
    }
    suppliers = suppliersClone;
    getPastContractReport();
    update();
  }

  void onClear() {
    filterParam.tenantIds = [];
    update();
  }

  String deliveryDate() {
    if (anySelectDayOfMonth) {
      return DateFormat('EEE, dd MMM, yyyy').format(
          DateTime(selectedYear.value, selectedMonth.value, selectedDay.value));
    }
    if (anySelectMonthOfYear || isMonthTimeFrame) {
      return DateFormat('MMM, yyyy')
          .format(DateTime(selectedYear.value, selectedMonth.value));
    }
    if (anySelectMonthOfQuarter || isMonthTimeFrame) {
      final m = DateFormat('MMM')
          .format(DateTime(selectedYear.value, selectedMonth.value));
      final y = selectedYear.value.toString();
      return "$m, ${LocaleKeys.TimeFrame_Quarter.tr} ${selectedQuarter.value}, $y";
    }
    if (isYearTimeFrame) {
      return selectedYear.value.toString();
    }
    if (isQuarterTimeFrame) {
      final y = selectedYear.value.toString();
      return "${LocaleKeys.TimeFrame_Quarter.tr} ${selectedQuarter.value}, $y";
    }
    return DateFormat('EEE, dd MMM, yyyy').format(
        DateTime(selectedYear.value, selectedMonth.value, selectedDay.value));
  }

  void touchCallback(LineTouchResponse touchResponse) {
    if (touchResponse.props == null) {
      return;
    }
    var offset = touchResponse.touchInput.getOffset();
    if (offset.dx != 0.0 &&
        offset.dy != 0.0 &&
        touchResponse.lineBarSpots.length > 0) {
      initDayOfMonth(
          month: touchResponse.lineBarSpots[0].spotIndex + 1,
          year: DateTime.now().year,
          isInit: false);
      selectedChartColumn(touchResponse.lineBarSpots[0].spotIndex);
      if (isQuarterTimeFrame) {
        initMonthsOfQuarter(
            quarter: touchResponse.lineBarSpots[0].spotIndex + 1);
      }
    }
    clearPastContractInfo();
  }

  void onSearchSupplier(String keyword) {
    final List<SupplierModel> searchResult = [];
    if (keyword.isEmpty) {
      suppliers = suppliersClone;
      update();
    } else {
      for (var item in suppliersClone) {
        if (item.name.toLowerCase().contains(keyword.toLowerCase())) {
          searchResult.add(item);
        }
      }
      suppliers = searchResult;
      update();
    }
  }
}

class SubTimeFrame {
  int id;
  bool isSelected;

  SubTimeFrame({this.id, this.isSelected});
}
