import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/widgets/search_box.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/widgets/loading_bottom.widget.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/modules/chat/controllers/conversation.controller.dart';

class ConversationsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationController>(
      init: Get.find(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: AppBarWidget(),
            automaticallyImplyLeading: false,
            elevation: 0,
            titleSpacing: 0,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(kHorizontalContentPadding),
                child: SearchBox(
                  hintText: LocaleKeys.Messages_SearchHint.tr,
                  onSearch: (text) {
                    controller.getConversation(keyword: text);
                  },
                ),
              ),
              Expanded(
                child: controller.isLoading.value
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : controller.conversations.isEmpty
                        ? Center(
                            child: Text(LocaleKeys.Chat_NoConversation.tr),
                          )
                        : SmartRefresher(
                            controller: controller.refreshController,
                            footer: LoadingBottomWidget(),
                            enablePullDown: false,
                            enablePullUp: controller.hasMore,
                            onLoading: () {
                              controller.getConversation(isReload: false);
                            },
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: kHorizontalContentPadding,
                              ),
                              itemCount: controller.conversations.length,
                              itemBuilder: (context, index) {
                                final message = controller.conversations[index];
                                return _buildMessageItem(message, controller);
                              },
                            ),
                          ),
              ),
            ],
          ),
          bottomNavigationBar: AppBottomNavigationBar(),
        );
      },
    );
  }

  Widget _buildMessageItem(
      ConversationModel message, ConversationController controller) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            controller.deleteConversation(message.id);
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          message.unreadMessageCount = 0;
          controller.update();
          Get.toNamed(
            Routes.CHAT,
            arguments: ChatArgument(
              conversationId: message.id,
              conversationName: message.title,
              sendTo: message.participants.first,
              isFromConversation: true,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: kPrimaryGreyColor,
                width: 0.2,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundColor: kPrimaryGreyColor.withOpacity(0.5),
                  child: message.avatarUrl == null || message.avatarUrl.isEmpty
                      ? Text(
                          _avatarName(message.title),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: kPrimaryGreyColor, width: 0.5),
                            image: DecorationImage(
                              image: NetworkImage(message.avatarUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        message.title ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      message.lastMessage ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: message.unreadMessageCount > 0
                            ? Colors.black
                            : kPrimaryGreyColor.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller
                        .getLastMessageTime(message.lastSeen ?? DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      color: message.unreadMessageCount > 0
                          ? kPrimaryBlackColor
                          : kPrimaryGreyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (message.unreadMessageCount > 0)
                    Container(
                      height: 20,
                      width: 20,
                      margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        message.unreadMessageCount.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (message.statusId == ConversationStatusEnum.Finalized)
                    Icon(
                      Icons.check_circle,
                      size: 21,
                      color: kPrimaryColor,
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _avatarName(String title) {
    if (title == null) {
      return "";
    }
    final names = title.split(' ');

    if (names.length == 1) {
      return title[0];
    }
    return '${title[0]}${title.split(" ")[1][0]}';
  }
}
