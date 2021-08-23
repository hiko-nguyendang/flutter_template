import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final String hintText;
  final void Function(String) onChanged;
  final int maxLines;
  final double radius;
  final String initValue;
  final bool readOnly;
  final int maxLength;
  final bool useFormatNumber;
  final FocusNode focusNode;
  final bool hasBorder;
  final Color fillColor;
  final EdgeInsetsGeometry contentPadding;

  InputBox({
    Key key,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.onChanged,
    this.maxLines = 1,
    this.radius = 100,
    this.initValue,
    this.maxLength,
    this.useFormatNumber = true,
    this.readOnly = false,
    @required this.focusNode,
    this.hasBorder = true,
    this.fillColor,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder border() {
      if (hasBorder) {
        return OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(radius),
        );
      } else {
        return InputBorder.none;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: KeyboardActions(
        disableScroll: true,
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
          keyboardBarColor: Colors.white,
          actions: [
            KeyboardActionsItem(
              focusNode: focusNode,
              displayArrows: false,
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          maxLength: maxLength,
          initialValue: initValue,
          readOnly: readOnly,
          validator: validator ??
              (newText) {
                if (newText == null || newText.isEmpty) {
                  return LocaleKeys.Shared_FieldRequiredMessage.tr;
                }
                return null;
              },
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters:
              keyboardType == TextInputType.number && useFormatNumber
                  ? [
                      CurrencyTextInputFormatter(
                        symbol: '',
                        decimalDigits: 0,
                      )
                    ]
                  : [],
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? kPrimaryColor.withOpacity(0.05),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              color: kHintTextColor,
              fontWeight: FontWeight.w300,
            ),
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: kHorizontalContentPadding,
                  vertical: 10,
                ),
            enabledBorder: border(),
            focusedErrorBorder: border(),
            focusedBorder: border(),
            errorBorder: border(),
          ),
        ),
      ),
    );
  }
}
