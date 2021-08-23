import 'package:flutter/material.dart';
import 'package:agree_n/app/theme/theme.dart';

class RoundedButton extends StatelessWidget {
  final String labelText;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color textColor;
  final bool disabled;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final EdgeInsets margin;
  final VoidCallback onPressed;

  const RoundedButton({
    Key key,
    this.labelText,
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    this.margin = const EdgeInsets.all(0),
    this.backgroundColor = kPrimaryColor,
    this.textColor = Colors.white,
    this.disabled = false,
    this.onPressed,
    this.suffixIcon,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: RaisedButton(
        color: backgroundColor,
        onPressed: disabled ? null : onPressed,
        padding: padding,
        disabledColor: Colors.grey.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            if (prefixIcon != null)
              Icon(prefixIcon, color: textColor, size: 20),
            Text(
              labelText,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (suffixIcon != null)
              Icon(suffixIcon, color: textColor, size: 20),
          ],
        ),
      ),
    );
  }
}
