import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';

class CurrencyRateController extends GetxController {
  DashboardRepository repository;

  CurrencyRateController({@required this.repository})
      : assert(repository != null);

  List<ExchangeRateModel> marketPrice = [];
  Rx<ExchangeRateModel> _exchangeRate = ExchangeRateModel().obs;
  RxString selectedExchangeRate = CurrencyCodeEnum.USD.obs;
  RxString selectedCountryCode = ''.obs;
  RxBool isLoading = false.obs;

  ExchangeRateModel get exchangeRate => _exchangeRate.value;

  @override
  void onInit() {
    selectedCountryCode.value =
        CurrencyCodeEnum.getCountryCode(selectedExchangeRate.value);
    _getCurrency();
    super.onInit();
  }

  void _getCurrency() async {
    try {
      isLoading.value = true;
      update();
      await repository.getCurrency().then(
        (response) {
          marketPrice = response;
          _exchangeRate.value = marketPrice
              .firstWhere((_) => _.CurrencyCode == CurrencyCodeEnum.USD);
        },
      );
      isLoading.value = false;
      update();
    } catch (e) {
      throw e;
    }
  }

  void onSelectCurrency(String currencyCode) {
    selectedExchangeRate.value = currencyCode;
    selectedCountryCode.value =
        CurrencyCodeEnum.getCountryCode(selectedExchangeRate.value);
    _exchangeRate.value =
        marketPrice.firstWhere((_) => _.CurrencyCode == currencyCode);
    update();
  }
}
