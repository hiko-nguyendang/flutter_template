import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/modules/chat/widgets/layout.widget.dart';
import 'package:agree_n/app/modules/chat/widgets/terms.widget.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';

class ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatController>(
        init: Get.find(),
        builder: (controller) {
          if (controller.isLoading.value)
            return Container(
              alignment: Alignment.center,
              child: CupertinoActivityIndicator(),
            );
          return SafeArea(
            child: Column(
              children: [
                _buildHeader(controller),
                SwipeGestureRecognizer(
                  onSwipeDown: (){
                    controller.displayTerm();
                  },
                  onSwipeUp: (){
                    controller.displayTerm();
                  },
                  child: Column(
                    children: [
                      if (controller.showTerm.value) ChatTerms(),
                      if (controller.terms != null && controller.terms.isNotEmpty)
                        _buildButtonShowTerm(controller),
                      Divider(color: Colors.black),
                    ],
                  ),
                ),
                Expanded(
                  child: ChatMainLayout(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonShowTerm(ChatController controller) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: GestureDetector(
        onTap: (){
          controller.displayTerm();
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            controller.showTerm.value ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ChatController chatController) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        kHorizontalContentPadding,
        GetPlatform.isIOS ? 0 : 10,
        kHorizontalContentPadding,
        5,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (chatController.isFromConversationPage) {
                Get.offNamed(Routes.CONVERSATIONS);
              } else {
                Get.back(
                  result: ChatArgument(
                    conversationId: chatController.conversationId,
                  ),
                );
              }
            },
            child: Icon(
              Icons.arrow_back,
              size: 25,
              color: kPrimaryColor,
            ),
          ),
          Expanded(
            child: Text(
              chatController.conversation.title ?? "",
              style: TextStyle(
                fontSize: 18,
                color: kPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 25)
        ],
      ),
    );
  }
}
