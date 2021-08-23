import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/modules/dashboard/controllers/weather.controller.dart';

class WeatherDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: GetBuilder<WeatherController>(
        init: Get.find(),
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: _buildSelectCountry(controller),
                ),
                Image.network(
                  controller.selectedCountryWeatherImage.value,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectCountry(WeatherController controller) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(SelectCountry());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: kPrimaryColor),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              controller.selectedCountry.value,
              style: TextStyle(
                fontSize: 14,
                color: kPrimaryBlackColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black.withOpacity(0.8),
            )
          ],
        ),
      ),
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
              LocaleKeys.DashBoard_Weather.tr,
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
}

class SelectCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: controller.weathers.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = controller.weathers[index];
              return RadioListTile<String>(
                title: Text(item.country),
                activeColor: kPrimaryColor,
                value: item.country,
                groupValue: controller.selectedCountry.value,
                onChanged: (String country) {
                  controller.onSelectCountry(country);
                  Get.back();
                },
              );
            },
          ),
        );
      },
    );
  }
}
