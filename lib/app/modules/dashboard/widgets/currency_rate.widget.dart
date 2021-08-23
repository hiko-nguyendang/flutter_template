import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/modules/dashboard/widgets/currency_rate_list.widget.dart';
import 'package:agree_n/app/modules/dashboard/controllers/currency_rate.controller.dart';

class CurrencyRateWidget extends StatefulWidget {
  @override
  _CurrencyRateWidgetState createState() => _CurrencyRateWidgetState();
}

class _CurrencyRateWidgetState extends State<CurrencyRateWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyRateController>(
      init: Get.put(
        CurrencyRateController(
          repository: DashboardRepository(
            apiClient: DashboardProvider(),
          ),
        ),
      ),
      builder: (controller) {
        return InkWell(
          onTap: () {
            Get.to(
              () => CurrencyRateListWidget(
                marketPrice: controller.marketPrice,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: _buildHeader(controller),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    _buildCalendar(),
                    SizedBox(height: 5),
                    controller.isLoading.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: CupertinoActivityIndicator(),
                          )
                        : _buildForm(controller),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    return Row(
      children: [
        Image.asset(
          'assets/icons/calander.png',
          height: 20,
          width: 20,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 3),
        Text(
          DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now()),
          style: TextStyle(
            fontSize: 11,
            color: kPrimaryGreyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Image.asset(
          'assets/icons/vietcombank_logo.jpg',
          height: 25,
          width: 25,
        ),
      ],
    );
  }

  Widget _buildHeader(CurrencyRateController controller) {
    return Row(
      children: [
        Text(
          LocaleKeys.DashBoard_CurrencyRate.tr,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Flag(
            controller.selectedCountryCode.value,
            height: 20,
            width: 20,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 20,
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: _buildCurrencyCodeDropdown(controller),
        ),
      ],
    );
  }

  Widget _buildForm(CurrencyRateController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: kPrimaryGreyColor.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    LocaleKeys.CurrencyRate_Transfer.tr.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: kPrimaryGreyColor,
                    ),
                  ),
                  Text(
                    controller.exchangeRate.transferValue,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: kPrimaryGreyColor.withOpacity(0.5),
                            width: 0.5,
                          ),
                          right: BorderSide(
                            color: kPrimaryGreyColor.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            LocaleKeys.CurrencyRate_Buy.tr.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryGreyColor,
                            ),
                          ),
                          Text(
                            controller.exchangeRate.buyValue,
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: kPrimaryGreyColor.withOpacity(0.5),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            LocaleKeys.CurrencyRate_Sell.tr.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryGreyColor,
                            ),
                          ),
                          Text(
                            controller.exchangeRate.sellValue,
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyCodeDropdown(CurrencyRateController controller) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: false,
        hint: Text(
          controller.selectedExchangeRate.value,
          style: TextStyle(
            fontSize: 12,
            color: kPrimaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          size: 20,
          color: kPrimaryColor,
        ),
        onChanged: (currencyCode) {
          controller.onSelectCurrency(currencyCode);
        },
        items: CurrencyCodeEnum.currenciesCode
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
