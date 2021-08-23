import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/offer/controllers/create_offer.controller.dart';

class OfferSelectAudience extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: controller.audiences.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = controller.audiences[index];
              return RadioListTile<int>(
                title: Text(AudienceEnum.getName(item)),
                activeColor: kPrimaryColor,
                value: item,
                groupValue: controller.createOfferParam.audienceTypeId ?? -1,
                onChanged: (int audience) {
                  controller.onAudienceChanged(audience);
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

class OfferSelectCoverMonth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
                  groupValue: controller.createOfferParam.coverMonth ?? '',
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

class OfferSelectCurrency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.priceUnits.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.priceUnits.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createOfferParam.priceUnitTypeId ?? -1,
                onChanged: (int priceUnit) {
                  controller.onCurrencyChanged(priceUnit);
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

class OfferSelectDeliveryTerm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          constraints: BoxConstraints(maxHeight: Get.height * 0.5),
          child: ListView.builder(
            itemCount: LookUpController.to.deliveryTerms.values.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.deliveryTerms.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createOfferParam.deliveryTermId ?? -1,
                onChanged: (int deliveryTerm) {
                  controller.onDeliveryTermChanged(deliveryTerm);
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

class OfferSelectGrade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
                groupValue: controller.createOfferParam.gradeTypeId ?? -1,
                onChanged: (int grade) {
                  controller.onGradeChanged(grade);
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

class OfferSelectLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
                    controller.createOfferParam.deliveryWarehouseId ?? -1,
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

class OfferSelectCoffeeType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
                groupValue: controller.createOfferParam.coffeeTypeId,
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

class OfferSelectTypeOfContract extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
                groupValue: controller.createOfferParam.contractTypeId ?? -1,
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

class OfferSelectUnit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = LookUpController.to.quantityUnits.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createOfferParam.quantityUnitTypeId,
                onChanged: (int unit) {
                  controller.onUnitChanged(unit);
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

class OfferSelectCommodity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
                groupValue: controller.createOfferParam.commodityId,
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

class OfferSelectPackingUnitCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
                groupValue: controller.createOfferParam.packingUnitTypeId,
                onChanged: (int packingUnitId) {
                  controller.onSelectPackingUnitCode(packingUnitId);
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

class OfferSelectCertification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateOfferController>(
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            itemBuilder: (context, index) {
              final item = LookUpController.to.certifications.values[index];
              return RadioListTile<int>(
                title: Text(item.termOptionName),
                activeColor: kPrimaryColor,
                value: item.id,
                groupValue: controller.createOfferParam.certificationId ?? -1,
                onChanged: (int certificationId) {
                  controller.onSelectCertification(certificationId);
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
