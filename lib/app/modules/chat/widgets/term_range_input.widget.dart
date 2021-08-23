import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/contract/views/buyer_input_contract.view.dart';
import 'package:agree_n/app/modules/contract/views/buyer_submit_contract.view.dart';

class TermRangeInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const TermRangeInput({Key key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(color: Color(0xffeef7f4)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.offerNegotiationStatus !=
                      NegotiationStatusType.Finalized &&
                  controller.offerNegotiationStatus !=
                      NegotiationStatusType.FinalizePending)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showTermOption(controller);
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff1d9d6d),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Text(
                            controller.currentTerm.value != null
                                ? controller.currentTerm.value
                                    .toString()
                                    .trim()
                                    .split('-')
                                    .last
                                : '${LocaleKeys.Chat_PleaseSelect.tr} '
                                    '${controller.currentTerm.displayName}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.white,
                            width: 1,
                            height: 25,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              if (controller.termsCompleted)
                _buildButtonReviewContract(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtonReviewContract(ChatController controller) {
    return GestureDetector(
      onTap: () {
        if (controller.offerNegotiationStatus ==
            NegotiationStatusType.Finalized) {
          Get.to(
            BuyerSubmitContractView(),
            arguments: ContractArgument(
              contractNumber:
                  controller.conversation.negotiationOffer.contractNumber,
              pdfUrl:
                  controller.conversation.negotiationOffer.contractPreviewUrl,
              title: controller.conversation.title,
            ),
          );
        } else {
          Get.to(
            () => BuyerInputContractView(),
            arguments: ContractOverviewArgument(
              conversationId: controller.conversationId,
              chatUser: controller.chatUser,
              sendToUserId: controller.sendToUserId,
              isReview: controller.offerNegotiationStatus ==
                  NegotiationStatusType.FinalizePending,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          LocaleKeys.Chat_Review.tr,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showTermOption(ChatController controller) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            topLeft: Radius.circular(5),
          ),
        ),
        child: ListView.builder(
          itemCount: LookUpController.to.cropYears.length,
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            final item = LookUpController.to.cropYears[index];
            return SizedBox(
              height: 45,
              child: RadioListTile<String>(
                title: Text(item.cropYearName),
                activeColor: kPrimaryColor,
                value: item.cropYearName,
                groupValue: controller.cropYearName.value ?? '',
                onChanged: (String cropYearName) {
                  controller.cropYearName.value = cropYearName;
                  onChanged(cropYearName.split('-').last);
                  Get.back();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
