import 'package:get/get.dart';

import 'package:agree_n/app/data/repositories/chat.repository.dart';
import 'package:agree_n/app/data/providers/chat.provider.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';
import 'package:agree_n/app/modules/chat/controllers/conversation.controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(
        repository: ChatRepository(
          apiClient: ChatProvider(),
        ),
      ),
    );
    Get.lazyPut<ConversationController>(
      () => ConversationController(
        repository: ChatRepository(
          apiClient: ChatProvider(),
        ),
      ),
    );
  }
}
