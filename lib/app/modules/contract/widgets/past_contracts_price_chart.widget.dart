import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_price.controller.dart';

class PastContractsPriceChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PastContractPriceController>(
      builder: (controller) {
        return controller.isLoading.value
            ? Container(
                height: Get.height * 0.5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            : controller.hasData.value
                ? Column(
                    children: [
                      _buildUnit(),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 30, right: 10),
                        child: AspectRatio(
                          aspectRatio: 1.6,
                          child: LineChart(
                            chart(controller),
                          ),
                        ),
                      ),
                      if (controller.selectedIndexColumn.value != -1)
                        Column(
                          children: [
                            Visibility(
                                visible: controller.isMonthTimeFrame,
                                child: _buildDayOfMonthSelection()),
                            Visibility(
                                visible: controller.isYearTimeFrame,
                                child: _buildMonthOfYearSelection()),
                            Visibility(
                                visible: controller.isQuarterTimeFrame,
                                child: _buildMonthOfQuarterSelection())
                          ],
                        )
                    ],
                  )
                : SizedBox(
                    height: Get.height * 0.5,
                    child: Center(
                      child: Text(
                        LocaleKeys.PastContract_NoPriceData.tr,
                        style: TextStyle(
                          fontSize: 18,
                          color: kPrimaryGreyColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
      },
    );
  }

  Widget _buildUnit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "USD/MT",
            style: TextStyle(
              color: kPrimaryGreyColor,
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }

  LineChartData chart(PastContractPriceController controller) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: kPrimaryColor.withOpacity(0.1),
        ),
        touchCallback: (touchResponse) {
          controller.touchCallback(touchResponse);
        },
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        checkToShowHorizontalLine: (value) => value % 500 == 0,
        getDrawingHorizontalLine: (value) => value == 0
            ? FlLine(color: kPrimaryColor)
            : FlLine(color: Colors.grey.withOpacity(0.1)),
        drawVerticalLine: true,
        checkToShowVerticalLine: (value) => true,
        getDrawingVerticalLine: (value) =>
            FlLine(color: Colors.grey.withOpacity(0.1)),
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          rotateAngle: controller.isYearTimeFrame || controller.isMonthTimeFrame
              ? -50
              : controller.isQuarterTimeFrame
                  ? 0
                  : -90,
          showTitles: true,
          reservedSize: 30,
          getTextStyles: (value) => TextStyle(
            color: value == controller.selectedIndexColumn.value
                ? kPrimaryColor
                : Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 30,
          getTitles: (double value) {
            return controller.generatePriceTitle(value);
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
        rightTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          getTitles: (value) {
            return controller.getRightTitle(value);
          },
          margin: 8,
          reservedSize: 35,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 1,
      maxX: controller.pastContractResult.length.toDouble(),
      maxY: controller.getMaxYValue(),
      minY: controller.getMinYValue(),
      lineBarsData: linesBarData(controller),
    );
  }

  List<LineChartBarData> linesBarData(PastContractPriceController controller) {
    final lineChartBarData = LineChartBarData(
      spots: controller.spots,
      isCurved: true,
      colors: [
        kPrimaryColor,
      ],
      barWidth: 5,
      dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
              )),
    );
    return [
      lineChartBarData,
    ];
  }

  Widget _buildSubTimeFrameItem(
      SubTimeFrame subTimeFrame, PastContractPriceController controller) {
    return GestureDetector(
      onTap: () {
        if (controller.isYearTimeFrame) {
          controller.onSelectMonthOfYear(subTimeFrame.id);
        }
        if (controller.isMonthTimeFrame) {
          controller.onSelectDayOfMonth(subTimeFrame.id);
        }
        if (controller.isQuarterTimeFrame) {
          controller.onSelectMonthOfQuarter(subTimeFrame.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: subTimeFrame.isSelected ? kPrimaryColor : Colors.transparent,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          controller.isYearTimeFrame
              ? MonthEnum.getName(subTimeFrame.id)
              : (subTimeFrame.id).toString(),
          style: TextStyle(
              fontSize: 12,
              color: subTimeFrame.isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDayOfMonthSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: kLightBlueColor,
      height: 40,
      child: GetBuilder<PastContractPriceController>(
        init: Get.find(),
        builder: (controller) {
          return NotificationListener(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              itemCount: controller.daysOfMonth.length,
              itemBuilder: (context, index) {
                return _buildSubTimeFrameItem(
                    controller.daysOfMonth[index], controller);
              },
            ),
            // ignore: missing_return
            onNotification: (notification) {},
          );
        },
      ),
    );
  }

  Widget _buildMonthOfYearSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: kLightBlueColor,
      height: 40,
      child: GetBuilder<PastContractPriceController>(
        init: Get.find(),
        builder: (controller) {
          return NotificationListener(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              itemCount: controller.monthsOfYear.length,
              itemBuilder: (context, index) {
                return _buildSubTimeFrameItem(
                    controller.monthsOfYear[index], controller);
              },
            ),
            // ignore: missing_return
            onNotification: (notification) {},
          );
        },
      ),
    );
  }

  Widget _buildMonthOfQuarterSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: kLightBlueColor,
      height: 40,
      width: 200,
      child: GetBuilder<PastContractPriceController>(
        init: Get.find(),
        builder: (controller) {
          return NotificationListener(
            child: Center(
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                itemCount: controller.monthsOfQuarter.length,
                itemBuilder: (context, index) {
                  return _buildSubTimeFrameItem(
                      controller.monthsOfQuarter[index], controller);
                },
              ),
            ),
            // ignore: missing_return
            onNotification: (notification) {},
          );
        },
      ),
    );
  }
}
