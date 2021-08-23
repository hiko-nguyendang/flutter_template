import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/widgets/bottom_navigation_bar.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/data/providers/contract.provider.dart';
import 'package:agree_n/app/data/repositories/contract.repository.dart';
import 'package:agree_n/app/modules/contract/controllers/buyer_submit_contract.controller.dart';

class BuyerSubmitContractView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: GetBuilder<BuyerSubmitContractController>(
        init: BuyerSubmitContractController(
          repository: ContractRepository(
            apiClient: ContractProvider(),
          ),
        ),
        builder: (controller) {
          return Column(
            children: [
              _buildHeader(controller),
              controller.isLoading.value
                  ? Expanded(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : Expanded(
                      child: controller.pdfDocument.value != null
                          ? PDFViewer(
                              document: controller.pdfDocument.value,
                              zoomSteps: 2,
                              showNavigation: false,
                              showPicker: false,
                            )
                          : SizedBox(),
                    ),
              RoundedButton(
                margin: EdgeInsets.all(kHorizontalContentPadding),
                labelText: LocaleKeys.Shared_Done.tr,
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildHeader(BuyerSubmitContractController controller) {
    return Container(
      padding: EdgeInsets.all(kHorizontalContentPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 5),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: kPrimaryColor,
                size: 25,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  controller.title ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff1d9d6d),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${LocaleKeys.Chat_ContractNumber.tr}'
                  ' ${controller.contractNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    color: kPrimaryBlackColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(width: 25),
        ],
      ),
    );
  }
}
