import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shape_of_view/shape_of_view.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_price_filter.dart';
import 'package:agree_n/app/modules/contract/widgets/past_contracts_price_chart.widget.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_price.controller.dart';

class PastContractsPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<PastContractPriceController>(
        init: Get.find(),
        builder: (controller) {
          return Column(
            children: [
              PastContractsPriceFilter(),
              PastContractsPriceChart(),
              _buildFilteredResult(controller),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilteredResult(PastContractPriceController controller) {
    if (controller.isGettingData.value) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: CupertinoActivityIndicator(),
      );
    }
    return controller.pastContractDetails.length != 0 &&
            !controller.alreadyChangeTimeFrameType.value
        ? ShapeOfView(
            clipBehavior: Clip.antiAlias,
            shape: BubbleShape(
              position: BubblePosition.Top,
              arrowPositionPercent: 0.5,
              borderRadius: 0,
              arrowHeight: 10,
              arrowWidth: 10,
            ),
            child: ListView.builder(
              itemCount: controller.pastContractDetails.length,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 10),
              itemBuilder: (context, index) {
                final item = controller.pastContractDetails[index];
                return Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: index == 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            controller.deliveryDate(),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            NumberFormat('###,###.##').format(item.value) +
                                " " +
                                item.unit,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(' from ${item.tenantName}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : SizedBox();
  }
}
