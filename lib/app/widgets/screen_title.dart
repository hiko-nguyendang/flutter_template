import 'package:agree_n/app/theme/theme.dart';

//
import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const ScreenTitle({Key key, this.title, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kHorizontalContentPadding,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
              size: 25,
            ),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                color: kPrimaryColor,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }
}
