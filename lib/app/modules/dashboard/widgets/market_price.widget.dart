import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/modules/dashboard/widgets/market_price_detail.widget.dart';
import 'package:agree_n/app/modules/dashboard/controllers/market_price.controller.dart';

class MarketPriceWidget extends StatefulWidget {
  @override
  _MarketPriceWidgetState createState() => _MarketPriceWidgetState();
}

class _MarketPriceWidgetState extends State<MarketPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketPriceController>(
      init: Get.put(
        MarketPriceController(
          repository: DashboardRepository(
            apiClient: DashboardProvider(),
          ),
        ),
      ),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return GestureDetector(
          onTap: () {
            Get.to(() => MarketPriceDetailWidget());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                alignment: Alignment.centerLeft,
                child: _buildHeader(),
              ),
/*              StreamBuilder(
                stream: controller.socketChannel.stream,
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return CupertinoActivityIndicator();
                  }
                  return Text(snapshot.data);
                },
              ),*/
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  'Ara KC-ICE',
                  style: TextStyle(
                    fontSize: 10,
                    color: kPrimaryGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildItem(
                      controller.arabicaPrices[0],
                      isArabica: true,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildItem(
                      controller.arabicaPrices[1],
                      isArabica: true,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: kPrimaryGreyColor.withOpacity(0.5),
                  thickness: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  'Rob RC-LIFFE',
                  style: TextStyle(
                    fontSize: 10,
                    color: kPrimaryGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildItem(
                      controller.robustaPrices[0],
                      isArabica: false,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildItem(
                      controller.robustaPrices[1],
                      isArabica: false,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.DashBoard_MarketPrice.tr,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Image.asset(
            'assets/images/giacaphe_logo.png',
            width: 80,
          ),
        )
      ],
    );
  }

  Widget _buildItem(MarketPriceModel data, {bool isArabica}) {
    return Column(
      children: [
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                data.coverMonth,
                style: TextStyle(
                  fontSize: 12,
                  color: kPrimaryGreyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              NumberFormat('###,###.##').format(data.last),
              style: TextStyle(
                fontSize: 18,
                color: data.change < 0 ? Colors.red[600] : kPrimaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                data.change > 0
                    ? '+${NumberFormat('###,###.##').format(data.change)}'
                    : NumberFormat('###,###.##').format(data.change),
                style: TextStyle(
                  fontSize: 12,
                  color: data.change < 0 ? Colors.red : kPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3),
        Text(
          '${NumberFormat('###,###.##').format(data.low)} / '
          '${NumberFormat('###,###.##').format(data.high)}',
          style: TextStyle(
            fontSize: 11,
            color: kPrimaryGreyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                LinearPercentIndicator(
                  width: 70,
                  lineHeight: 10,
                  percent:
                      isArabica ? data.arabicaOIPercent : data.robustaOIPercent,
                  linearGradient: data.change < 0
                      ? LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: <Color>[
                            Colors.red.withOpacity(0.7),
                            Colors.red
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: <Color>[
                            kPrimaryColor.withOpacity(0.7),
                            kPrimaryColor
                          ],
                        ),
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.all(0),
                  isRTL: true,
                  linearStrokeCap: LinearStrokeCap.butt,
                ),
                Positioned(
                  top: 1,
                  child: Text(
                    NumberFormat('###,###.##').format(data.opInt),
                    style: TextStyle(
                      fontSize: 7,
                      color: kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: kPrimaryGreyColor,
              height: 18,
              width: 2,
            ),
            Stack(
              children: [
                LinearPercentIndicator(
                  width: 70,
                  lineHeight: 10,
                  percent: isArabica
                      ? data.arabicaVolumePercent
                      : data.robustaVolumePercent,
                  padding: const EdgeInsets.all(0),
                  backgroundColor: Colors.grey[100],
                  linearStrokeCap: LinearStrokeCap.butt,
                  linearGradient: data.change < 0
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Colors.red.withOpacity(0.7),
                            Colors.red
                          ], // red to y
                        )
                      : LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            kPrimaryColor.withOpacity(0.7),
                            kPrimaryColor
                          ], // red to y
                        ),
                ),
                Positioned(
                  top: 1,
                  right: 0,
                  child: Text(
                    NumberFormat('###,###.##').format(data.volume),
                    style: TextStyle(
                      fontSize: 7,
                      color: kPrimaryGreyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: Wrap(
            spacing: 20,
            children: [
              Text(
                'OI',
                style: TextStyle(
                  fontSize: 8,
                  color: data.change < 0 ? Colors.red : kPrimaryColor,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.end,
              ),
              Text(
                'VOL',
                style: TextStyle(
                  fontSize: 8,
                  color: data.change < 0 ? Colors.red : kPrimaryColor,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
