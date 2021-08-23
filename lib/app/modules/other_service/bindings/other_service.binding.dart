import 'package:get/get.dart';

import 'package:agree_n/app/data/providers/other_service.provider.dart';
import 'package:agree_n/app/data/repositories/other_service.repository.dart';
import 'package:agree_n/app/modules/other_service/controllers/saved.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/other.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/trucking.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/all_offer.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/packaging.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/machineries.controller.dart';
import 'package:agree_n/app/modules/other_service/controllers/other_service.controller.dart';

class OtherServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherServiceController>(
      () => OtherServiceController(),
    );

    Get.lazyPut<SavedController>(
      () => SavedController(
        repository: OtherServiceRepository(
          apiClient: OtherServiceProvider(),
        ),
      ),
    );

    Get.lazyPut<PackagingController>(
      () => PackagingController(
        repository: OtherServiceRepository(
          apiClient: OtherServiceProvider(),
        ),
      ),
    );

    Get.lazyPut<OtherController>(
      () => OtherController(
        repository: OtherServiceRepository(
          apiClient: OtherServiceProvider(),
        ),
      ),
    );
    Get.lazyPut<MachineriesController>(
      () => MachineriesController(
        repository: OtherServiceRepository(
          apiClient: OtherServiceProvider(),
        ),
      ),
    );
    Get.lazyPut<TruckingController>(
      () => TruckingController(
        repository: OtherServiceRepository(
          apiClient: OtherServiceProvider(),
        ),
      ),
    );

    Get.lazyPut<AllOfferController>(
      () => AllOfferController(
        repository: OtherServiceRepository(
          apiClient: OtherServiceProvider(),
        ),
      ),
    );
  }
}
