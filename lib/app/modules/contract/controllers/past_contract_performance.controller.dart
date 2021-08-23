import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:agree_n/app/theme/theme.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/constants/constants.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/user.model.dart';
import 'package:agree_n/app/data/models/contact.model.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract.controller.dart';

class PastContractPerformanceController extends GetxController {
  ContractRepository repository;

  PastContractPerformanceController({@required this.repository})
      : assert(repository != null);

  static PastContractPerformanceController to = Get.find();

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
  RxInt _criteriaChart = RxInt(CriteriaEnum.Overall);
  Rx<Color> colorChart = Rx<Color>(kPrimaryColor);
  RxInt selectedIndexColumn = RxInt(-1);

  RxDouble rating = RxDouble(0.0);

  int dayOfMonth = 31;
  double maxYValue = 100;
  int lengthOfMaxValue = 0;
  double minYValue = 0;
  int lengthOfMinValue = 0;
  RxList<SubTimeFrame> daysOfMonth = RxList<SubTimeFrame>();
  RxList<SubTimeFrame> monthsOfYear = RxList<SubTimeFrame>();
  RxList<SubTimeFrame> monthsOfQuarter = RxList<SubTimeFrame>();
  RxList<ContactScoreModel> tenantScores = RxList<ContactScoreModel>([]);

  Rx<ContractPerformanceSeriesModel> _contractPerformanceSeriesDetail =
      Rx<ContractPerformanceSeriesModel>();
  RxList<ContractPerformanceSeriesModel> contractPerformanceSeries =
      RxList<ContractPerformanceSeriesModel>();

  List<SupplierModel> suppliers = List<SupplierModel>();
  List<SupplierModel> suppliersClone = List<SupplierModel>();

  Rx<PastContractFilterParam> pastContractFilterParam = PastContractFilterParam(
    type: PastContractTabEnum.Performance,
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

  int get criteriaChart => _criteriaChart.value;

  PastContractFilterParam get filterParam => pastContractFilterParam.value;

  ContractPerformanceSeriesModel get contractPerformanceSeriesDetail =>
      _contractPerformanceSeriesDetail.value;

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
    getPastContractReport();
    initMonthOfYear();
    initMonthsOfQuarter();
    suppliers = PastContractController.to.suppliers;
    suppliersClone = suppliers;
  }

  void selectedChartColumn(int indexColumn) {
    selectedIndexColumn.value = indexColumn + 1;
    if (isYearTimeFrame) {
      selectedYear = int.parse(contractPerformanceSeries[indexColumn].name).obs;
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
      PastContractFilterParam pastContractFilterParam =
          new PastContractFilterParam(
        year: selectedYear.value,
        month: selectedMonth.value,
        day: selectedDay.value,
      );
      await repository
          .getPastContractDetailPerformance(pastContractFilterParam)
          .then((response) {
        isGettingData.value = false;
        update();
        if (response.body != null) {
          _contractPerformanceSeriesDetail.value =
              ContractPerformanceSeriesModel.fromJson(response.body);
          setTenantScores(_contractPerformanceSeriesDetail.value);
        } else {
          MessageDialog.showError(message: response.statusMessage);
        }
      });
    } catch (e) {
      isGettingData.value = false;
      update();
      throw e;
    }
    update();
  }

  void clearPastContractInfo() {
    _contractPerformanceSeriesDetail.value = null;
    update();
  }

  void getPastContractReport({bool isRefresh = true}) async {
    if (isRefresh) {
      contractPerformanceSeries.clear();
      try {
        isLoading.value = true;
        update();
        await repository
            .getPastContractPerformance(filterParam)
            .then((response) {
          isLoading.value = false;
          update();
          if (response != null) {
            final result = response.body
                .map<ContractPerformanceSeriesModel>(
                    (item) => ContractPerformanceSeriesModel.fromJson(item))
                .toList();
            contractPerformanceSeries.addAll(result);
            _onCheckData();
          } else {
            MessageDialog.showError(message: response.statusMessage);
          }
        });
      } catch (e) {
        isLoading.value = false;
        update();
        throw e;
      }
    }
    generatePerformanceValue();
  }

