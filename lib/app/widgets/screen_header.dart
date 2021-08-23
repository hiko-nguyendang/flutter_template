import 'package:flutter/material.dart';

//
import 'package:agree_n/app/theme/theme.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final bool showSubTile;
  final Widget subTile;

  const ScreenHeader(
      {Key key,
      this.title,
      this.showBackButton = false,
      this.showSubTile = false,
      this.subTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: kPrimaryColor, fontSize: 16),
          ),
          if (showSubTile) subTile
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      iconTheme: IconThemeData(color: kPrimaryColor),
      backgroundColor: Colors.white,
    );
  }
}
