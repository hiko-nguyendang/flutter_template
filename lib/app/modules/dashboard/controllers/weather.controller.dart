import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';

class WeatherController extends GetxController {
  final DashboardRepository repository;

  WeatherController({@required this.repository}) : assert(repository != null);

  RxString selectedCountry = WeatherLocationEnum.VietNam.obs;
  RxString selectedCountryWeatherImage = ''.obs;
  List<WeatherModel> weathers = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    _getData();
    super.onInit();
  }

  void onSelectCountry(String item) {
    selectedCountry.value = item;
    selectedCountryWeatherImage.value = weathers
        .firstWhere((_) => _.country == selectedCountry.value)
        .urlWeatherImage;
    update();
  }

  Future<void> _getData() async {
    isLoading.value = true;
    await repository.getWeather().then(
      (response) {
        isLoading.value = false;
        if (response != null) {
          weathers = response;
          selectedCountryWeatherImage.value = response
              .firstWhere((_) => _.country == selectedCountry.value)
              .urlWeatherImage;
        }
      },
    );
    update();
  }
}
