import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/utils/term_name.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/models/chat_model.extension.dart';
import 'package:agree_n/app/data/repositories/chat.repository.dart';
import 'package:agree_n/app/data/models/firebase_notification.model.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';
import 'package:agree_n/app/modules/auth/controllers/firebase.controller.dart';

class ChatController extends GetxController {
  final ChatRepository repository;

  ChatController({@required this.repository}) : assert(repository != null);

  FireBaseController _fireBaseController = FireBaseController.to;

  static ChatController to = Get.find();
  static AuthController _authController = Get.find();

  TextEditingController numberWithUnitTextController = TextEditingController();
  TextEditingController numberTextController = TextEditingController();

  Rx<ChatUser> _chatUser = ChatUser().obs;
  Rx<ConversationDetailModel> _conversation = ConversationDetailModel().obs;
  Rx<TermModel> _selectedTerm = TermModel().obs;
  RxInt replyTermId = RxInt();
  RxList<ChatMessage> _chatMessages = RxList<ChatMessage>();
  TermModel _coverMonthTerm;
  TermModel _contractTypeTerm;

  RxBool showTerm = true.obs;
  RxBool isPending = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingTerm = false.obs;
  RxBool isShowFinalizeButton = false.obs;
  RxString priceSymbol = '+'.obs;
  String conversationId;
  int _messagePageIndex = 0;
  int _totalMessage;
  int sendToUserId;
  RxString currentTermContent = "".obs;
  int offerNegotiationStatus;
  bool isFromConversationPage = false;
  RxString cropYearName = RxString();

  //
  final GlobalKey<DashChatState> chatViewKey = GlobalKey<DashChatState>();
  final ScrollController chatScrollController = ScrollController();
  final TextEditingController chatInputController = TextEditingController();
  final GlobalKey<FormState> chatFormKey = GlobalKey<FormState>();

  //
  List<TermModel> terms;

  ConversationDetailModel get conversation => _conversation.value;

  ChatUser get chatUser => _chatUser.value;

  TermModel get currentTerm => _selectedTerm.value;

  List<ChatMessage> get messages => _chatMessages;

  bool get termsCompleted {
    if (terms == null || terms.isEmpty) {
      return false;
    }
    return terms
        .where((_) => _.isNew || _.isDeclined || _.isInProgress)
        .isEmpty;
  }

  bool get isTermInProgress {
    if (terms == null || terms.isEmpty) {
      return false;
    }

    return terms.where((_) => _.isInProgress).isNotEmpty;
  }

  @override
  void onInit() {
    _fireBaseController.isShowNotification = false;
    ever(_fireBaseController.notificationModel, onReceivedMessage);
    _getArgument();
    _setChatUser();
    debugPrint(conversationId);
    if (conversationId != null) {
      getMessages();
      _getConversationDetail();
    } else {
      onCreateConversation();
    }
    super.onInit();
  }

  @override
  void onClose() {
    _fireBaseController.isShowNotification = true;
    chatScrollController.dispose();
    super.onClose();
  }

  void _getArgument() {
    ChatArgument arg = Get.arguments;
    conversationId = arg.conversationId;
    sendToUserId = arg.sendTo;
    if (arg.isFromConversation != null) {
      isFromConversationPage = arg.isFromConversation;
    }
  }

  void _setChatUser() {
    final chatUser = ChatUser(
      name: _authController.currentUser.name,
      uid: _authController.currentUser.id.toString(),
      avatar: _authController.currentUser.imageUrl,
    );
    chatUser.setCustomProperties(user: _authController.currentUser);
    _chatUser.value = chatUser;
    update();
  }