  void _onCheckData() {
    hasData.value = false;
    update();
    contractPerformanceSeries.forEach((_) {
      if (_.overall > 0 ||
          _.timeDelivery > 0 ||
          _.documentation > 0 ||
          _.cooperation > 0 ||
          _.quality > 0) {
        hasData.value = true;
        update();
      }
    });
  }

  //For filter
  void onSelectedTimeFrameType(int type) {
    selectedIndexColumn.value = -1;
    alreadyChangeTimeFrameType.value = true;
    _clearSelectedTimeFrame();
    filterParam.timeFrameTypeId = type;
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

  String year() {
    if (filterParam.timeFrameTypeId == TimeFrameEnum.Year) {
      return filterParam.fromYear.toString() +
          "-" +
          filterParam.toYear.toString();
    } else {
      return filterParam.fromYear.toString();
    }
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

  String generatePerformanceTitle(double value) {
    if (isYearTimeFrame) {
      final fromYear = int.parse(contractPerformanceSeries[0].name) - 1;
      return (fromYear + value.toInt()).toString();
    }
    if (isQuarterTimeFrame) {
      return '${contractPerformanceSeries[value.toInt() - 1].name}';
    } else {
      return contractPerformanceSeries[value.toInt() - 1].name;
    }
  }

  void generatePerformanceValue() {
    if (spots != null) {
      spots.clear();
    } else
      spots = [].obs;
    int index = 1;
    int criteria = criteriaChart;
    for (int i = 0; i < contractPerformanceSeries.length; i++) {
      double value;
      switch (criteria) {
        case CriteriaEnum.Overall:
          value = contractPerformanceSeries[i].overall;
          break;
        case CriteriaEnum.Quality:
          value = contractPerformanceSeries[i].quality;
          break;
        case CriteriaEnum.TimeDelivery:
          value = contractPerformanceSeries[i].timeDelivery;
          break;
        case CriteriaEnum.Cooperation:
          value = contractPerformanceSeries[i].cooperation;
          break;
        case CriteriaEnum.Documentation:
          value = contractPerformanceSeries[i].documentation;
          break;
      }
      spots.add(FlSpot(index.toDouble(), value.toDouble()));
      index++;
    }
    update();
  }

  void onChangedCriteria(int criteria) {
    _criteriaChart.value = criteria;
    switch (criteria) {
      case CriteriaEnum.Overall:
        colorChart.value = kPrimaryColor;
        break;
      case CriteriaEnum.Quality:
        colorChart.value = Colors.red;
        break;
      case CriteriaEnum.TimeDelivery:
        colorChart.value = Colors.yellow;
        break;
      case CriteriaEnum.Cooperation:
        colorChart.value = kPrimaryBlueColor;
        break;
      case CriteriaEnum.Documentation:
        colorChart.value = Colors.orange;
        break;
    }
    update();
  }

  String getRightTitle(double value) {
    if (value % 10 == 0) {
      return NumberFormat('###,###.##').format(value);
    }
    return "";
  }

  void setTenantScores(
      ContractPerformanceSeriesModel contractPerformanceSeries) {
    tenantScores.clear();
    List<ContactScoreModel> contactScores = [
      ContactScoreModel(
          scoreTypeId: ScoreTypeEnum.Quality,
          value: contractPerformanceSeries.quality),
      ContactScoreModel(
          scoreTypeId: ScoreTypeEnum.TimelyDelivery,
          value: contractPerformanceSeries.timeDelivery),
      ContactScoreModel(
          scoreTypeId: ScoreTypeEnum.Cooperation,
          value: contractPerformanceSeries.cooperation),
      ContactScoreModel(
          scoreTypeId: ScoreTypeEnum.Documentation,
          value: contractPerformanceSeries.documentation),
      ContactScoreModel(
          scoreTypeId: ScoreTypeEnum.OverallPerformance,
          value: contractPerformanceSeries.overall)
    ];
    tenantScores.addAll(contactScores);
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

  void onSelectedQuarter(int quarter) {
    selectedQuarter.value = quarter;
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

  void calculateRating(double percents) {
    final a = percents / 20;
    final x = (a).toInt();
    var y = a - x;
    if (y > 0 && y < 1.0) {
      y = 0.5;
    }
    rating.value = x + y;
    update();
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
