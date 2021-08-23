import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/modules/dashboard/widgets/weather_detail.widget.dart';
import 'package:agree_n/app/modules/dashboard/controllers/weather.controller.dart';

class WeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white,
      highlightColor: Colors.white,
      onTap: () {
        Get.to(() => WeatherDetail());
      },
      child: GetBuilder<WeatherController>(
        init: Get.put(
          WeatherController(
            repository: DashboardRepository(
              apiClient: DashboardProvider(),
            ),
          ),
        ),
        builder: (controller) {
          if (controller.selectedCountryWeatherImage.value.isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.DashBoard_NoData.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryGreyColor,
                ),
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(controller),
              Expanded(
                child: controller.isLoading.value
                    ? CupertinoActivityIndicator()
                    : Image.network(
                        controller.selectedCountryWeatherImage.value,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(WeatherController controller) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.DashBoard_Weather.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          _buildSelectCountry(controller),
        ],
      ),
    );
  }

  Widget _buildSelectCountry(WeatherController controller) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(SelectCountry());
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: kPrimaryColor),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              controller.selectedCountry.value,
              style: TextStyle(
                fontSize: 12,
                color: kPrimaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: kPrimaryColor,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
