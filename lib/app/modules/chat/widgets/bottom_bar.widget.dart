import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:agree_n/app/modules/chat/widgets/term_date_input.widget.dart';
import 'package:agree_n/app/modules/chat/widgets/term_select_input.widget.dart';
import 'package:agree_n/app/modules/chat/widgets/term_text_input.widget.dart';
import 'package:agree_n/app/modules/chat/widgets/term_range_input.widget.dart';
import 'package:agree_n/app/modules/chat/widgets/term_number_input.widget.dart';
import 'package:agree_n/app/modules/contract/views/buyer_submit_contract.view.dart';
import 'package:agree_n/app/modules/chat/widgets/term_number_with_unit_input.widget.dart';

class ChatBottomBar extends StatelessWidget {
  final ChatController controller;
  final AuthController _authController = AuthController.to;

  ChatBottomBar({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Supplier inputs
    if (_authController.currentUser.isSupplier) {
      return _buildConfirmSession();
    }

    // Buyer inputs
    if (_authController.currentUser.isBuyer) {
      if (controller.currentTerm.termInputType == TermInputTypeEnum.Number) {
        return TermNumberInput(
          onChanged: (value) {
            controller.onTermValueChanged(value);
          },
        );
      }

      if (controller.currentTerm.termInputType == TermInputTypeEnum.Range) {
        return TermRangeInput(
          onChanged: (value) {
            controller.onTermValueChanged(value);
            controller.sendOffer();
          },
        );
      }

      if (controller.currentTerm.termInputType == TermInputTypeEnum.Text) {
        return TermTextInput(
          onChanged: (value) {
            controller.onTermValueChanged(value);
          },
        );
      }

      if (controller.currentTerm.termInputType == TermInputTypeEnum.DropDown) {
        return TermSelectInput(
          onChanged: (value) {
            controller.onTermValueChanged(value);
            controller.sendOffer();
          },
        );
      }

      if (controller.currentTerm.termInputType == TermInputTypeEnum.DateTime) {
        return TermDateInput(
          onChanged: (value) {
            controller.onTermValueChanged(value);
            //
            controller.sendOffer();
          },
        );
      }

      if (controller.currentTerm.termInputType ==
          TermInputTypeEnum.NumberWithOptionUnit) {
        return TermNumberWithUnitInput(
          onChanged: (value) {
            controller.onTermValueChanged(value);
          },
        );
      }

      return SizedBox();
    }

    return SizedBox();
  }

  Widget _buildConfirmSession() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.topLeft,
      color: Color(0xffeef7f4),
      child: Column(
        children: [
          if (controller.currentTermContent.value != null &&
              controller.currentTermContent.value != "")
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: Text(
                        controller.currentTermContent.value ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff1d9d6d),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (!controller.isPending.value) {
                        controller.onConfirmOffer(false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        LocaleKeys.Chat_Decline.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (!controller.isPending.value) {
                        controller.onConfirmOffer(true);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xff1d9d6d),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        LocaleKeys.Chat_Accept.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          _buildReviewAndFinalizeButton(),
        ],
      ),
    );
  }

  Widget _buildReviewAndFinalizeButton() {
    if (_authController.currentUser.hasFinalizeContract &&
        controller.isShowFinalizeButton.value) {
      return GestureDetector(
        onTap: () {
          if (controller.offerNegotiationStatus ==
              NegotiationStatusType.Finalized) {
            Get.to(
              () => BuyerSubmitContractView(),
              arguments: ContractArgument(
                contractNumber:
                    controller.conversation.negotiationOffer.contractNumber,
                pdfUrl:
                    controller.conversation.negotiationOffer.contractPreviewUrl,
                title: controller.conversation.title,
              ),
            );
          } else {
            Get.toNamed(
              Routes.FINALIZE_CONTRACT,
              arguments: FinalizeArgument(
                conversationId: controller.conversationId,
                isView: false,
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            LocaleKeys.Chat_FinalizeContract.tr,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (controller.termsCompleted) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(
            Routes.FINALIZE_CONTRACT,
            arguments: FinalizeArgument(
              conversationId: controller.conversationId,
              isView: true,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          color: Color(0xffeef7f4),
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
    return SizedBox();
  }
}
