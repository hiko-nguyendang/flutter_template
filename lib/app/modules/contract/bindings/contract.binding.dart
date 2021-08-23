import 'package:get/get.dart';

import 'package:agree_n/app/data/providers/contract.provider.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/open_contract.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/create_contract.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/finalize_contract.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_price.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_volume.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/past_contract_performance.controller.dart';

class ContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpenContractController>(
      () => OpenContractController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );
    Get.lazyPut<CreateContractController>(
      () => CreateContractController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );
    Get.lazyPut<PastContractController>(
      () => PastContractController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );
    Get.lazyPut<PastContractVolumeController>(
      () => PastContractVolumeController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );
    Get.lazyPut<PastContractPriceController>(
      () => PastContractPriceController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );
    Get.lazyPut<PastContractPerformanceController>(
      () => PastContractPerformanceController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );
    Get.lazyPut<PastContractPerformanceController>(
      () => PastContractPerformanceController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );

    Get.lazyPut<FinalizeContractController>(
      () => FinalizeContractController(
        repository: ContractRepository(
          apiClient: ContractProvider(),
        ),
      ),
    );
  }
}
