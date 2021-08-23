import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/widgets/shadow_box.dart';
import 'package:agree_n/app/widgets/favorite_icon.dart';
import 'package:agree_n/app/data/models/other_service.model.dart';

class MachineryItem extends StatelessWidget {
  final SwiperController swipeController;
  final OtherServiceModel item;
  final dynamic controller;

  const MachineryItem({
    Key key,
    @required this.item,
    @required this.swipeController,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      borderRadius: 0,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.tenantName,
                  style: TextStyle(
                    fontSize: 16,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FavoriteIcon(
                isFavorite: item.isFavorite,
                onTap: () {
                  controller.updateFavorite(item.offerId, item.isFavorite);
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 5, bottom: 10),
            margin: const EdgeInsets.only(top: 5, bottom: 10),
            color: kPrimaryGreyColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    LocaleKeys.OtherServices_NameOfMachine.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: kPrimaryBlackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.machinery.machineryName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.OtherServices_Brand.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: kPrimaryBlackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item.machinery.branchName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: kPrimaryBlackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    LocaleKeys.OtherServices_Status.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: kPrimaryBlackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  MachineryStatusEnum.getName(
                                      item.machinery.statusId),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      LocaleKeys
                                          .OtherServices_YearOfProduction.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: kPrimaryBlackColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.machinery.yearOfManufacture.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: kPrimaryBlackColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    LocaleKeys.CreateOffer_Price.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: kPrimaryBlackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${NumberFormat('###,###.##').format(item.machinery.price)} '
                                  '${TermName.priceUnitName(item.machinery.priceUnitTypeId)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kPrimaryBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                if (item.comments != null && item.comments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.5),
                    child: InkWell(
                      onTap: () {
                        controller.updateSeeMore(item);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: LocaleKeys.OtherServices_Comments.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: kPrimaryBlackColor,
                            fontWeight: FontWeight.w600,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: item.isMore
                                  ? '${item.firstHalf}... '
                                  : '${item.firstHalf} ${item.secondHalf}',
                              style: TextStyle(
                                fontSize: 14,
                                color: kPrimaryBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (item.commentHasMore)
                              TextSpan(
                                text: item.isMore
                                    ? LocaleKeys.OtherServices_SeeMore.tr
                                    : LocaleKeys.OtherServices_SeeLess.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryBlueColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.onChat(item.offerId);
            },
            child: Container(
              alignment: Alignment.center,
              width: Get.width * 0.35,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                LocaleKeys.Shared_Chat.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (item.urlImages == null || item.urlImages.isEmpty) {
      return Expanded(
        flex: 4,
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(right: 10),
          color: kPrimaryGreyColor.withOpacity(0.2),
        ),
      );
    }
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () {
          Get.dialog(_buildViewImages(item),
              barrierDismissible: false,
              useSafeArea: false,
              barrierColor: Colors.black);
        },
        child: Container(
          height: 120,
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(item.urlImages.first),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: kPrimaryGreyColor,
                      size: 10,
                    ),
                    Text(
                      '(${item.urlImages.length})',
                      style: TextStyle(
                        fontSize: 10,
                        color: kPrimaryGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewImages(OtherServiceModel item) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Swiper(
        controller: swipeController,
        itemCount: item.urlImages.length,
        loop: false,
        itemBuilder: (context, index) {
          return PhotoView(
            imageProvider: NetworkImage(item.urlImages[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 1.5,
            initialScale: PhotoViewComputedScale.covered * 0.01,
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
          );
        },
      ),
    );
  }
}
