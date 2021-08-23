import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/widgets/app_bar.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/screen_title.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/widgets/form_rounded_input_field.widget.dart';
import 'package:agree_n/app/modules/dashboard/controllers/market_pulse_detail.controller.dart';

class BuyerMarketPulseFormScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarWidget(),
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitle(
            title: LocaleKeys.MarketPulse_UpdatePost.tr,
            onBack: () {
              Get.offNamed(Routes.BUYER_MARKET_PULSE);
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: GetBuilder<MarketPulseDetailController>(
              init: Get.put(
                MarketPulseDetailController(
                  repository: DashboardRepository(
                    apiClient: DashboardProvider(),
                  ),
                ),
              ),
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kHorizontalContentPadding,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormInputTitle(title: 'Content'),
                        FormRoundedInputField(
                          hintText: '',
                          initialValue: controller.marketPulse.value != null
                              ? controller.marketPulse.value.message
                              : null,
                          maxLines: 5,
                          minLines: 5,
                          maxLength: 500,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          validator: MultiValidator(
                            [
                              RequiredValidator(
                                errorText: LocaleKeys.DashBoard_Error_market_pulse_detail.tr,
                              ),
                            ],
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) {
                            controller.marketPulse.value.message = text.trim();
                          },
                        ),
                        SizedBox(height: 20),
                        RoundedButton(
                          labelText: controller.marketPulse.value != null
                              ? LocaleKeys.Shared_Update.tr
                              : LocaleKeys.Shared_Post.tr,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              controller.updateMarketPulse();
                            }
                          },
                          margin: const EdgeInsets.only(bottom: 20),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class FormInputTitle extends StatelessWidget {
  final String title;

  const FormInputTitle({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: kPrimaryBlackColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
