import 'package:get/get.dart';

import 'package:agree_n/app/data/repositories/offer.repository.dart';
import 'package:agree_n/app/data/providers/offer.provider.dart';
import 'package:agree_n/app/modules/offer/controllers/create_offer.controller.dart';
import 'package:agree_n/app/modules/offer/controllers/buyer_offer.controller.dart';
import 'package:agree_n/app/modules/offer/controllers/supplier_offer.controller.dart';

class OfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerOfferController>(
      () => BuyerOfferController(
        repository: OfferRepository(
          apiClient: OfferProvider(),
        ),
      ),
    );

    Get.lazyPut<SupplierOfferController>(
          () => SupplierOfferController(
        repository: OfferRepository(
          apiClient: OfferProvider(),
        ),
      ),
    );

    Get.lazyPut<CreateOfferController>(
      () => CreateOfferController(
        repository: OfferRepository(
          apiClient: OfferProvider(),
        ),
      ),
    );

  }
}
