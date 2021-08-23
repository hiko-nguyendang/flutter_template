import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';

class TermUnitInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: Get.find(),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            Get.focusScope.unfocus();
            final contractTypeTerm = controller.terms
                .firstWhere((_) => _.id == TermTypeIdEnum.ContractType);

            if (controller.currentTerm.id == TermTypeIdEnum.Price &&
                TermName.contractTypeName(
                        int.parse(contractTypeTerm.value.toString())) ==
                    LocaleKeys.TermOptionName_Outright.tr) {
              return;
            }else{
              _showUnit(controller);
            }
          },
          child: Text(
            controller.currentTerm.unitDisplayName,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }

  Future<void> _showUnit(ChatController controller) {
    return Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.5),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            topLeft: Radius.circular(5),
          ),
        ),
        child: ListView.builder(
          itemCount: controller.currentTerm.options.length,
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (context, index) {
            final option = controller.currentTerm.options[index];
            if (controller.currentTerm.id == TermTypeIdEnum.CoverMonth) {
              return RadioListTile<String>(
                title: Text(option.termOptionName),
                activeColor: kPrimaryColor,
                value: option.displayName,
                groupValue: controller.currentTerm.unit != null
                    ? controller.currentTerm.unit
                    : '',
                onChanged: (String unit) {
                  controller.onTermUnitChanged(unit);
                  //
                  Get.back();
                },
              );
            }
            return RadioListTile<int>(
              title: Text(option.displayName),
              activeColor: kPrimaryColor,
              value: option.id,
              groupValue: controller.currentTerm.unit != null
                  ? int.parse(controller.currentTerm.unit.toString())
                  : -1,
              onChanged: (int unit) {
                controller.onTermUnitChanged(unit);
                //
                Get.back();
              },
            );
          },
        ),
      ),
    );
  }
}
