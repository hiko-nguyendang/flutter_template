import 'package:flutter/material.dart';

//
import 'package:agree_n/app/theme/theme.dart';

class FormRoundedInputField extends StatelessWidget {
  FormRoundedInputField(
      {this.controller,
      this.initialValue,
      this.style,
      this.fillColor,
      this.iconPrefix,
      this.labelText,
      this.hintText,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.minLines = 1,
      this.maxLines,
      this.maxLength,
      this.errorStyle,
      this.borderRadius = const BorderRadius.all(Radius.circular(50)),
      this.contentPadding =
          const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      this.onChanged,
      this.onSaved});

  final TextEditingController controller;
  final String initialValue;
  final IconData iconPrefix;
  final TextStyle style;
  final Color fillColor;
  final String labelText;
  final String hintText;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle errorStyle;
  final void Function(String) onChanged;
  final void Function(String) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor != null ? fillColor : kPrimaryColor.withOpacity(0.04),
        labelText: labelText,
        hintText: hintText,
        errorStyle: errorStyle,
        prefixIcon: iconPrefix != null
            ? Icon(
                iconPrefix,
                size: 20,
              )
            : null,
        contentPadding: contentPadding,
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: kErrorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: kErrorColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      initialValue: initialValue,
      style: style,
      maxLength: maxLength,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
    );
  }
}
