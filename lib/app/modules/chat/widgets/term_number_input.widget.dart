import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:agree_n/app/modules/chat/widgets/button_send_offer.widget.dart';
import 'package:agree_n/app/modules/contract/views/buyer_input_contract.view.dart';
import 'package:agree_n/app/modules/contract/views/buyer_submit_contract.view.dart';

class TermNumberInput extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const TermNumberInput({Key key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(color: Color(0xffeef7f4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.offerNegotiationStatus !=
                      NegotiationStatusType.Finalized &&
                  controller.offerNegotiationStatus !=
                      NegotiationStatusType.FinalizePending)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTermInput(controller),
                      ),
                      if (controller.currentTerm.value != null &&
                          controller.currentTerm.value != '')
                        ButtonSendOffer(),
                    ],
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
    return Container(
      padding: const EdgeInsets.only(top: 10),
      color: Color(0xffeef7f4),
      child: GestureDetector(
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
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10),
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
      ),
    );
  }

  Widget _buildTermInput(ChatController controller) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xff1d9d6d),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller.numberTextController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                onChanged(value);
              },
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              inputFormatters:
                  controller.currentTerm.id == TermTypeIdEnum.CurrencyRate
                      ? [
                          CurrencyTextInputFormatter(
                            symbol: '',
                            decimalDigits: 0,
                          )
                        ]
                      : [],
              decoration: InputDecoration(
                hintText: '${LocaleKeys.Chat_PleaseEnter.tr} '
                    '${controller.currentTerm.displayName}',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
