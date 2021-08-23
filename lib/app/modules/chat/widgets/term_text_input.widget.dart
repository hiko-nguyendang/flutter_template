import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:agree_n/app/modules/chat/widgets/button_send_offer.widget.dart';
import 'package:agree_n/app/modules/contract/views/buyer_input_contract.view.dart';
import 'package:agree_n/app/modules/contract/views/buyer_submit_contract.view.dart';

class TermTextInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const TermTextInput({Key key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isShowSendButton(ChatController controller) {
      if (controller.currentTerm.value != null &&
          controller.currentTerm.value != '' &&
          controller.currentTerm.value.toString().trim().isNotEmpty &&
          controller.offerNegotiationStatus !=
              NegotiationStatusType.Finalized &&
          controller.offerNegotiationStatus !=
              NegotiationStatusType.FinalizePending) {
        return true;
      } else {
        return false;
      }
    }

    return GetBuilder<ChatController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(color: Color(0xffeef7f4)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.offerNegotiationStatus !=
                      NegotiationStatusType.Finalized &&
                  controller.offerNegotiationStatus !=
                      NegotiationStatusType.FinalizePending)
                Expanded(
                  child: _buildTermInput(controller),
                ),
              if (!controller.isTermInProgress &&
                  controller.offerNegotiationStatus !=
                      NegotiationStatusType.Finalized &&
                  controller.offerNegotiationStatus !=
                      NegotiationStatusType.FinalizePending)
                GestureDetector(
                  onTap: () {
                    controller.onSkipTerm();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kPrimaryGreyColor)),
                    child: Text(
                      LocaleKeys.Chat_Skip.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kPrimaryBlackColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              if (controller.termsCompleted)
                _buildButtonReviewContract(controller),
              if (isShowSendButton(controller)) ButtonSendOffer()
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
        padding: EdgeInsets.all(10),
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

  Widget _buildTermInput(ChatController controller) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Color(0xff1d9d6d),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextFormField(
        initialValue: controller.currentTerm.value != null
            ? controller.currentTerm.value.toString()
            : controller.currentTerm.defaultValue != null
                ? controller.currentTerm.defaultValue.toString()
                : '',
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        maxLines: 1,
        decoration: InputDecoration(
          hintText: '${LocaleKeys.Chat_PleaseEnter.tr}',
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }
}