  Future<void> onCreateConversation({bool isReload = true}) async {
    isLoading.value = true;
    ChatArgument arg = Get.arguments;
    CreateConversationInputModel createConversationInputModel =
        CreateConversationInputModel(
      title: arg.conversationName,
      requestId: arg.requestId,
      conversationTypeId: arg.conversationTypeId,
      offerId: arg.offerId,
      creatorId: _authController.currentUser.id,
      participantIds: [arg.contactId],
    );
    try {
      await repository.createConversations(createConversationInputModel).then(
        (response) {
          if (response.statusCode == APIStatus.Successfully) {
            conversationId = response.body;
            _getConversationDetail();
          }
          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
      MessageDialog.showError(message: LocaleKeys.Shared_ErrorMessage.tr);
      throw e;
    }
    update();
  }

  void onReceivedMessage(FirebaseNotificationModel notificationModel) {
    SimpleMessageModel messageModel = SimpleMessageModel.fromJson(
      json.decode(notificationModel.payload),
    );
    if (messageModel.conversationId == conversationId) {
      if (notificationModel.type == FirebaseNotificationType.FinalizePending) {
        isShowFinalizeButton.value = true;
        update();
      }
      if (notificationModel.type == FirebaseNotificationType.ConfirmTerm) {
        if (_authController.currentUser.isBuyer) {
          _buyerReceiveConfirmMessage(notificationModel);
        }
      }
      if (notificationModel.type == FirebaseNotificationType.TermChat) {
        if (_authController.currentUser.isSupplier) {
          _supplierReceiveOfferMessage(notificationModel);
        }
      }
      if (notificationModel.type == FirebaseNotificationType.SimpleChat) {
        _simpleChatMessage(messageModel);
      }
    }
  }

  void _simpleChatMessage(SimpleMessageModel messageModel) {
    var chatMessage = new ChatMessage(
      //Todo: Refactor change to multiple image
      image: messageModel.files != null && messageModel.files.isNotEmpty
          ? messageModel.files.first.url
          : null,
      text: messageModel.text,
      user: ChatUser(
        uid: messageModel.sender.userId.toString(),
        avatar: messageModel.sender.userAvatar,
        name: messageModel.sender.userName,
      ),
    );
    if (messageModel.sender.userId.toString() != chatUser.uid) {
      messages.insert(messages.length, chatMessage);
      scrollToLatestMessage();
      update();
    }
  }

  void _supplierReceiveOfferMessage(
      FirebaseNotificationModel notificationModel) {
    MessageModel messageModel =
        MessageModel.fromJson(json.decode(notificationModel.payload));

    TermMessageModel currentTermModel = messageModel.customData;

    replyTermId.value = currentTermModel.termId;
    currentTermContent.value = messageModel.text;

    terms.firstWhere((_) => _.id == currentTermModel.termId).status =
        currentTermModel.termStatus;

    if (currentTermModel.termStatus != TermStatusEnum.Skipped) {
      var offerMessage = new ChatMessage(
        id: messageModel.id,
        text: messageModel.text,
        user: ChatUser(
          uid: messageModel.sender.userId.toString(),
          avatar: messageModel.sender.userAvatar,
          name: messageModel.sender.userName,
        ),
      );
      offerMessage.setCustomProperties(
        messageName: messageModel.customData.termDisplayName,
        termId: messageModel.customData.termId,
        termStatus: messageModel.customData.termStatus,
      );
      if (messageModel.sender.userId.toString() != chatUser.uid) {
        messages.insert(messages.length, offerMessage);
        scrollToLatestMessage();
      }
    }
    update();
  }

  void _buyerReceiveConfirmMessage(
      FirebaseNotificationModel notificationModel) {
    MessageModel messageModel =
        MessageModel.fromJson(json.decode(notificationModel.payload));
    TermMessageModel termMessageModel = messageModel.customData;
    //
    if (termMessageModel.termId == TermTypeIdEnum.ContractType &&
        termMessageModel.termStatus == TermStatusEnum.Accepted) {
      if (_authController.currentUser.isBuyer) {
        _updateBuyerTermList(termMessageModel);
        _applyPriceUnit(termMessageModel);
      }
    } else {
      terms.firstWhere((_) => _.id == termMessageModel.termId).status =
          termMessageModel.termStatus;
    }
    //
    final listOfferMessages = _chatMessages.where((_) =>
        _.customProperties != null && _.termId == termMessageModel.termId);
    listOfferMessages.last.termStatus = termMessageModel.termStatus;
    if (termMessageModel.termStatus == TermStatusEnum.Accepted) {
      _buyerAutoSelectTerm();
    }
    update();
  }

  void _updateBuyerTermList(TermMessageModel termMessageModel) {
    terms.removeWhere((_) => _.id == _coverMonthTerm.id);
    //Reset term status and value
    for (var item in terms) {
      if (item.id != TermTypeIdEnum.ContractType) {
        item.status = TermStatusEnum.None;
        item.value = null;
      }
    }
    if (TermName.contractTypeName(
            int.parse(termMessageModel.termValue.toString())) ==
        LocaleKeys.TermOptionName_Outright.tr) {
      terms.removeWhere((_) => _.id == _coverMonthTerm.id);
    } else {
      terms.add(_coverMonthTerm);
    }
    //Update Term status
    terms.firstWhere((_) => _.id == termMessageModel.termId).status =
        termMessageModel.termStatus;
    update();
  }

  void _applyPriceUnit(TermMessageModel termMessageModel) {
    final priceTerm = terms.firstWhere((_) => _.id == TermTypeIdEnum.Price);
    if (termMessageModel.termValue == ContractTypeEnum.Outright.toString()) {
      priceTerm.options = LookUpController.to.priceUnits.values;
      priceTerm.unit = priceTerm.options
          .firstWhere(
              (_) => _.termOptionName == LocaleKeys.TermOptionName_VNDKG.tr)
          .id;
    } else {
      priceTerm.options = LookUpController.to.priceUnits.values
          .where((_) => _.termOptionName != LocaleKeys.TermOptionName_VNDKG.tr)
          .toList();
      priceTerm.unit = priceTerm.options
          .firstWhere(
              (_) => _.termOptionName == LocaleKeys.TermOptionName_USDMT.tr)
          .id;
    }
  }

  Future<void> getMessages() async {
    if (_totalMessage == null || _totalMessage > messages.length) {
      final skipMessage = _messagePageIndex * 20;
      await repository.getMessages(conversationId, skipMessage).then(
        (response) {
          if (response != null) {
            List<ChatMessage> result = response.data
                .map<ChatMessage>(
                    (item) => new MessageModel.fromJson(item).toChatMessage)
                .toList();
            messages.insertAll(0, result);
            _totalMessage = response.totalCount;
            _messagePageIndex += 1;
          }
        },
      );
      update();
    }
  }

  Future<void> _getConversationDetail() async {
    isLoading.value = true;
    await repository.getConversationDetail(conversationId).then(
      (response) {
        isLoading.value = false;
        if (response != null) {
          _conversation.value = response;
          sendToUserId = response.participants.first;
          if (response.negotiationOffer != null) {
            _handleNegotiationData(response);
          }
        }
      },
    );
    update();
  }

  void _handleNegotiationData(ConversationDetailModel response) {
    offerNegotiationStatus = response.negotiationOffer.status;
    terms = response.negotiationOffer.terms;
    _coverMonthTerm = response.negotiationOffer.terms
        .firstWhere((_) => _.id == TermTypeIdEnum.CoverMonth);
    _contractTypeTerm =
        terms.firstWhere((_) => _.id == TermTypeIdEnum.ContractType);
    isShowFinalizeButton.value = response.negotiationOffer.status != null &&
        (response.negotiationOffer.status ==
                NegotiationStatusType.FinalizePending ||
            response.negotiationOffer.status ==
                NegotiationStatusType.Finalized);
    _removeUnUseTerm();
    _addDataOptionToTerm();
    _filterTermByContractType();
    _checkInProgressTerm();
    _setPriceUnit();
  }

  void _setPriceUnit() {
    final priceTerm = terms.firstWhere((_) => _.id == TermTypeIdEnum.Price);
    final commodityTerm =
        terms.firstWhere((_) => _.id == TermTypeIdEnum.Commodities);
    //
    if (_contractTypeTerm.value.toString() ==
        ContractTypeEnum.Outright.toString()) {
      priceTerm.unit = priceTerm.options
          .firstWhere(
              (_) => _.termOptionName == LocaleKeys.TermOptionName_VNDKG.tr)
          .id;
    } else if (commodityTerm.value != null) {
      if (TermName.commodityName(int.parse(commodityTerm.value.toString())) ==
          LocaleKeys.TermOptionName_Arabica.tr) {
        priceTerm.unit = priceTerm.options
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_CTLB.tr)
            .id;
      } else {
        priceTerm.unit = priceTerm.options
            .firstWhere(
                (_) => _.termOptionName == LocaleKeys.TermOptionName_USDMT.tr)
            .id;
      }
    }
  }

  void _checkInProgressTerm() {
    final inProgressTerm = terms.firstWhere(
        (_) => _.status == TermStatusEnum.InProgress,
        orElse: () => TermModel());
    if (inProgressTerm.id != null) {
      _selectedTerm.value = inProgressTerm;

      if (_authController.currentUser.isSupplier) {
        replyTermId.value = inProgressTerm.id;
        currentTermContent.value = inProgressTerm.termMessageContent;
      }

      if (inProgressTerm.termInputType ==
          TermInputTypeEnum.NumberWithOptionUnit) {
        _onSelectNumberWithOptionUnit();
      }
    } else {
      if (_authController.currentUser.isBuyer) {
        _selectedTerm.value = terms.first;
      } else {
        replyTermId.value = 0;
      }
    }
    update();
  }

  void _removeUnUseTerm() {
    terms.removeWhere((_) =>
        _.id == TermTypeIdEnum.PriceUnit ||
        _.id == TermTypeIdEnum.QuantityUnit ||
        _.id == TermTypeIdEnum.PackingUnit ||
        _.id == TermTypeIdEnum.ExchangeDate ||
        _.id == TermTypeIdEnum.CurrencyRate ||
        _.id == TermTypeIdEnum.SecurityMargin ||
        _.id == TermTypeIdEnum.MarketPrice);
  }

  void _filterTermByContractType() {
    terms.removeWhere((_) => _.id == _coverMonthTerm.id);
    if (_contractTypeTerm.value != null &&
        TermName.contractTypeName(
                int.parse(_contractTypeTerm.value.toString())) !=
            LocaleKeys.TermOptionName_Outright.tr) {
      terms.add(_coverMonthTerm);
    } else {
      terms.remove(_coverMonthTerm);
    }
  }

  void _addDataOptionToTerm() {
    final priceUnits = LookUpController.to.priceUnits.values;
    final onCallPriceInit = priceUnits
        .where((_) => _.displayName != LocaleKeys.TermOptionName_VNDKG.tr)
        .toList();
    for (final item in terms) {
      switch (item.id) {
        case TermTypeIdEnum.Grade:
          item.options = LookUpController.to.grades.values;
          break;
        case TermTypeIdEnum.Commodities:
          item.options = LookUpController.to.commodities.values;
          break;
        case TermTypeIdEnum.CoffeeType:
          item.options = LookUpController.to.coffeeTypes.values;
          break;
        case TermTypeIdEnum.ContractType:
          item.options = LookUpController.to.contractTypes.values;
          break;
        case TermTypeIdEnum.DeliveryTerms:
          item.options = LookUpController.to.deliveryTerms.values;
          break;
        case TermTypeIdEnum.Price:
          if (TermName.contractTypeName(int.parse(_contractTypeTerm.value)) ==
              LocaleKeys.TermOptionName_Outright.tr) {
            item.options = priceUnits;
          } else {
            item.options = onCallPriceInit;
          }
          break;
        case TermTypeIdEnum.Quantity:
          item.options = LookUpController.to.quantityUnits.values;
          break;
        case TermTypeIdEnum.CoverMonth:
          item.options = LookUpController.to.coverMonthCodes;
          break;
        case TermTypeIdEnum.Packing:
          item.options = LookUpController.to.packingUnitCodes.values;
          break;
        case TermTypeIdEnum.Certification:
          item.options = LookUpController.to.certifications.values;
          break;
      }
    }
  }

  //Simple chat
  void onSendMessage(ChatMessage message) async {
    message.text = message.text.trim();
    MessageInputModel messageInputModel = MessageInputModel(
      eventName: "User_$sendToUserId",
      message: MessageModel(
        messageTypeId: MessageTypeEnum.SimpleMessage,
        sender: MessageUserModel(
          userId: int.parse(chatUser.uid),
          userName: chatUser.name,
          fullName: chatUser.name,
          userAvatar: chatUser.avatar,
        ),
        text: message.text,
        //TODO: Implement for multiple files
        files: [MessageFileModel(url: message.image)],
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now(),
        conversationId: conversationId,
      ),
    );
    _chatMessages.insert(_chatMessages.length, message);
    scrollToLatestMessage();
    update();
    await repository.sendMessage(messageInputModel, conversationId).then(
      (response) {
        if (response == null) {
          MessageDialog.showError();
        }
      },
    );
  }

  Future<void> sendOffer() async {
    if (currentTerm.id == TermTypeIdEnum.CoverMonth) {
      if (int.parse(currentTerm.value) < DateTime.now().year) {
        MessageDialog.showMessage(
          LocaleKeys.CreateOffer_InvalidCoverYear.tr,
        );
        return;
      }
    }
    var offerMessage = new ChatMessage(
      text: currentTerm.termMessageContent,
      user: chatUser,
    );
    offerMessage.setCustomProperties(
      messageName: currentTerm.displayName,
      termId: currentTerm.id,
      termStatus: TermStatusEnum.InProgress,
    );

    _chatMessages.insert(_chatMessages.length, offerMessage);

    currentTerm.status = TermStatusEnum.InProgress;
    scrollToLatestMessage();
    update();

    MessageInputModel messageInputModel = MessageInputModel(
      eventName: "User_$sendToUserId",
      message: MessageModel(
        messageTypeId: MessageTypeEnum.OfferMessage,
        text: currentTerm.termMessageContent,
        customData: TermMessageModel(
          termId: currentTerm.id,
          termStatus: currentTerm.status,
          termValue: currentTerm.id == TermTypeIdEnum.CoverMonth
              ? currentTerm.value.toString().split("/").last
              : currentTerm.value.toString(),
          termUnit: currentTerm.unit.toString(),
          termDisplayName: currentTerm.displayName,
          termContent: currentTerm.termMessageContent,
        ),
        sender: MessageUserModel(
          userId: int.parse(chatUser.uid),
          userName: chatUser.name,
          userAvatar: chatUser.avatar,
          fullName: chatUser.name,
        ),
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now(),
        conversationId: conversationId,
      ),
    );

    await repository.sendMessage(messageInputModel, conversationId).then(
      (response) {
        if (response == null) {
          MessageDialog.showError();
        }
      },
    );
  }

  void onConfirmOffer(bool isAccept) async {
    isPending.value = true;
    //Update message offer status
    final listTermMessages = messages.where(
        (_) => _.customProperties != null && _.termId == replyTermId.value);
    listTermMessages.last.termStatus =
        isAccept ? TermStatusEnum.Accepted : TermStatusEnum.Declined;
    final messageId = listTermMessages.last.id;

    if (replyTermId.value == TermTypeIdEnum.ContractType && isAccept) {
      _updateSupplierTermList(isAccept);
    } else {
      //Update Terms status
      terms.firstWhere((_) => _.id == replyTermId.value).status =
          isAccept ? TermStatusEnum.Accepted : TermStatusEnum.Declined;
    }

    MessageInputModel messageInputModel = MessageInputModel(
      eventName: "User_$sendToUserId",
      message: ReplyOfferModel(
        messageId: messageId,
        termId: replyTermId.value,
        termStatus:
            isAccept ? TermStatusEnum.Accepted : TermStatusEnum.Declined,
        sender: MessageUserModel(
          userId: int.parse(chatUser.uid),
          userName: chatUser.name,
          fullName: _authController.currentUser.name,
          userAvatar: chatUser.avatar,
        ),
      ),
    );
    currentTermContent.value = "";
    isPending.value = false;

    update();
    await repository.confirmTerm(conversationId, messageInputModel).then(
      (response) {
        if (!response) {
          MessageDialog.showError();
        }
      },
    );
  }

  void _updateSupplierTermList(bool isAccept) {
    //Reset Term status
    for (var item in terms) {
      item.status = TermStatusEnum.None;
    }
    if (currentTermContent.value == LocaleKeys.TermOptionName_Outright.tr) {
      terms.removeWhere((_) => _.id == _coverMonthTerm.id);
    } else {
      terms.removeWhere((_) => _.id == _coverMonthTerm.id);
      terms.add(_coverMonthTerm);
    }

    terms.firstWhere((_) => _.id == replyTermId.value).status =
        isAccept ? TermStatusEnum.Accepted : TermStatusEnum.Declined;
    update();
  }

  void changedTermOption(int termType) {
    final editTerm = terms.firstWhere((_) => _.id == termType);
    _selectedTerm.value = editTerm;
    update();
  }

  void onTermUnitChanged(dynamic unit) {
    _selectedTerm.value.unit = unit;
    update();
  }

  void onTermValueChanged(dynamic value) {
    if (currentTerm.id == TermTypeIdEnum.Price) {
      final price = int.parse('$priceSymbol${value.replaceAll(',', "")}');
      if (price < 0) {
        _selectedTerm.value.value = price.toString();
      } else {
        _selectedTerm.value.value = '+$price';
      }
    } else {
      _selectedTerm.value.value = value;
    }
    update();
  }

  void onSkipTerm() {
    terms.firstWhere((_) => _.id == currentTerm.id).status =
        TermStatusEnum.Skipped;
    update();
    _sendSkipMessage();
  }

  Future<void> _sendSkipMessage() async {
    MessageInputModel messageInputModel = MessageInputModel(
      eventName: "User_$sendToUserId",
      message: MessageModel(
        messageTypeId: MessageTypeEnum.OfferMessage,
        text: "",
        customData: TermMessageModel(
          termId: currentTerm.id,
          termStatus: TermStatusEnum.Skipped,
          termValue: null,
          termUnit: null,
          termDisplayName: currentTerm.displayName,
          termContent: "",
        ),
        sender: MessageUserModel(
          userId: int.parse(chatUser.uid),
          userName: chatUser.name,
          userAvatar: chatUser.avatar,
          fullName: chatUser.name,
        ),
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now(),
        conversationId: conversationId,
      ),
    );
    await repository.sendMessage(messageInputModel, conversationId).then(
      (response) {
        _buyerAutoSelectTerm();
      },
    );
  }

  void onSelectTerm(TermModel term) {
    _selectedTerm.value = term;
    if (term.termInputType == TermInputTypeEnum.NumberWithOptionUnit) {
      _onSelectNumberWithOptionUnit();
    }
    if (term.termInputType == TermInputTypeEnum.Number) {
      numberTextController.text = currentTerm.value != null
          ? currentTerm.value.toString()
          : currentTerm.defaultValue != null
              ? currentTerm.defaultValue.toString()
              : '';
    }
    for (var item in terms) {
      if (item.isSelecting) {
        item.isSelecting = false;
      }
    }

    _selectedTerm.value.isSelecting = true;
    update();
  }

  void _onSelectNumberWithOptionUnit() {
    if (currentTerm.id == TermTypeIdEnum.CoverMonth) {
      numberWithUnitTextController.text = currentTerm.value != null
          ? currentTerm.value.toString().split('/')[1]
          : '';
    } else if (currentTerm.id == TermTypeIdEnum.Price) {
      numberWithUnitTextController.text =
          currentTerm.value != null && currentTerm.value.toString().isNotEmpty
              ? NumberFormat().format(
                  double.parse(currentTerm.value.toString().replaceAll(",", ""))
                      .abs())
              : '';
    } else {
      numberWithUnitTextController.text = currentTerm.value != null
          ? currentTerm.value.toString()
          : currentTerm.defaultValue != null
              ? currentTerm.defaultValue.toString()
              : '';
    }
  }

  void _buyerAutoSelectTerm() {
    if (_authController.currentUser.isBuyer) {
      var term = terms.firstWhere((_) => _.isNew || _.isDeclined,
          orElse: () => TermModel());
      if (term.id != null) {
        onSelectTerm(term);
      }
    }
  }

  Future<void> onSelectImage(bool isFromCamera) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (pickedFile != null) {
      final File _image = File(pickedFile.path);
      await repository.uploadAttachment(_image).then(
        (response) {
          if (response != null) {
            var chatMessage = ChatMessage(
              text: '',
              user: chatUser,
              image: response,
            );
            onSendMessage(chatMessage);
          } else {
            MessageDialog.showError();
          }
        },
      );
    }
  }

  Future<void> onSelectFile() async {
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (file != null) {
      await repository.uploadAttachment(file).then(
        (response) {
          if (response != null) {
            var chatMessage = ChatMessage(
              text: '',
              user: chatUser,
              image: response,
            );
            onSendMessage(chatMessage);
          } else {
            MessageDialog.showError();
          }
        },
      );
    }
  }

  void scrollToLatestMessage() {
    Timer(
      Duration(milliseconds: 150),
      () {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      },
    );
  }

  void displayTerm() {
    showTerm.value = !showTerm.value;
    update();
  }

  void onSymbolChanged(String text) {
    priceSymbol.value = text;
    var price = currentTerm.value.toString().replaceAll("+", '').replaceAll("-", "");
    currentTerm.value = '$text$price';
    update();
  }
}
