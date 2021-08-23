import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/modules/offer/controllers/create_offer.controller.dart';

class EditRequestHeader extends StatelessWidget {
  const EditRequestHeader({Key key, @required this.controller})
      : super(key: key);
  final CreateOfferController controller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.isEdit.value,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Arabica, 500 MT 36,000 VND/KG',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Posted yesterday',
                    style: TextStyle(
                        color: kPrimaryGreyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.clear,
                size: 25,
                color: kPrimaryBlackColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
