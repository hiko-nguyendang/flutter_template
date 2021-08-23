import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';

class ButtonSendOffer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: Get.find(),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            Get.focusScope.unfocus();
            controller.sendOffer();
          },
          child: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: kPrimaryGreyColor.withOpacity(0.5),
              ),
            ),
            child: Icon(Icons.arrow_forward),
          ),
        );
      },
    );
  }
}
