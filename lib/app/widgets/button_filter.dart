import 'package:agree_n/app/theme/theme.dart';
import 'package:flutter/material.dart';

class ButtonFilter extends StatelessWidget {
  final VoidCallback onTap;

  const ButtonFilter({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              offset: Offset(0, 0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Icon(
          Icons.tune,
          color: kPrimaryColor,
          size: 20,
        ),
      ),
    );
  }
}