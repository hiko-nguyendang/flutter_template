import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:agree_n/app/modules/chat/widgets/term_unit_input.widget.dart';
import 'package:agree_n/app/modules/chat/widgets/button_send_offer.widget.dart';
import 'package:agree_n/app/modules/contract/views/buyer_input_contract.view.dart';
import 'package:agree_n/app/modules/contract/views/buyer_submit_contract.view.dart';

class TermNumberWithUnitInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final Widget unitInput;

  const TermNumberWithUnitInput({Key key, this.unitInput, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isShowSendButton(ChatController controller) {
      if ((controller.currentTerm.value != null &&
              controller.currentTerm.unit != null) &&
          controller.numberWithUnitTextController.text.isNotEmpty &&
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.offerNegotiationStatus !=
                      NegotiationStatusType.Finalized &&
                  controller.offerNegotiationStatus !=
                      NegotiationStatusType.FinalizePending)
                Expanded(
                  child: _buildTermInput(controller),
                ),
              if (controller.termsCompleted)
                _buildButtonReviewContract(controller),
              if (isShowSendButton(controller)) ButtonSendOffer(),
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
    final contractTypeTerm =
        controller.terms.firstWhere((_) => _.id == TermTypeIdEnum.ContractType);
    bool isShowSymbol() {
      return controller.currentTerm.id == TermTypeIdEnum.Price &&
          TermName.contractTypeName(
                  int.parse(contractTypeTerm.value.toString())) !=
              LocaleKeys.TermOptionName_Outright.tr;
    }

    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xff1d9d6d),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          if (isShowSymbol()) _symbolSelect(controller),
          Expanded(
            child: _numberInput(controller),
          ),
          Container(
            color: Colors.white,
            height: 20,
            width: 1,
            margin: const EdgeInsets.only(right: 15),
          ),
          TermUnitInput(),
        ],
      ),
    );
  }

  Widget _numberInput(ChatController controller) {
    return TextFormField(
      controller: controller.numberWithUnitTextController,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: controller.currentTerm.id != TermTypeIdEnum.CoverMonth
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
    );
  }

  Widget _symbolSelect(ChatController controller) {
    return GestureDetector(
      onTap: () {
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
              itemCount: ["+", "-"].length,
              primary: false,
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final item = ["+", "-"][index];
                return SizedBox(
                  height: 45,
                  child: RadioListTile<String>(
                    title: Text(item),
                    activeColor: kPrimaryColor,
                    value: item,
                    groupValue: controller.priceSymbol.value,
                    onChanged: (String symbol) {
                      controller.onSymbolChanged(symbol);
                      Get.back();
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
      child: SizedBox(
        width: 30,
        child: Row(
          children: [
            Text(
              controller.priceSymbol.value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
