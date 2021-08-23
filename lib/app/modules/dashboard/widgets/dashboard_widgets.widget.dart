import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/dashboard/widgets/weather.widget.dart';
import 'package:agree_n/app/modules/dashboard/widgets/market_pulse.widget.dart';
import 'package:agree_n/app/modules/dashboard/widgets/market_price.widget.dart';
import 'package:agree_n/app/modules/dashboard/widgets/currency_rate.widget.dart';

class DashboardWidgets extends StatefulWidget {
  @override
  _DashboardWidgetsState createState() => _DashboardWidgetsState();
}

class _DashboardWidgetsState extends State<DashboardWidgets> {
  final AuthController _authController = Get.find();
  int _current = 0;
  List<Widget> _widgets = [];

  @override
  void initState() {
    _checkUserPermission();
    super.initState();
  }

  void _checkUserPermission() {
    if (_authController.currentUser.hasMarketNewsPostWidget ||
        _authController.currentUser.hasMarketNewsWidget) {
      _widgets.add(MarketPulseWidget());
    }
    if (_authController.currentUser.hasMarketPriceWidget) {
      _widgets.add(MarketPriceWidget());
    }
    if (_authController.currentUser.hasCurrencyRateWidget) {
      _widgets.add(CurrencyRateWidget());
    }
    if (_authController.currentUser.hasWeatherWidget) {
      _widgets.add(WeatherWidget());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: _widgets.length,
            options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: false,
              autoPlay: false,
              aspectRatio: Get.width / 240,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            itemBuilder: (ctx, index, realIdx) {
              return ShadowBox(
                width: Get.width,
                borderRadius: 15,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: _widgets[index],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _widgets.map(
              (Widget wid) {
                final isSelected = wid.runtimeType.toString() ==
                    _widgets[_current].runtimeType.toString();
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? kPrimaryColor
                        : kPrimaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
