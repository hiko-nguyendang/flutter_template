import 'package:get/get.dart';

import 'package:agree_n/app/data/providers/lookup.provider.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';
import 'package:agree_n/app/data/repositories/lookup.repository.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/dashboard/controllers/dashboard.controller.dart';
import 'package:agree_n/app/modules/dashboard/controllers/market_pulse_list.controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        repository: DashboardRepository(
          apiClient: DashboardProvider(),
        ),
      ),
    );
    Get.lazyPut<MarketPulseListController>(
      () => MarketPulseListController(
        repository: DashboardRepository(
          apiClient: DashboardProvider(),
        ),
      ),
    );
    Get.put<LookUpController>(
      LookUpController(
        repository: LookUpRepository(
          apiClient: LookUpProvider(),
        ),
      ),
      permanent: true,
    );
  }
}
