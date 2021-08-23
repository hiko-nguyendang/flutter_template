import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/other_service.model.dart';

class PackagingSpecification extends StatefulWidget {
  @override
  _PackagingSpecificationState createState() => _PackagingSpecificationState();
}

class _PackagingSpecificationState extends State<PackagingSpecification> {
  PackagingModel packagingModel;

  @override
  void initState() {
    super.initState();
    packagingModel = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          ScreenTitle(
            title: LocaleKeys.OtherServices_Packaging_Specification.tr,
            onBack: () {
              Get.back();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_MeasuringUnit.tr,
                      MeasuringUnitEnum.getName(
                              packagingModel.measuringUnitTypeId)
                          .toString()),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Length.tr,
                      NumberFormat().format(packagingModel.lengthOfBag),
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Width.tr,
                      NumberFormat().format(packagingModel.widthOfBag)),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_WeightOfBag.tr,
                      NumberFormat().format(packagingModel.weightOfBag),
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Grade.tr,
                      packagingModel.gradeType),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Treatment.tr,
                      packagingModel.treatment,
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_BagType.tr,
                      BagTypeEnum.getName(packagingModel.bagTypeId).toString()),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Printing.tr,
                      packagingModel.printing.toString(),
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_NoOfColours.tr,
                      packagingModel.noOfColors.toString()),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Stripes.tr,
                      packagingModel.stripes.toString(),
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Moisture.tr,
                      NumberFormat().format(packagingModel.moisture)),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Extra.tr,
                      packagingModel.extra.toString(),
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_SpecialDocs.tr,
                      packagingModel.specialDocument.toString()),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Packing.tr,
                      packagingModel.packing.toString(),
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Loading.tr,
                      packagingModel.loading.toString()),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_Compliance.tr,
                      packagingModel.compliance.toString(),
                      odd: false),
                  _buildSpecification(
                      LocaleKeys.OtherServices_Packaging_SpecialInstruction.tr,
                      packagingModel.specialInstruction.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecification(String title, String value, {bool odd = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: odd ? Colors.grey.withOpacity(0.2) : Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(
                title ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              )),
          Expanded(
              flex: 6,
              child: Text(
                value ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              )),
        ],
      ),
    );
  }
}
