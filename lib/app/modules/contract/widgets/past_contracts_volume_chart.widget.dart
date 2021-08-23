import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_volume.controller.dart';

class PastContractsVolumeChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: GetBuilder<PastContractVolumeController>(
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
                          children: <Widget>[
                            _buildUnit(),
                            SizedBox(height: 10),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 10),
                              child: AspectRatio(
                                aspectRatio: 1.6,
                                child: BarChart(
                                  BarChartData(
                                    maxY: controller.getMaxYValue(),
                                    barTouchData: BarTouchData(
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBgColor: Colors.grey,
                                        getTooltipItem: (_a, _b, _c, _d) =>
                                            null,
                                      ),
                                      touchCallback: (response) {
                                        controller.touchCallback(response);
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      leftTitles: SideTitles(
                                        showTitles: false,
                                      ),
                                      rightTitles: SideTitles(
                                        showTitles: true,
                                        getTextStyles: (value) => TextStyle(
                                          color: Colors.black.withOpacity(0.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        margin: 20,
                                        reservedSize: 20,
                                        getTitles: (value) {
                                          return controller
                                              .getRightTitle(value);
                                        },
                                      ),
                                      bottomTitles: SideTitles(
                                        rotateAngle:
                                            controller.isYearTimeFrame ||
                                                    controller.isMonthTimeFrame
                                                ? -50
                                                : controller.isQuarterTimeFrame
                                                    ? 0
                                                    : -90,
                                        showTitles: true,
                                        getTextStyles: (value) => TextStyle(
                                            color: value ==
                                                    controller
                                                        .selectedIndexColumn
                                                        .value
                                                ? kPrimaryColor
                                                : Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                        margin: 15,
                                        getTitles: (double value) {
                                          return controller
                                              .generateVolumeTitle(value);
                                        },
                                      ),
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                      checkToShowHorizontalLine: (value) =>
                                          value % 500 == 0,
                                      getDrawingHorizontalLine: (value) =>
                                          FlLine(
                                        color: const Color(0xffe7e8ec),
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    barGroups: controller.showingBarGroups,
                                  ),
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
                              LocaleKeys.PastContract_NoVolumeData.tr,
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
          ),
        ),
      ),
    );
  }

  Widget _buildUnit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            QuantityUnitEnum.getName(QuantityUnitEnum.MT),
            style: TextStyle(color: kPrimaryGreyColor, fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _buildSubTimeFrameItem(
      SubTimeFrame subTimeFrame, PastContractVolumeController controller) {
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
      child: GetBuilder<PastContractVolumeController>(
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
          }),
    );
  }

  Widget _buildMonthOfYearSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: kLightBlueColor,
      height: 40,
      child: GetBuilder<PastContractVolumeController>(
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
          }),
    );
  }

  Widget _buildMonthOfQuarterSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: kLightBlueColor,
      height: 40,
      width: 200,
      child: GetBuilder<PastContractVolumeController>(
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
          }),
    );
  }
}
