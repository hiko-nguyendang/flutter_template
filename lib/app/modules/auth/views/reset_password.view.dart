import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/widgets/form_rounded_input_field.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/reset_password.controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.ForgotPassword_ResetPassword.tr),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              Text(
                LocaleKeys.ForgotPassword_VerificationCode.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              FormRoundedInputField(
                onChanged: (code) {
                  if (code != null && code.isNotEmpty) {
                    controller.verificationCode.value = code;
                  }
                },
                validator: RequiredValidator(
                  errorText: LocaleKeys.Shared_FieldRequiredMessage.tr,
                ),
              ),
              SizedBox(height: 20),
              Text(
                LocaleKeys.ForgotPassword_NewPassword.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              FormRoundedInputField(
                onChanged: (password) {
                  if (password != null && password.isNotEmpty) {
                    controller.newPassword.value = password;
                  }
                },
                obscureText: true,
                maxLines: 1,
                validator: RequiredValidator(
                  errorText: LocaleKeys.Shared_FieldRequiredMessage.tr,
                ),
              ),
              SizedBox(height: 20),
              RoundedButton(
                labelText: LocaleKeys.ForgotPassword_ResetPassword.tr,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    controller.resetPassword();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
