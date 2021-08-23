import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_performance.controller.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_performance_chart.widget.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_performance_filter.widget.dart';

class PastContractsPerformance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<PastContractPerformanceController>(
        init: Get.find(),
        builder: (controller) {
          return Column(
            children: [
              PastContractsPerformanceFilter(),
              PastContractsPerformanceChart(),
              _buildFilteredResult(controller),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRatingDetail(String ratingType, double percents,
      PastContractPerformanceController controller) {
    controller.calculateRating(percents);
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    ratingType,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  Icons.help,
                  color: kPrimaryColor,
                  size: 17,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothStarRating(
                  rating: controller.rating.value,
                  isReadOnly: true,
                  size: 17,
                  color: kLightYellowColor,
                  borderColor: Colors.grey,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  onRated: (value) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    NumberFormat('###,###.##').format(percents) + "%",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredResult(PastContractPerformanceController controller) {
    if (controller.isGettingData.value) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: CupertinoActivityIndicator(),
      );
    }
    return controller.contractPerformanceSeriesDetail != null &&
            !controller.alreadyChangeTimeFrameType.value
        ? ShapeOfView(
            clipBehavior: Clip.antiAlias,
            shape: BubbleShape(
                position: BubblePosition.Top,
                arrowPositionPercent: 0.5,
                borderRadius: 0,
                arrowHeight: 10,
                arrowWidth: 10),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(controller.deliveryDate()),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.tenantScores.length,
                    itemBuilder: (context, index) {
                      final item = controller.tenantScores[index];
                      return _buildRatingDetail(
                          ScoreTypeEnum.getName(item.scoreTypeId),
                          item.value,
                          controller);
                    },
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }
}
