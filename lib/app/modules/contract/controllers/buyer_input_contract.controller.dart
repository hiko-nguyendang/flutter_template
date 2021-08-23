import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';

import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/base/controllers/lookup.controller.dart';

class BuyerInputContactController extends GetxController {
  ContractRepository repository;

  BuyerInputContactController({@required this.repository})
      : assert(repository != null);

  final LookUpController _lookUpController = Get.find();
  final textController = TextEditingController();

  RxBool isContactNumberNotValid = false.obs;
  RxString contractNumber = "".obs;
  String _conversationId;
  ChatUser chatUser;
  String title;
  int _sendToUserId;
  bool isReview;

  Rx<ContractModel> _contract = ContractModel().obs;

  RxBool isLoading = false.obs;

  ContractModel get contract => _contract.value;

  @override
  void onInit() {
    _getArgument();
    _getConversationDetail();
    super.onInit();
  }

  void _getArgument() {
    final ContractOverviewArgument arg = Get.arguments;
    _conversationId = arg.conversationId;
    _sendToUserId = arg.sendToUserId;
    chatUser = arg.chatUser;
    isReview = arg.isReview;
  }

  void onSelectedLocation(int index) {
    contract.location = _lookUpController.locations[index].id;
    update();
  }

  Future<void> _getConversationDetail() async {
    isLoading.value = true;
    await repository.getConversationDetail(_conversationId).then(
      (response) {
        isLoading.value = false;
        if (response != null) {
          title = response.title;
          if (response.negotiationOffer != null) {
            contract.location = response.negotiationOffer.locationCode;
            if (isReview) {
              contractNumber.value = response.negotiationOffer.contractNumber;
            }
            _setTermValue(response.negotiationOffer.terms);
          }
        }
        update();
      },
    );
    update();
  }

  void onNext() {
    if (contractNumber.value == null || contractNumber.value.isEmpty) {
      isContactNumberNotValid.value = true;
    } else {
      isContactNumberNotValid.value = false;
      _sendFinalizeMessage();
    }
    update();
  }

  void _setTermValue(List<TermModel> terms) {
    for (final item in terms) {
      if (item.value != null) {
        switch (item.id) {
          case TermTypeIdEnum.ContractType:
            contract.contractType = int.parse(item.value);
            break;
          case TermTypeIdEnum.Commodities:
            contract.commodity = int.parse(item.value);
            break;
          case TermTypeIdEnum.CoffeeType:
            contract.coffeeType = int.parse(item.value);
            break;
          case TermTypeIdEnum.Grade:
            contract.grade = int.parse(item.value);
            break;
          case TermTypeIdEnum.Quantity:
            contract.quantity =
                double.parse(item.value.toString().replaceAll(",", ""));
            contract.quantityUnit = int.parse(item.unit);
            break;
          case TermTypeIdEnum.DeliveryDate:
            contract.deliveryDate = DateTime.parse(item.value);
            break;
          case TermTypeIdEnum.Price:
            contract.price =
                double.parse(item.value.toString().replaceAll(",", ""));
            contract.priceUnit = int.parse(item.unit);
            break;
          case TermTypeIdEnum.CoverMonth:
            contract.coverMonthValue = item.value;
            break;
          case TermTypeIdEnum.DeliveryTerms:
            contract.deliveryTerm = int.parse(item.value);
            break;
          case TermTypeIdEnum.SpecialClause:
            contract.specialClause = item.value.toString() ?? "";
            break;
          case TermTypeIdEnum.ExchangeDate:
            contract.exchangeDate = DateTime.parse(item.value);
            break;
          case TermTypeIdEnum.MarketPrice:
            if (item.value == null || item.value.toString().isEmpty) {
              contract.marketPrice = 0;
            } else {
              contract.marketPrice =
                  double.parse(item.value.toString().replaceAll(",", ""));
            }
            break;
          case TermTypeIdEnum.CurrencyRate:
            if (item.value == null || item.value.toString().isEmpty) {
              contract.currencyRate = 0;
            } else {
              contract.currencyRate =
                  double.parse(item.value.toString().replaceAll(",", ""));
            }
            break;
          case TermTypeIdEnum.CropYear:
            if (item.value == null || item.value.toString().isEmpty) {
              contract.cropYear = '';
            } else {
              contract.cropYear = item.value.toString();
            }
            break;
          case TermTypeIdEnum.SecurityMargin:
            if (item.value == null || item.value.toString().isEmpty) {
              contract.securityMargin = 0;
            } else {
              contract.securityMargin =
                  double.parse(item.value.toString().replaceAll(",", ""));
            }
            break;
          case TermTypeIdEnum.Packing:
            contract.packing =
                double.parse(item.value.toString().replaceAll(",", ""));
            contract.packingUnit = int.parse(item.unit);
            break;
          case TermTypeIdEnum.Certification:
            if (item.value == null || item.value.toString().isEmpty) {
              contract.certification = 0;
            } else {
              contract.certification = int.parse(item.value);
            }
            break;
        }
      }
    }
  }

  Future<void> _sendFinalizeMessage() async {
    MessageDialog.showLoading();
    MessageInputModel messageInputModel = MessageInputModel(
      eventName: "User_$_sendToUserId",
      message: MessageModel(
        messageTypeId: MessageTypeEnum.FinalizeMessage,
        sender: MessageUserModel(
          userId: int.parse(chatUser.uid),
          userName: chatUser.name,
          fullName: chatUser.name,
          userAvatar: chatUser.avatar,
        ),
        text: "",
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now(),
        conversationId: _conversationId,
        deliveryWarehouseId: contract.location,
        contractNumber: contractNumber.value,
      ),
    );
    await repository
        .sendFinalizeMessage(messageInputModel, _conversationId)
        .then(
      (response) {
        MessageDialog.hideLoading();
        if (response) {
          Get.offAllNamed(Routes.CONTACTS);
        } else {
          MessageDialog.showError();
        }
      },
    );
  }

  void contractNumberChange(String value) {
    contractNumber.value = value;
    update();
  }
}
