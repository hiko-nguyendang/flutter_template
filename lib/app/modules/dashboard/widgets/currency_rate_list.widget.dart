import 'package:agree_n/app/enums/enums.dart';
import 'package:get/get.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/instance_manager.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';

class CurrencyRateListWidget extends StatefulWidget {
  final List<ExchangeRateModel> marketPrice;

  const CurrencyRateListWidget({Key key, this.marketPrice}) : super(key: key);

  @override
  _CurrencyRateListWidgetState createState() => _CurrencyRateListWidgetState();
}

class _CurrencyRateListWidgetState extends State<CurrencyRateListWidget> {
  ExchangeRateModel krExchangeRate = ExchangeRateModel();
  ExchangeRateModel inExchangeRate = ExchangeRateModel();
  ExchangeRateModel euExchangeRate = ExchangeRateModel();
  ExchangeRateModel cnExchangeRate = ExchangeRateModel();
  ExchangeRateModel jpExchangeRate = ExchangeRateModel();
  ExchangeRateModel sgExchangeRate = ExchangeRateModel();
  ExchangeRateModel usExchangeRate = ExchangeRateModel();

  @override
  void initState() {
    _filterData();
    super.initState();
  }

  void _filterData() {
    krExchangeRate = widget.marketPrice.firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.KRW);
    inExchangeRate = widget.marketPrice.firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.INR);
    euExchangeRate = widget.marketPrice.firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.EUR);
    cnExchangeRate = widget.marketPrice.firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.CNY);
    jpExchangeRate = widget.marketPrice.firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.JPY);
    sgExchangeRate = widget.marketPrice.firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.SGD);
    usExchangeRate = widget.marketPrice.firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.USD);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: _buildItem(
          'US',
          'US DOLLAR',
          Colors.white,
          usExchangeRate,
          _buildItem(
            'CN',
            'YUAN RENMINBI',
            kLightGreenColor,
            cnExchangeRate,
            _buildItem(
              'EU',
              'EURO',
              Colors.white,
              euExchangeRate,
              _buildItem(
                'KR',
                'KOREAN WON',
                kLightGreenColor,
                krExchangeRate,
                _buildItem(
                  'JP',
                  'JAPANESE YEN',
                  Colors.white,
                  jpExchangeRate,
                  _buildItem(
                    'SG',
                    'SINGAPORE DOLLAR',
                    kLightGreenColor,
                    sgExchangeRate,
                    _buildItem(
                      'IN',
                      'INDIAN RUPEE',
                      Colors.white,
                      inExchangeRate,
                      SizedBox(height: 30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String flag, String name, Color bgColor,
      ExchangeRateModel currency, Widget child) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          margin: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: Offset(0, 0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.21,
                      child: Text(
                        LocaleKeys.CurrencyRate_Name.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryGreyColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        LocaleKeys.CurrencyRate_Code.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryGreyColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: Text(
                        LocaleKeys.CurrencyRate_Buy.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryGreyColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: Text(
                        LocaleKeys.CurrencyRate_Sell.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryGreyColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: Text(
                        LocaleKeys.CurrencyRate_Transfer.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryGreyColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * 0.21,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 13,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        currency.CurrencyCode,
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: Text(
                        currency.buyValue,
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: Text(
                        currency.sellValue,
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.2,
                      child: Text(
                        currency.transferValue,
                        style: TextStyle(
                          fontSize: 14,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              child,
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 15,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Flag(
              flag,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Row(
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
            LocaleKeys.CurrencyRate_ForeignExchangeRate.tr,
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
      automaticallyImplyLeading: false,
    );
  }
}
