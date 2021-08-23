import 'package:get/get.dart';

import 'package:agree_n/app/modules/chat/controllers/conversation.controller.dart';

class ConversationMiddleWare extends GetMiddleware{
  @override
  onPageBuildStart(page) {
    ConversationController.to.getConversation();
    return super.onPageBuildStart(page);
  }
}