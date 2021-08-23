import 'package:flag/flag.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/modules/base/controllers/base.controller.dart';

class LanguageView extends GetView<BaseController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Container(
          child: Text(
            LocaleKeys.Navigation_Language.tr,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kHorizontalContentPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnglish(),
            Divider(
              color: Colors.black.withOpacity(0.5),
              height: 20,
              thickness: 0.3,
            ),
            _buildVietNam(),
          ],
        ),
      ),
    );
  }

  Widget _buildVietNam() {
    return InkWell(
      onTap: () {
        controller.updateLanguage(LanguageEnum.Vietnam);
      },
      splashColor: Colors.white,
      highlightColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 10,
            children: [
              Flag(
                'vn',
                height: 20,
                width: 30,
                fit: BoxFit.cover,
              ),
              Text(
                LocaleKeys.Language_Vietnam.tr,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          if (controller.currentLanguage == LanguageEnum.Vietnam)
            Icon(
              Icons.done,
              color: kPrimaryColor,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildEnglish() {
    return InkWell(
      onTap: () {
        controller.updateLanguage(LanguageEnum.English);
      },
      splashColor: Colors.white,
      highlightColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 10,
            children: [
              Flag(
                'gb',
                height: 20,
                width: 30,
                fit: BoxFit.cover,
              ),
              Text(
                LocaleKeys.Language_English.tr,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          if (controller.currentLanguage == LanguageEnum.English)
            Icon(
              Icons.done,
              color: kPrimaryColor,
              size: 20,
            ),
        ],
      ),
    );
  }
}
