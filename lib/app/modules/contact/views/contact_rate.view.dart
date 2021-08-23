import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/screen_header.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/data/providers/contact.provider.dart';
import 'package:agree_n/app/data/repositories/contact.repository.dart';
import 'package:agree_n/app/modules/contact/controllers/contact_rate.controller.dart';

class ContactRateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<ContactRateController>(
        init: Get.put(
          ContactRateController(
            repository: ContactRepository(
              apiClient: ContactProvider(),
            ),
          ),
        ),
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return Column(
            children: [
              ScreenHeader(
                title: controller.contactRate.value.contactName,
                showBackButton: true,
                showSubTile: true,
                subTile: Text(
                  '${LocaleKeys.Supplier_Score.tr} '
                  '${controller.contactRate.value.contactScore}%',
                  style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryBlueColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 20),
              _buildRatingInfo(controller)
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildRatingInfo(ContactRateController controller) {
    return ShadowBox(
      margin: const EdgeInsets.symmetric(horizontal: kHorizontalContentPadding),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.Supplier_About.tr,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              '${LocaleKeys.Supplier_NumberContracts.tr}: '
              '${controller.contactRate.value.numberOfContracts}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '${LocaleKeys.Supplier_MemberSince.tr}: '
            '${DateFormat('MMM, dd yyyy').format(controller.contactRate.value.createdDate)}',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: controller.contactRate.value.contactRates.length,
            itemBuilder: (context, index) {
              final item = controller.contactRate.value.contactRates[index];
              return _buildRatingDetail(
                  ScoreTypeEnum.getName(item.scoreTypeId), item.value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDetail(String ratingType, double percents) {
    double calculateRating() {
      //a = x.y
      final a = percents / 20;
      final x = (a).toInt();
      var y = a - x;
      if (y > 0 && y < 1.0) {
        y = 0.5;
      }
      return x + y;
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    ratingType,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  Icons.help,
                  color: kPrimaryColor,
                  size: 17,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothStarRating(
                  rating: calculateRating(),
                  isReadOnly: true,
                  size: 16,
                  color: kLightYellowColor,
                  borderColor: Colors.grey,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  onRated: (value) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    '$percents%',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
