import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/search_box.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/contract/controllers/create_contract.controller.dart';

class SelectSupplierName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchBox(
                hintText: LocaleKeys.CreateContract_SearchSupplierHint.tr,
                onSearch: (name) {
                  controller.searchSupplierName(name);
                },
              ),
              SizedBox(height: 10),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.suppliers
                        .map(
                          (supplier) => RadioListTile(
                            title: Text(supplier.name),
                            value: supplier.supplierId,
                            groupValue:
                                controller.createContractParam.supplierId ?? -1,
                            onChanged: (int) {
                              controller.onSelectSupplier(supplier);
                              Get.back();
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SelectContractType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.contractTypes.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.contractTypes.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createContractParam.contractTypeId ?? -1,
                onChanged: (int contractType) {
                  controller.onContractTypeChanged(contractType);
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

class SelectCoffeeType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.coffeeTypes.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.coffeeTypes.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createContractParam.coffeeTypeId ?? -1,
                onChanged: (int type) {
                  controller.onTypeChanged(type);
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

class SelectQuality extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: controller.grades.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = controller.grades[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createContractParam.gradeTypeId ?? -1,
                onChanged: (int quality) {
                  controller.onSelectQuality(quality);
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

class SelectPackingUnitCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.packingUnitCodes.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.packingUnitCodes.values[index];
              return RadioListTile<int>(
                title: Text('${item.name} (${item.termOptionName})'),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createContractParam.packingUnitTypeId,
                onChanged: (int packingUnitCode) {
                  controller.onSelectPackingUnitCode(packingUnitCode);
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

class SelectQuantityUnit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.quantityUnits.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.quantityUnits.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createContractParam.quantityUnitTypeId,
                onChanged: (int quantityUnit) {
                  controller.onQuantityUnitChanged(quantityUnit);
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

class SelectCertification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.certifications.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.certifications.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue:
                    controller.createContractParam.certificationTypeId ?? -1,
                onChanged: (int certification) {
                  controller.onSelectCertification(certification);
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

class SelectLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.locations.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.locations[index];
              return RadioListTile<int>(
                title: Text(item.name),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue:
                    controller.createContractParam.deliveryWarehouseId ?? -1,
                onChanged: (int location) {
                  controller.onLocationChanged(location);
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

class SelectCommodity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.commodities.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.commodities.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createContractParam.commodityTypeId,
                onChanged: (int commodity) {
                  controller.onSelectCommodity(commodity);
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

class SelectCropYear extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.cropYears.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.cropYears[index];
              return RadioListTile<String>(
                title: Text(item.cropYearName),
                activeColor: kPrimaryColor,
                value: item.cropYearName,
                groupValue:
                    controller.cropYearName.value ?? '',
                onChanged: (String cropYear) {
                  controller.onSelectedCropYear(cropYear);
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

class ContractSelectCoverMonth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateContractController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Container(
            constraints: BoxConstraints(maxHeight: Get.height * 0.4),
            child: ListView.builder(
              itemCount: controller.coverMonths.length,
              primary: true,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final item = controller.coverMonths[index];
                return RadioListTile<String>(
                  title: Text(item.value),
                  activeColor: kPrimaryColor,
                  value: item.value,
                  groupValue: controller.createContractParam.coverMonth ?? '',
                  onChanged: (String coverMonth) {
                    controller.onCoverMonthChanged(coverMonth);
                    Get.back();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
