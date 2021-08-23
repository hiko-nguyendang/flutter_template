import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/settings/app_config.dart';
import 'package:agree_n/app/widgets/primary_button.dart';
import 'package:agree_n/app/data/providers/dashboard.provider.dart';
import 'package:agree_n/app/data/repositories/dashboard.repository.dart';
import 'package:agree_n/app/widgets/form_rounded_input_field.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/auth.controller.dart';
import 'package:agree_n/app/modules/dashboard/views/supplier_market_pulse_list.view.dart';
import 'package:agree_n/app/modules/dashboard/controllers/market_pulse.controller.dart';

class MarketPulseWidget extends StatelessWidget {
  final AuthController _authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _authController.currentUser.isSupplier
        ? _buildSupplierWidget()
        : _buildBuyerWidget(context);
  }

  Widget _buildBuyerWidget(BuildContext context) {
    return GetBuilder<MarketPulseController>(
      init: Get.put(
        MarketPulseController(
          repository: DashboardRepository(
            apiClient: DashboardProvider(),
          ),
        ),
      ),
      builder: (marketController) {
        return Column(
          children: [
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                LocaleKeys.MarketPulse_Title.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: FormRoundedInputField(
                        controller: marketController.marketPulseInputController,
                        hintText: LocaleKeys
                            .BuyerDashBoard_MarketPulseInputPlaceholder.tr,
                        maxLines: 6,
                        minLines: 6,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        errorStyle: const TextStyle(
                          height: 0,
                          fontSize: 0,
                          color: Colors.transparent,
                        ),
                        validator: MultiValidator(
                          [
                            RequiredValidator(
                              errorText:
                                  LocaleKeys.Shared_FieldRequiredMessage.tr,
                            ),
                          ],
                        ),
                        onSaved: (value) => marketController
                            .marketPulseInputController.text = value.trim(),
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PrimaryButton(
                            width: 100,
                            height: 30,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            labelText: LocaleKeys.Shared_Post.tr,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                marketController.postMarketPulse();
                              }
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.BUYER_MARKET_PULSE);
                            },
                            child: Wrap(
                              spacing: 1,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys.BuyerDashBoard_MyPosts.tr,
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  size: 19,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSupplierWidget() {
    return GetBuilder<MarketPulseController>(
      init: Get.put(
        MarketPulseController(
          repository: DashboardRepository(
            apiClient: DashboardProvider(),
          ),
        ),
      ),
      builder: (marketController) {
        if (marketController.isLoading.value) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return Column(
          children: [
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                LocaleKeys.MarketPulse_Title.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          backgroundImage: NetworkImage(
                            marketController
                                    .latestMarketPulse.value.userImage ??
                                AppConfig.DEFAULT_USER_AVATAR,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            marketController.latestMarketPulse.value.userName,
                            style: TextStyle(
                              color: kPrimaryBlackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          DateFormat('MMM dd, yyyy').format(
                            marketController
                                .latestMarketPulse.value.createdDate,
                          ),
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      marketController.latestMarketPulse.value.message,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => SupplierMarketPulseView());
                          },
                          child: Wrap(
                            spacing: 1,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.Shared_ViewAll.tr,
                                style: TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                              Icon(
                                Icons.arrow_right,
                                size: 19,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
