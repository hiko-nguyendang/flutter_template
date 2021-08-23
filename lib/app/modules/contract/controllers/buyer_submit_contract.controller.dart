import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

import 'package:agree_n/app/data/models/arguments.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';

class BuyerSubmitContractController extends GetxController {
  ContractRepository repository;

  BuyerSubmitContractController({@required this.repository})
      : assert(repository != null);

  Rx<PDFDocument> pdfDocument = Rx<PDFDocument>();
  RxBool isLoading = false.obs;
  String contractNumber;
  String title;

  @override
  void onInit() async {
    ContractArgument argument = Get.arguments;
    contractNumber = argument.contractNumber;
    title = argument.title;
    pdfDocument.value = await PDFDocument.fromURL(argument.pdfUrl);
    update();
    super.onInit();
  }
}
