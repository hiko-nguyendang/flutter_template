import 'package:get/get.dart';
import 'package:flutter/material.dart';


import 'package:agree_n/app/enums/enums.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/utils/message_dialog.dart';
import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/models/contract.model.dart';
import 'package:agree_n/app/data/models/conversation.model.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';

class FinalizeContractController extends GetxController {
  ContractRepository repository;

  FinalizeContractController({@required this.repository})
      : assert(repository != null);

  RxBool isCodeNotValid = false.obs;
  ContractModel contract = ContractModel();
  ConversationDetailModel conversationDetail = ConversationDetailModel();
  RxBool isLoading = false.obs;
  int _offerNegotiationId;
  String title;
  bool isView;

  @override
  void onInit() {
    final FinalizeArgument ar = Get.arguments;
    if (ar.conversationId != null) {
      isView = ar.isView;
      _getContractDetail(ar.conversationId);
    }
    super.onInit();
  }

  Future _getContractDetail(String conversationId) async {
    isLoading.value = true;
    await repository.getConversationDetail(conversationId).then(
      (response) {
        isLoading.value = false;
        if (response != null) {
          conversationDetail = response;
          title = response.title;
          if (response.negotiationOffer != null) {
            contract.contractNumber = response.negotiationOffer.contractNumber;
            _setTermValue(response.negotiationOffer.terms);
            _offerNegotiationId = response.negotiationOffer.offerNegotiationId;
          }
        }
        update();
      },
    );
    update();
  }

  void _setTermValue(List<TermModel> terms) {
    terms.forEach(
      (term) {
        if (term.value != null) {
          switch (term.id) {
            case TermTypeIdEnum.ContractType:
              contract.contractType = int.parse(term.value);
              break;
            case TermTypeIdEnum.Commodities:
              contract.commodity = int.parse(term.value);
              break;
            case TermTypeIdEnum.CoffeeType:
              contract.coffeeType = int.parse(term.value);
              break;
            case TermTypeIdEnum.Grade:
              contract.grade = int.parse(term.value);
              break;
            case TermTypeIdEnum.Quantity:
              contract.quantity =
                  double.parse(term.value.toString().replaceAll(",", ""));
              contract.quantityUnit = int.parse(term.unit);
              break;
            case TermTypeIdEnum.DeliveryDate:
              contract.deliveryDate = DateTime.parse(term.value);
              break;
            case TermTypeIdEnum.Price:
              contract.price =
                  double.parse(term.value.toString().replaceAll(",", ""));
              contract.priceUnit = int.parse(term.unit);
              break;
            case TermTypeIdEnum.CoverMonth:
              contract.coverMonthValue = term.value;
              break;
            case TermTypeIdEnum.DeliveryTerms:
              contract.deliveryTerm = int.parse(term.value);
              break;
            case TermTypeIdEnum.SpecialClause:
              contract.specialClause = term.value;
              break;
            case TermTypeIdEnum.ExchangeDate:
              contract.exchangeDate = DateTime.parse(term.value);
              break;
            case TermTypeIdEnum.MarketPrice:
              if (term.value == null || term.value.toString().isEmpty) {
                contract.marketPrice = 0;
              } else {
                contract.marketPrice =
                    double.parse(term.value.toString().replaceAll(",", ""));
              }
              break;
            case TermTypeIdEnum.CurrencyRate:
              if (term.value == null || term.value.toString().isEmpty) {
                contract.currencyRate = 0;
              } else {
                contract.currencyRate =
                    double.parse(term.value.toString().replaceAll(",", ""));
              }
              break;
            case TermTypeIdEnum.CropYear:
              if (term.value == null || term.value.toString().isEmpty) {
                contract.cropYear = '';
              } else {
                contract.cropYear = term.value.toString();
              }
              break;
            case TermTypeIdEnum.SecurityMargin:
              if (term.value == null || term.value.toString().isEmpty) {
                contract.securityMargin = 0;
              } else {
                contract.securityMargin = double.parse(
                  term.value.toString().replaceAll(",", ""),
                );
              }
              break;
            case TermTypeIdEnum.Packing:
              contract.packing = double.parse(
                term.value.toString().replaceAll(",", ""),
              );
              contract.packingUnit = int.parse(term.unit);
              break;
            case TermTypeIdEnum.Certification:
              if (term.value == null || term.value.toString().isEmpty) {
                contract.certification = 0;
              } else {
                contract.certification = int.parse(term.value);
              }
              break;
          }
        }
      },
    );
  }

  Future<void> onFinalize() async {
    MessageDialog.showLoading();
    await repository.finalizeContract(_offerNegotiationId).then(
      (response) {
        MessageDialog.hideLoading();
        if (response != null) {
          MessageDialog.showMessage(
            LocaleKeys.SubmitContract_SuccessMessage.tr,
            textColor: Colors.grey,
            title: LocaleKeys.SubmitContract_SuccessMessageTitle.tr,
            onClosed: () {
              Get.offAllNamed(Routes.CONTACTS);
/*              Get.to(
                BuyerSubmitContractView(),
                arguments: ContractArgument(
                  contractNumber: contract.contractNumber,
                  pdfUrl: response,
                  title: title,
                ),
              );*/
            },
          );
        } else {
          MessageDialog.showError();
        }
      },
    );
    update();
  }
}
