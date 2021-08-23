import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/constants/constants.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_price.widget.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_volume.widget.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract.controller.dart';

class PastContractVolumeController extends GetxController {
  ContractRepository repository;

  PastContractVolumeController({@required this.repository})
      : assert(repository != null);
  static PastContractVolumeController to = Get.find();
  RxBool isLoading = false.obs;
  RxBool isGettingData = false.obs;
  RxInt currentTab = PastContractTabEnum.Volume.obs;
  RxBool isFilterValueChange = false.obs;
  RxBool alreadyChangeTimeFrameType = RxBool(false);

  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedQuarter = RxInt(1);
  RxInt selectedMonth = RxInt();
  RxInt selectedDay = RxInt();
  RxInt selectedIndexColumn = RxInt(-1);
  RxBool hasData = RxBool(false);

  int dayOfMonth = 31;
  double maxYValue = 0;
  int lengthOfMaxValue = 0;
  RxList<SubTimeFrame> daysOfMonth = RxList<SubTimeFrame>();
  RxList<SubTimeFrame> monthsOfYear = RxList<SubTimeFrame>();
  RxList<SubTimeFrame> monthsOfQuarter = RxList<SubTimeFrame>();
  RxList<PastContractDetailModel> pastContractDetails =
      RxList<PastContractDetailModel>();
  RxList<PastContractSeriesModel> pastContractResult =
      RxList<PastContractSeriesModel>();
  RxList<PastContractsVolumeViewModel> pastContractsVolumeViewModel =
      RxList<PastContractsVolumeViewModel>();

  List<int> pastContractTabs = [
    PastContractTabEnum.Volume,
    PastContractTabEnum.Price,
    PastContractTabEnum.Performance
  ];

  List<Widget> pastContractPages = [
    PastContractsVolume(),
    PastContractsPrice(),
    PastContractsVolume()
  ];
  Rx<PastContractFilterParam> pastContractFilterParam = PastContractFilterParam(
    type: PastContractTabEnum.Volume,
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

  //For Volume Chart
  List<Color> colors = [kPrimaryColor.withOpacity(0.1), kPrimaryColor];
  RxList<BarChartGroupData> rawBarGroups = RxList<BarChartGroupData>();
  RxList<BarChartGroupData> showingBarGroups = RxList<BarChartGroupData>();
  RxList<FlSpot> spots = RxList<FlSpot>();

  RxList<int> years = RxList<int>([]);
  RxInt selectedFromYear = DateTime.now().year.obs;
  RxInt selectedToYear = DateTime.now().year.obs;
  List<SupplierModel> suppliers = List<SupplierModel>();
  List<SupplierModel> suppliersClone = List<SupplierModel>();

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

  @override
  void onInit() {
    super.onInit();
    generateYear();
    initDayOfMonth(DateTime.now().month, DateTime.now().year);
    initMonthOfYear();
    initMonthsOfQuarter();
    getPastContractReport();
    suppliers = PastContractController.to.suppliers;
    suppliersClone = suppliers;
  }

  void generateYear() async {
    for (int i = AppConst.pastContractFromYear; i <= DateTime.now().year; i++) {
      years.add(i);
    }
    update();
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
    _clearSelectedTimeFrame();
    update();
  }

  Future<void> getPastContractInfo() async {
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
          .getPastContractDetailVolume(pastContractFilterParam)
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
        await repository.getPastContractVolume(filterParam).then((response) {
          isLoading.value = false;
          update();
          if (response != null) {
            final result = response.body
                .map<PastContractSeriesModel>(
                    (item) => PastContractSeriesModel.fromJson(item))
                .toList();
            pastContractResult.addAll(result);
            _onCheckData();
          } else {
            MessageDialog.showError(message: response.statusMessage);
          }
          update();
        });
      } catch (e) {
        isLoading.value = false;
        update();
        throw e;
      }
    }
    _generateVolumeValue();
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

  //For filter
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

  void onSelectGrade(int grade) {
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    filterParam.gradeTypeId = grade;
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
    getPastContractInfo();
    update();
  }

  void initDayOfMonth(int month, int year) {
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

  void _generateVolumeValue() {
    if (rawBarGroups != null) {
      rawBarGroups.clear();
    } else
      rawBarGroups = [].obs;
    int index = 1;
    for (int i = 0; i < pastContractResult.length; i++) {
      final value = pastContractResult[i].value;
      rawBarGroups.add(_makeGroupData(index, value, colors));
      index++;
    }
    showingBarGroups = rawBarGroups;
    update();
  }

  String generateVolumeTitle(double value) {
    if (isYearTimeFrame) {
      var fromYear = int.parse(pastContractResult[0].name) - 1;
      return (fromYear + value.toInt()).toString();
    }
    if (isQuarterTimeFrame) {
      return '${pastContractResult[value.toInt() - 1].name}';
    } else {
      return pastContractResult[value.toInt() - 1].name;
    }
  }

  BarChartGroupData _makeGroupData(int x, double y, List<Color> colors) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
          y: y, colors: colors, width: 20, borderRadius: BorderRadius.zero),
    ]);
  }

  double getMaxYValue() {
    List<double> values = [];
    pastContractResult.forEach((element) {
      values.add(element.value);
    });
    return values.reduce(max);
  }

  String getRightTitle(double value) {
    if (value % 500 == 0) {
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

  void touchCallback(BarTouchResponse response) {
    if (response.spot == null) {
      return;
    }
    initDayOfMonth(response.spot.touchedBarGroup.x, DateTime.now().year);
    int touchedGroupIndex = response.spot.touchedBarGroupIndex;
    selectedChartColumn(touchedGroupIndex);
    showingBarGroups[touchedGroupIndex] =
        showingBarGroups[touchedGroupIndex].copyWith();
    if (isQuarterTimeFrame) {
      initMonthsOfQuarter(quarter: response.spot.touchedBarGroup.x);
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
