import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/modules/dashboard/controllers/market_price.controller.dart';

class MarketPriceDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketPriceController>(
      init: Get.find(),
      builder: (controller) {
        if (controller.isLoading.value)
          return Center(
            child: CupertinoActivityIndicator(),
          );
        return Scaffold(
          appBar: _buildAppBar(),
          body: controller.prices.isNotEmpty
              ? _buildPriceTable(controller)
              : Container(
                  padding: const EdgeInsets.only(top: 180),
                  child: Text(
                    LocaleKeys.Shared_ErrorMessage.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kHorizontalContentPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.white,
              ),
            ),
            Text(
              LocaleKeys.MarketPrice_Title.tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.NAVIGATION);
              },
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 25,
              ),
            )
          ],
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildPriceTable(MarketPriceController controller) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            _buildTitle('KC-ICE'),
            _buildArabica(controller),
            _buildTitle('RC-LIFFE'),
            _buildRobusta(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String name) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          Image.asset(
            'assets/icons/trading.png',
            height: 20,
            width: 20,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArabica(MarketPriceController controller) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryBlackColor.withOpacity(0.3),
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: HorizontalDataTable(
        tableHeight: 153,
        leftHandSideColumnWidth: 70,
        rightHandSideColumnWidth: 420,
        isFixedHeader: true,
        itemCount: controller.arabicaPrices.length,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: (context, index) {
          return _generateFirstColumnRow(controller.arabicaPrices[index].month);
        },
        rightSideItemBuilder: (context, index) {
          return _generateRightHandSideColumnRow(
              controller.arabicaPrices[index]);
        },
        rowSeparatorWidget: Divider(
          color: Colors.white,
          height: 1.0,
          thickness: 0.0,
        ),
        verticalScrollbarStyle: const ScrollbarStyle(
          isAlwaysShown: true,
          thickness: 0,
          radius: Radius.circular(5.0),
        ),
        horizontalScrollbarStyle: const ScrollbarStyle(
          isAlwaysShown: true,
          thickness: 1,
          radius: Radius.circular(5.0),
        ),
      ),
    );
  }

  Widget _buildRobusta(MarketPriceController controller) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryBlackColor.withOpacity(0.3),
            blurRadius: 3,
            offset: Offset(0, 1),
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: HorizontalDataTable(
        tableHeight: 153,
        leftHandSideColumnWidth: 70,
        rightHandSideColumnWidth: 420,
        isFixedHeader: true,
        itemCount: controller.robustaPrices.length,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: (context, index) {
          return _generateFirstColumnRow(controller.robustaPrices[index].month);
        },
        rightSideItemBuilder: (context, index) {
          return _generateRightHandSideColumnRow(
              controller.robustaPrices[index]);
        },
        rowSeparatorWidget: Divider(
          color: Colors.white,
          height: 1.0,
          thickness: 0.0,
        ),
        verticalScrollbarStyle: const ScrollbarStyle(
          isAlwaysShown: true,
          thickness: 0,
          radius: Radius.circular(5.0),
        ),
        horizontalScrollbarStyle: const ScrollbarStyle(
          isAlwaysShown: true,
          thickness: 1,
          radius: Radius.circular(5.0),
        ),
      ),
    );
  }

  Widget _generateFirstColumnRow(String month) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: 30,
      alignment: Alignment.center,
      child: Text(
        '${MonthEnum.getName(int.parse(month.split('/')[0])).toUpperCase()} '
        '${month.split('/')[1]}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(MarketPriceModel value) {
    return Row(
      children: <Widget>[
        _buildRightColumnValue(value.last),
        _buildRightColumnValue(value.change, hasBgColor: true),
        _buildRightColumnValue(value.high),
        _buildRightColumnValue(value.low),
        _buildRightColumnValue(value.volume),
        _buildRightColumnValue(value.opInt),
      ],
    );
  }

  Widget _buildRightColumnValue(double value, {bool hasBgColor = false}) {
    if (hasBgColor) {
      return Container(
        width: 70,
        height: 30,
        color: value < 0
            ? Color(0xffffc8ce)
            : value == 0
                ? Colors.white
                : Color(0xffc6efcd),
        alignment: Alignment.center,
        child: Text(
          NumberFormat('###,###.##').format(value),
          style: TextStyle(
            fontSize: 14,
            color: value <= 0
                ? kPrimaryBlackColor
                : kPrimaryColor.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return Container(
      width: 70,
      height: 30,
      alignment: Alignment.center,
      child: Text(
        NumberFormat('###,###.##').format(value),
        style: TextStyle(
          fontSize: 14,
          color: kPrimaryBlackColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget(LocaleKeys.MarketPrice_Month.tr.toUpperCase()),
      _getTitleItemWidget(LocaleKeys.MarketPrice_Settle.tr.toUpperCase()),
      _getTitleItemWidget(LocaleKeys.MarketPrice_Change.tr.toUpperCase()),
      _getTitleItemWidget(LocaleKeys.MarketPrice_High.tr.toUpperCase()),
      _getTitleItemWidget(LocaleKeys.MarketPrice_Low.tr.toUpperCase()),
      _getTitleItemWidget(LocaleKeys.MarketPrice_Volume.tr.toUpperCase()),
      _getTitleItemWidget(LocaleKeys.MarketPrice_OI.tr.toUpperCase()),
    ];
  }

  Widget _getTitleItemWidget(String label) {
    return Container(
      width: 70,
      height: 30,
      color: kPrimaryColor.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: kPrimaryBlackColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
