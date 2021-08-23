import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:agree_n/app/modules/contract/views/buyer_input_contract.view.dart';
import 'package:agree_n/app/modules/contract/views/buyer_submit_contract.view.dart';

class TermDateInput extends StatelessWidget {
  final ValueChanged<DateTime> onChanged;

  const TermDateInput({Key key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: Get.find(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(10,20,10,0),
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: Color(0xffeef7f4),
          ),
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
                    onTap: () async {
                      final selectedDate =
                          await _showDatePicker(context, controller);
                      if (selectedDate != null) {
                        onChanged(selectedDate);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff1d9d6d),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        controller.currentTerm.value != null
                            ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(
                                controller.currentTerm.value.toString()))
                            : '${LocaleKeys.Chat_PleaseSelect.tr} '
                                '${controller.currentTerm.displayName}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
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
        padding: EdgeInsets.all( 10),
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

  Future<DateTime> _showDatePicker(
      BuildContext context, ChatController controller) {
    return showRoundedDatePicker(
      context: context,
      locale: Locale(Get.locale.languageCode),
      initialDate: controller.currentTerm.defaultValue,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour - 2),
      lastDate: DateTime(DateTime.now().year + 10),
      height: MediaQuery.of(context).size.height * 0.4,
      borderRadius: 16,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColor,
        accentTextTheme: TextTheme(
          caption: TextStyle(color: kPrimaryColor),
        ),
      ),
    );
  }
}
