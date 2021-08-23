import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:form_field_validator/form_field_validator.dart';

//
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/widgets/form_rounded_input_field.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/forgot_password.controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.ForgotPassword_Title.tr),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Text(LocaleKeys.ForgotPassword_Description.tr),
              SizedBox(height: 20),
              FormRoundedInputField(
                iconPrefix: Icons.email,
                hintText: LocaleKeys.ForgotPassword_Hint.tr,
                validator: MultiValidator(
                  [
                    RequiredValidator(
                      errorText: LocaleKeys.Shared_EmailRequired.tr,
                    ),
                    EmailValidator(
                      errorText: LocaleKeys.Shared_EmailInvalid.tr,
                    ),
                  ],
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (email) {
                  if (email != null && email.isNotEmpty) {
                    controller.email.value = email;
                  }
                },
              ),
              SizedBox(height: 20),
              RoundedButton(
                labelText: LocaleKeys.ForgotPassword_ResetPassword.tr,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    controller.forgotPassword(controller.email.value);
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
