import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/data/models/chat_model.extension.dart';
import 'package:agree_n/app/modules/chat/widgets/bottom_bar.widget.dart';
import 'package:agree_n/app/modules/chat/controllers/chat.controller.dart';

class ChatMainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Theme(
        data: ThemeData(),
        child: GetBuilder<ChatController>(
          init: Get.find(),
          builder: (chatController) {
            return DashChat(
              key: chatController.chatViewKey,
              scrollController: chatController.chatScrollController,
              textController: chatController.chatInputController,
              width: double.infinity,
              messages: chatController.messages,
              showUserAvatar: false,
              alwaysShowSend: true,
              inputDisabled: chatController.offerNegotiationStatus ==
                  NegotiationStatusType.Finalized,
              onSend: (chatMessage) {
                chatController.onSendMessage(chatMessage);
              },
              onLongPressMessage: (chatMessage) {},
              sendOnEnter: true,
              scrollToBottom: false,
              inputMaxLines: 3,
              onLoadEarlier: () {
                chatController.getMessages();
              },
              messageBuilder: (chatMessage) {
                return _buildMessage(chatController, chatMessage);
              },
              user: chatController.chatUser,
              inputContainerStyle: BoxDecoration(color: Color(0xffeef7f4)),
              inputToolbarPadding: const EdgeInsets.all(5),
              sendButtonBuilder: (onSend) {
                return chatController
                            .chatInputController.value.text.isNotEmpty &&
                        chatController.chatInputController.value.text
                            .trim()
                            .isNotEmpty
                    ? _buildSendButton(onSend, chatController)
                    : SizedBox();
              },
              chatFooterBuilder: () {
                return ChatBottomBar(controller: chatController);
              },
              inputToolbarMargin: EdgeInsets.zero,
              inputDecoration: _buildMessageInputDecoration(context, chatController),
              dateFormat: DateFormat('yyyy MMM dd'),
              timeFormat: DateFormat('HH:mm'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSendButton(Function onSend, ChatController chatController) {
    return GestureDetector(
      onTap: () async {
        await onSend();
        chatController.scrollToLatestMessage();
      },
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFF1d9d6d),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  InputDecoration _buildMessageInputDecoration(
      BuildContext context, ChatController chatController) {
    return InputDecoration(
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              _openAttachmentOption(chatController);
            },
            child: Icon(
              Icons.attach_file,
              size: 20,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 5),
            child: GestureDetector(
              onTap: () {
                chatController.onSelectImage(true);
              },
              child: Icon(
                Icons.camera_alt,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        borderSide: BorderSide(
          color: kPrimaryGreyColor.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        borderSide: BorderSide(color: kPrimaryColor),
      ),
      hintText: LocaleKeys.Chat_InputHint.tr,
    );
  }

  Widget _buildMessage(ChatController chatController, ChatMessage chatMessage) {
    final imageExtension = ["jpg", "png", "jpeg"];

    ///Custom message
    if (chatMessage.customProperties != null) {
      return _buildCustomMessage(chatMessage, chatController);
    }

    ///Image message
    if (chatMessage.image != null &&
        imageExtension.contains(chatMessage.image.split(".").last))
      return _buildImageMessage(chatMessage, chatController.chatUser);

    ///Attachment message
    if (chatMessage.image != null) {
      return _buildAttachmentMessage(chatMessage, chatController.chatUser);
    }

    ///General message
    return _buildGeneralMessage(chatMessage, chatController.chatUser);
  }

  Widget _buildAttachmentMessage(ChatMessage chatMessage, ChatUser chatUser) {
    return Container(
      alignment: chatMessage.user.uid == chatUser.uid
          ? Alignment.topRight
          : Alignment.topLeft,
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: chatMessage.user.uid == chatUser.uid
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              await canLaunch(chatMessage.image)
                  ? await launch(chatMessage.image)
                  : throw 'Could not launch url';
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                color: chatMessage.user.uid == chatUser.uid
                    ? Color(0xff616161)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Text(
                    chatMessage.image.split("_").last,
                    style: TextStyle(
                      fontSize: 14,
                      color: chatMessage.user.uid == chatUser.uid
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 1,
                    width: 150,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  Text(
                    LocaleKeys.MarketPrice_Open.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: chatMessage.user.uid == chatUser.uid
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (chatMessage.text != null && chatMessage.text.isNotEmpty)
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: chatMessage.user.uid == chatUser.uid
                    ? Color(0xff616161)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                chatMessage.text,
                style: TextStyle(
                  fontSize: 14,
                  color: chatMessage.user.uid == chatUser.uid
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          Text(
            DateFormat('hh:mm').format(chatMessage.createdAt),
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralMessage(ChatMessage chatMessage, ChatUser chatUser) {
    return Container(
      alignment: chatMessage.user.uid == chatUser.uid
          ? Alignment.topRight
          : Alignment.topLeft,
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: chatMessage.user.uid == chatUser.uid
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: chatMessage.user.uid == chatUser.uid
                  ? Color(0xff616161)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              chatMessage.text ?? '',
              style: TextStyle(
                fontSize: 14,
                color: chatMessage.user.uid == chatUser.uid
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          Text(
            DateFormat('hh:mm').format(chatMessage.createdAt),
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildImageMessage(ChatMessage chatMessage, ChatUser chatUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      alignment: chatMessage.user.uid == chatUser.uid
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Column(
        crossAxisAlignment: chatMessage.user.uid == chatUser.uid
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: chatMessage.user.uid == chatUser.uid
                  ? Color(0xff616161)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              height: 150,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(chatMessage.image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Text(
            DateFormat('hh:mm').format(chatMessage.createdAt),
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMessage(
      ChatMessage chatMessage, ChatController chatController) {
    return GestureDetector(
      onLongPress: () {
        chatController.changedTermOption(chatMessage.termId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        alignment: chatMessage.user.uid == chatController.chatUser.uid
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Column(
          crossAxisAlignment:
              chatMessage.user.uid == chatController.chatUser.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: chatMessage.user.uid == chatController.chatUser.uid
                      ? Color(0xff616161)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      chatMessage.messageName ??
                          TermTypeIdEnum.getName(chatMessage.termId),
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            chatMessage.user.uid == chatController.chatUser.uid
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        chatMessage.text ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1d9d6d),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildOfferStatus(chatMessage),
                ],
              ),
            ),
            Text(
              DateFormat('hh:mm').format(chatMessage.createdAt),
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferStatus(ChatMessage chatMessage) {
    if (chatMessage.termStatus == TermStatusEnum.Accepted)
      return Icon(
        Icons.done_all,
        color: kPrimaryColor,
        size: 23,
      );
    if (chatMessage.termStatus == TermStatusEnum.Declined)
      return Icon(
        Icons.clear,
        color: Colors.red,
        size: 25,
      );

    return SizedBox();
  }

  void _openAttachmentOption(ChatController chatController) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: kHorizontalContentPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                chatController.onSelectImage(false);
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryGreyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.image_outlined,
                        size: 25,
                        color: kPrimaryBlackColor,
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.Chat_Media.tr,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          LocaleKeys.Chat_MediaDescription.tr,
                          style: TextStyle(
                              fontSize: 12,
                              color: kPrimaryGreyColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.5),
              thickness: 0.5,
            ),
            InkWell(
              onTap: () {
                chatController.onSelectFile();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryGreyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.insert_drive_file_outlined,
                        size: 25,
                        color: kPrimaryBlackColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.Chat_File.tr,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          LocaleKeys.Chat_FileDescription.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: kPrimaryGreyColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black.withOpacity(0.5),
              thickness: 0.5,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: Text(
                  LocaleKeys.Shared_Cancel.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black38,
    );
  }
}
