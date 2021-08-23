import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';

class BottomSheetHeader extends StatelessWidget {
  final VoidCallback onDone;
  final VoidCallback onClear;

  const BottomSheetHeader({Key key, this.onDone, this.onClear})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              onClear();
            },
            child: Text(
              LocaleKeys.OpenContract_Clear.tr,
              style: TextStyle(
                color: kPrimaryGreyColor.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onDone();
            },
            child: Text(
              LocaleKeys.Shared_Done.tr,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
