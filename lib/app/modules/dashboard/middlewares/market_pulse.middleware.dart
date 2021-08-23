import 'package:get/get.dart';

import 'package:agree_n/app/modules/dashboard/controllers/market_pulse_list.controller.dart';

class MarketPulseMiddleware extends GetMiddleware {
  @override
  onPageBuildStart(page) {
    MarketPulseListController.to.getData();
    return super.onPageBuildStart(page);
  }
}
