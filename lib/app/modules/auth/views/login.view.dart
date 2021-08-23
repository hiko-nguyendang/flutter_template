import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/widgets/app_logo.widget.dart';
import 'package:agree_n/app/widgets/rounded_button.widget.dart';
import 'package:agree_n/app/widgets/form_rounded_input_field.widget.dart';
import 'package:agree_n/app/modules/auth/controllers/login.controller.dart';

class LoginView extends GetView<LoginController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: Get.height,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: Get.height * 0.25),
                    AppLogo(),
                    SizedBox(height: 30.0),
                    FormRoundedInputField(
                      controller: controller.emailController,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      errorStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.red[900],
                        fontWeight: FontWeight.w600,
                        backgroundColor: Colors.white.withOpacity(0.6),
                      ),
                      fillColor: Colors.white.withOpacity(0.75),
                      iconPrefix: Icons.email,
                      hintText: LocaleKeys.Login_Email.tr,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText:
                                LocaleKeys.Login_MessageEmailRequired.tr),
                        EmailValidator(
                          errorText: LocaleKeys.Login_MessageEmailInvalid.tr,
                        ),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          controller.emailController.text = value,
                    ),
                    SizedBox(height: 20.0),
                    FormRoundedInputField(
                      controller: controller.passwordController,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      errorStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.red[900],
                        fontWeight: FontWeight.w600,
                        backgroundColor: Colors.white.withOpacity(0.6),
                      ),
                      fillColor: Colors.white.withOpacity(0.75),
                      iconPrefix: Icons.lock,
                      hintText: LocaleKeys.Login_Password.tr,
                      validator: MultiValidator(
                        [
                          RequiredValidator(
                            errorText:
                                LocaleKeys.Login_MessagePasswordRequired.tr,
                          ),
                        ],
                      ),
                      obscureText: true,
                      onChanged: (value) => null,
                      onSaved: (value) =>
                          controller.passwordController.text = value,
                      maxLines: 1,
                    ),
                    SizedBox(height: 20.0),
                    RoundedButton(
                      labelText: LocaleKeys.Login_SignIn.tr,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          controller.loginUser();
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    FlatButton(
                      // color: Colors.white.withOpacity(0.7),
                      minWidth: Get.width,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text(
                        LocaleKeys.Login_ResetPassword.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
                    ),
                    FlatButton(
                      // color: Colors.white.withOpacity(0.7),
                      minWidth: Get.width,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text(
                        LocaleKeys.Login_SignUpLabelButton.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Get.toNamed(Routes.REGISTER),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
