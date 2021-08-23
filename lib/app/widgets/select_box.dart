import 'package:agree_n/app/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectBox extends StatelessWidget {
  final String hintText;
  final String value;
  final VoidCallback onTap;
  final bool hasIcon;

  const SelectBox({
    Key key,
    this.hintText,
    this.value,
    this.onTap,
    this.hasIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(
            horizontal: kHorizontalContentPadding, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(100),
          color: kPrimaryColor.withOpacity(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                (value != null && value.isNotEmpty) ? value : hintText,
                style: TextStyle(
                  fontSize: 14,
                  color: (value != null && value.isNotEmpty)
                      ? kPrimaryBlackColor
                      : kHintTextColor.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasIcon)
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: kPrimaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
