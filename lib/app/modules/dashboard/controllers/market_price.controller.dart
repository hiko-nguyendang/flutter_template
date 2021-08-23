import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/utils/http_utils.dart';
import 'package:agree_n/app/data/mock/dashboard.mock.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';

class MarketPriceController extends GetxController {
  final DashboardRepository repository;

  MarketPriceController({@required this.repository})
      : assert(repository != null);

  RxList<MarketPriceModel> prices = RxList<MarketPriceModel>();
  RxList<MarketPriceModel> arabicaPrices = RxList<MarketPriceModel>();
  RxList<MarketPriceModel> robustaPrices = RxList<MarketPriceModel>();
  // WebSocketChannel socketChannel =
  //     IOWebSocketChannel.connect(Uri.parse('wss://api.giacaphe.net/stream'));
  RxBool isLoading = false.obs;
  Timer timer;

  @override
  void onInit() {
    _getMarketPrice();
    //Update price after 5 second
    timer = Timer.periodic(new Duration(seconds: 5), (timer) {
      _getMarketPrice();
    });
    super.onInit();
  }

  @override
  void onClose() {
    timer.cancel();
    // socketChannel.sink.close();
    super.onClose();
  }

  Future<void> _getMarketPrice() async {
    isLoading.value = true;
    try {
      HttpResponse response = await repository.getMarketPrice();
      final extractData = response.body;
      if (extractData != null) {
        prices.clear();
        arabicaPrices.clear();
        robustaPrices.clear();
        for (var item in extractData) {
          var priceItem = new MarketPriceModel();
          priceItem.name = item[0];
          priceItem.last = double.parse(item[1].toString());
          priceItem.change = double.parse(item[2].toString());
          priceItem.changePercent = double.parse(item[3].toString());
          priceItem.volume = double.parse(item[4].toString());
          priceItem.high = double.parse(item[5].toString());
          priceItem.low = double.parse(item[6].toString());
          priceItem.open = double.parse(item[7].toString());
          priceItem.previous = double.parse(item[8].toString());
          priceItem.opInt = double.parse(item[9].toString());
          priceItem.bid = double.parse(item[10].toString());
          priceItem.bidSize = double.parse(item[11].toString());
          priceItem.ask = double.parse(item[12].toString());
          priceItem.askSize = double.parse(item[13].toString());
          priceItem.time = item[14];
          priceItem.month = item[15];

          prices.add(priceItem);
        }

        arabicaPrices.addAll([prices[0], prices[1], prices[2], prices[3]]);
        robustaPrices.addAll([prices[4], prices[5], prices[6], prices[7]]);
        //Order by cover month
        arabicaPrices.sort((a, b) => a.month
            .split('/')
            .last
            .compareTo(b.month.split('/').last));
        robustaPrices.sort((a, b) => a.month
            .split('/')
            .last
            .compareTo(b.month.split('/').last));
        isLoading.value = false;
        update();
      }
    } catch (e) {
      prices.addAll(DashboardMock.getMarketPrice());
      arabicaPrices.addAll([prices[0], prices[1], prices[2], prices[3]]);
      robustaPrices.addAll([prices[4], prices[5], prices[6], prices[7]]);
      isLoading.value = false;
      update();
      rethrow;
    }
  }
}
